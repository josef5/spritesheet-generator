#!/bin/sh

#  SpriteSheetGenerator.sh
#  SpritesheetUI
#
#  Created by Jose Espejo on 03/05/2018.
#  Copyright © 2018 Jose Espejo. All rights reserved.

: '
echo "filename: $1"
echo "dimensions: $2"
echo "folder: $3"
echo "path: $4"
echo "fps: $5"
echo "jpeg quality: $6"
echo "tiles: $7"
'

filename=$1
dimensions=$2
base_path=$3
video_path=$4
fps=$5
jpeg_quality=$6
tiles=$7

# Parse name without file extension
filename_only=(${filename// /_})
filename_only=(${filename_only//./ })
#full_name=$filename
#filename_only=(${filename//./ })
echo $filename_only
echo $video_path

# Set output folder name
output_folder_path="$base_path"/"$filename_only"_spritesheet

# Checks if folder exists and appends a number to the name.
# Returns a path.
function get_folder_name {
	
	folder=$1
	
	path=$(dirname "$folder")
	new_name=$(basename "$folder")
	
	if [ -d "$path/$new_name" ]; then

		i=2

		while [[ -d ${path}/${new_name}_${i} ]] ; do
			let i++
		done

		new_name=${new_name}_${i}

	fi
	
	echo "$path/$new_name"
	
}

output_folder_path=$(get_folder_name "$output_folder_path")

echo $output_folder_path

mkdir -v "$output_folder_path"

# Make subfolders
mkdir -v "$output_folder_path"/spritesheets
spritesheet_folder_path="$output_folder_path"/spritesheets

mkdir -v "$output_folder_path"/frames
frame_folder_path="$output_folder_path"/frames



# ffmpeg process
/usr/local/bin/ffmpeg -i "$video_path" -f image2 -vf fps=fps="$fps" "$frame_folder_path"/img%03d.png

# Uncompressed pngs for editing
mkdir -v "$spritesheet_folder_path"/pngs
png_spritesheets_folder="$spritesheet_folder_path"/pngs
/usr/local/bin/montage "$frame_folder_path"/img*.png -tile "$tiles" -geometry "$dimensions"+0+0 "$png_spritesheets_folder"/sprite.png

# Compressed jpgs in spritesheets folder
/usr/local/bin/montage "$frame_folder_path"/img*.png -tile "$tiles" -geometry "$dimensions"+0+0 -quality "$jpeg_quality" "$spritesheet_folder_path"/sprite0%d.jpg




# For image sequence starting from 1
function rename_image_sequence {

    spritesheet_folder_path="$1"
    image_number=1

    cd "$spritesheet_folder_path"

    for i in sprite**.jpg; do

        new_name=$(printf "_sprite%d.jpg" "$image_number")

        mv -v "$i" "$new_name"

        ((image_number++))

    done

    # Remove temporary "_"
    for f in _sprite**.jpg; do

        mv -v "$f" "${f/_/}"

    done

}

rename_image_sequence "$spritesheet_folder_path"

# Log file
frames=("$frame_folder_path"/img***.png)
framesNum=${#frames[@]}

printf $"Frames: $framesNum\nFramerate: $fps fps\nTiles: $tiles" > "$output_folder_path"/log.txt

