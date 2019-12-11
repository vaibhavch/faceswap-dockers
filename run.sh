#!/bin/bash

MODEL_PATH='/Users/vaibhav/Downloads/face_swap_docker/models'
SOURCE_PATH='/Users/vaibhav/Downloads/face_swap_docker/sources'
TARGET_PATH='/Users/vaibhav/Downloads/face_swap_docker/targets'
OUTPUT_PATH='/Users/vaibhav/Downloads/face_swap_docker/output'
CONFIG_PATH='/Users/vaibhav/Downloads/face_swap_docker/config.cfg'

docker run -it --rm -v ${MODEL_PATH}:/root/face_swap/models -v ${SOURCE_PATH}:/root/face_swap/sources -v ${TARGET_PATH}:/root/face_swap/targets -v ${OUTPUT_PATH}:/root/face_swap/output -v ${CONFIG_PATH}:/root/face_swap/bin/config.cfg chrisvee/face-swap:cpu
	#-it --rm \
	#-e app=face_swap_single2many \
	#-e args="--cfg ${tgt_config_path}" \
	#-v $1:${tgt_config_path} \
	#v ${MODEL_PATH}:/root/face_swap/models \
	#-v ${SOURCE_PATH}:/root/face_swap/sources \
	#-v ${TARGET_PATH}:/root/face_swap/targets \
	#-v ${OUTPUT_PATH}:/root/face_swap/output \
	#chrisvee/face-swap:cpu
	#/bin/bash -c "/root/face_swap/bin/face_swap_single2many --cfg ${tgt_config_path}"
    
    # ffmpeg -i giphy.mp4 targets/thumb%04d.jpg -hide_banner
	# ./face_swap_single2many --cfg config.cfg
	# ffmpeg -framerate 10  -i output/s_thumb%04d.jpg lol.mp4
