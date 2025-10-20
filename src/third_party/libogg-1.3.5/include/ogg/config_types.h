#ifndef __CONFIG_TYPES_H__
#define __CONFIG_TYPES_H__

// These types are standard for Emscripten/Wasm32
#include <stdint.h>

typedef int16_t ogg_int16_t;
_Static_assert(sizeof(ogg_int16_t) == 2, "ogg_int16_t must be 2 bytes");

typedef uint16_t ogg_uint16_t;
_Static_assert(sizeof(ogg_uint16_t) == 2, "ogg_uint16_t must be 2 bytes");

typedef int32_t ogg_int32_t;
_Static_assert(sizeof(ogg_int32_t) == 4, "ogg_int32_t must be 4 bytes");

typedef uint32_t ogg_uint32_t;
_Static_assert(sizeof(ogg_uint32_t) == 4, "ogg_uint32_t must be 4 bytes");

typedef int64_t ogg_int64_t;
_Static_assert(sizeof(ogg_int64_t) == 8, "ogg_int64_t must be 8 bytes");

typedef uint64_t ogg_uint64_t;
_Static_assert(sizeof(ogg_uint64_t) == 8, "ogg_uint64_t must be 8 bytes");

#endif