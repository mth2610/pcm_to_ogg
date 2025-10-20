cmake_minimum_required(VERSION 3.10)
project(vorbis_static C)

# Add include directories for the build
include_directories(
    # For public headers like vorbis/codec.h
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    # For internal headers in the lib folder
    ${CMAKE_CURRENT_SOURCE_DIR}/lib
)

# Define the source files
set(VORBIS_SOURCES
    lib/analysis.c
    lib/barkmel.c
    lib/bitrate.c
    lib/block.c
    lib/codebook.c
    lib/envelope.c
    lib/floor0.c
    lib/floor1.c
    lib/info.c
    lib/lookup.c
    lib/lpc.c
    lib/lsp.c
    lib/mapping0.c
    lib/mdct.c
    lib/psy.c
    lib/registry.c
    lib/res0.c
    lib/sharedbook.c
    lib/smallft.c
    lib/synthesis.c
    lib/tone.c
    lib/vorbisenc.c
    lib/vorbisfile.c
    lib/window.c
)

# Add the static library target
add_library(vorbis_static STATIC ${VORBIS_SOURCES})

# Expose the public include directory to other targets
target_include_directories(vorbis_static PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Link against ogg. This requires the main CMakeLists.txt to add the ogg directory first.
target_link_libraries(vorbis_static PRIVATE ogg_static)