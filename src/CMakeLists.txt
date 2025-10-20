cmake_minimum_required(VERSION 3.10)
project(pcm_to_ogg C)

# The order is important: ogg is needed by vorbis.
add_subdirectory(third_party/libogg-1.3.5)
add_subdirectory(third_party/libvorbis-1.3.7)

# Create a library from our C wrapper source file.
add_library(pcm_to_ogg_library
    pcm_to_ogg.c
)

# Link our library against the vorbis static library.
# vorbis_static already links against ogg_static.
target_link_libraries(pcm_to_ogg_library PRIVATE vorbis_static)

# Add the include directories from our third-party libs
# so our pcm_to_ogg.c can find the headers.
target_include_directories(pcm_to_ogg_library PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/third_party/libogg-1.3.5/include
    ${CMAKE_CURRENT_SOURCE_DIR}/third_party/libvorbis-1.3.7/include
)

# --- Web Specific ---
if(FLUTTER_TARGET_WEB)
    add_library(pcm_to_ogg STATIC
        pcm_to_ogg.c
    )
    target_link_libraries(pcm_to_ogg PRIVATE vorbis_static)
    set_target_properties(pcm_to_ogg PROPERTIES
        OUTPUT_NAME "pcm_to_ogg"
        SUFFIX ".wasm"
    )
endif()

# --- Android Specific ---
# Create a shared library for Android (JNI) from our static library.
# The name here must match what is loaded in the Dart code.
if(ANDROID)
    add_library(pcm_to_ogg SHARED
        # We create an "empty" shared library and then link our static
        # library to it. This effectively wraps our static lib in a shared lib.
        pcm_to_ogg.c
    )
    target_link_libraries(pcm_to_ogg PRIVATE pcm_to_ogg_library)
endif()
