#!/bin/bash

# This script compiles the C source code into a release-mode WebAssembly module.

# Exit immediately if a command exits with a non-zero status.
set -e

OPTIMIZATION_FLAGS="-O3 --closure 1"

# Define the output path for the pre-compiled distributable assets.
OUTPUT_DIR="lib/src/web/precompiled"
OUTPUT_FILE="$OUTPUT_DIR/pcm_to_ogg.js"

# Create the output directory if it doesn't exist.
mkdir -p $OUTPUT_DIR

echo "Compiling for WebAssembly in RELEASE mode..."
source /Users/mth2610/Desktop/flutter_plugins/emsdk/emsdk_env.sh

emcc \
    $OPTIMIZATION_FLAGS \
    -s MALLOC=emmalloc \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s EXPORT_ES6=1 -s MODULARIZE=1 -s EXPORT_NAME='createPcmToOggModule' \
    -s "EXPORTED_FUNCTIONS=['_malloc', '_free', '_encode_pcm_to_ogg', '_get_ogg_output_data', '_get_ogg_output_size', '_free_ogg_output']" \
    -s "EXPORTED_RUNTIME_METHODS=['HEAPF32', 'HEAPU8']" \
    -I src/third_party/libogg-1.3.5/include \
    -I src/third_party/libvorbis-1.3.7/include \
    -I src/third_party/libvorbis-1.3.7/lib \
    src/third_party/libogg-1.3.5/src/bitwise.c \
    src/third_party/libogg-1.3.5/src/framing.c \
    src/third_party/libvorbis-1.3.7/lib/analysis.c \
    src/third_party/libvorbis-1.3.7/lib/barkmel.c \
    src/third_party/libvorbis-1.3.7/lib/bitrate.c \
    src/third_party/libvorbis-1.3.7/lib/block.c \
    src/third_party/libvorbis-1.3.7/lib/codebook.c \
    src/third_party/libvorbis-1.3.7/lib/envelope.c \
    src/third_party/libvorbis-1.3.7/lib/floor0.c \
    src/third_party/libvorbis-1.3.7/lib/floor1.c \
    src/third_party/libvorbis-1.3.7/lib/info.c \
    src/third_party/libvorbis-1.3.7/lib/lookup.c \
    src/third_party/libvorbis-1.3.7/lib/lpc.c \
    src/third_party/libvorbis-1.3.7/lib/lsp.c \
    src/third_party/libvorbis-1.3.7/lib/mapping0.c \
    src/third_party/libvorbis-1.3.7/lib/mdct.c \
    src/third_party/libvorbis-1.3.7/lib/psy.c \
    src/third_party/libvorbis-1.3.7/lib/registry.c \
    src/third_party/libvorbis-1.3.7/lib/res0.c \
    src/third_party/libvorbis-1.3.7/lib/sharedbook.c \
    src/third_party/libvorbis-1.3.7/lib/smallft.c \
    src/third_party/libvorbis-1.3.7/lib/synthesis.c \
    src/third_party/libvorbis-1.3.7/lib/tone.c \
    src/third_party/libvorbis-1.3.7/lib/vorbisenc.c \
    src/third_party/libvorbis-1.3.7/lib/vorbisfile.c \
    src/third_party/libvorbis-1.3.7/lib/window.c \
    src/pcm_to_ogg.c \
    -o $OUTPUT_FILE

echo "Successfully created release artifacts in $OUTPUT_DIR"