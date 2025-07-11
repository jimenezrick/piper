#!/bin/bash

set -eu

MODEL=en_GB-cori-high
CUDAENV=~/bin/cuda.env

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

(
	cd $SCRIPT_DIR
	source $CUDAENV

	if [ ! -d .env ]
	then
		python3 -m venv  .env
		source .env/bin/activate

		pip install piper-tts
		pip uninstall onnxruntime onnxruntime-gpu
		pip install onnxruntime-gpu
		python -m piper.download_voices en_GB-cori-high
	fi

	source .env/bin/activate

	echo 'Sure, you are welcome to fuck yourself!' | piper \
	    --cuda --model $MODEL \
	    --output-raw | \
	    aplay -r 22050 -f S16_LE -t raw -
)
