cmake_minimum_required(VERSION 3.10)
project(ogg_static C)

# Add the include directory for the build
include_directories(include)

# Add the source files to create the static library
add_library(ogg_static STATIC
    src/bitwise.c
    src/framing.c
)

# Expose the include directory to other targets that link against this library
target_include_directories(ogg_static PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)