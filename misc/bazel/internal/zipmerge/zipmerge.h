#pragma once

#include <cstdlib>
#include <cstdint>
#include <string_view>

struct output_cd_t {
  uint8_t* bytes;
  uint32_t length;
  uint32_t capacity;
};

inline output_cd_t output_cd{};  // An in-memory buffer in which the central-directory records for
                                 // the output file are accumulated.

// Read and write little-endian integers (as the only supported host platforms are little-endian,
// and all host platforms support unaligned memory accesses, these macros are currently very
// simple).
#define read2(ptr) (*(uint16_t*)(ptr))
#define read4(ptr) (*(uint32_t*)(ptr))
#define write2(ptr, val) (*(uint16_t*)(ptr) = (val))
#define write4(ptr, val) (*(uint32_t*)(ptr) = (val))

// Add the bytes [src, src + len) to the output's central-directory.
void append_cd(const uint8_t* src, uint32_t len);

// Test whether a given filename should be included in the output zip.
// Note that if a call returns true for a given filename, all future calls with the same filename
// will return false.
bool should_include_filename_now(const uint8_t* name, uint32_t len);

inline constexpr std::string_view eocd_signature = "\x50\x4b\x05\x06";
const uint8_t* find_eocd(const uint8_t* input_file, size_t input_file_len);

int zipmerge_main(int argc, const char** argv);

void reset();
