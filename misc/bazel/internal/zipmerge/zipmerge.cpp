/*
  Utility for munging zip files.

  The high-level pseudo-code is:
    for each input zip Z:
      for each file F in Z:
        F.name = adjust(F.name)
        if F.name should be included:
          write F to the output zip

  File inclusion testing consists of two parts:
    1. Don't include anything matching an explicit removal list.
    2. If the same filename occurs in multiple input zips, only include the file from the last input
       zip.

  Filename adjustment consists of optionally prepending a prefix to the filename.
*/

#include "misc/bazel/internal/zipmerge/zipmerge.h"

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <Windows.h>
#define unlink(s) DeleteFileA(s)
#else
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#endif

#include <string_view>

namespace {
struct {
  FILE* file;
  uint32_t num_bytes_written;
  uint16_t num_files_written;
} output_zip{};  // The zip file being written.

struct {
  uint8_t* bytes;
  uint16_t length;
} filename_prefix{};  // A string to prepend to all filenames added to the output file.

constexpr size_t maximum_input_files = 1000;
struct {
  int count;
  struct {
    const char* prefix;
    const char* name;
  } entries[maximum_input_files];
} input_files;  // A list of input zip files.

static bool verbose;                  // If true, more things are written to stdout.
static const char* output_file_name;  // The name of the output zip file.
static const char*
    current_input_file_name;  // The name of the current input zip file (used for diagnostics).

constexpr size_t filename_hash_table_size = 0x20000;
typedef struct {
  uint32_t hash;
  uint32_t len;
  const uint8_t* data;
} hash_entry_t;

// A hash set containing the name of everything so far written to the output file.
static hash_entry_t filename_hash_table[filename_hash_table_size];

constexpr size_t maximum_removals = 1000;
struct removal_entry {
  // A removal entry can either be a literal string, or a wildcard containing a single "*".
  // In the former case, the literal string is called the head. In the latter case, the
  // segment before the "*" is called the head, and the segment after the "*" is called the tail.
  uint32_t head_len;
  uint32_t tail_len;  // zero for literal removals, possibly zero for wildcard removals
  const uint8_t* head;
  const uint8_t* tail;  // NULL for literal removals, non-NULL for wildcard removals
};

struct {
  int count;
  removal_entry entries[maximum_removals];
} removals;  // A list of files and directories to ignore in input files.

// Sizes and signatures of zip file structures (central-directory, local-file-header,
// end-of-central-directory).
constexpr size_t cd_size = 46;
constexpr std::string_view cd_signature = "\x50\x4b\x01\x02";
constexpr size_t lfh_size = 30;
constexpr std::string_view lfh_signature = "\x50\x4b\x03\x04";
constexpr size_t eocd_size = 22;

// Write the bytes [src, src + len) to the output file.
void append_data(const uint8_t* src, uint32_t len) {
  if (fwrite(src, 1, len, output_zip.file) != len) {
    printf("Error: Could not write %lu bytes to output file.\n", (unsigned long)len);
    exit(1);
  }
  uint32_t new_output_size = output_zip.num_bytes_written + len;
  if (new_output_size < output_zip.num_bytes_written) {
    printf("Error: Output zip file exceeds 4 gigabytes.\n");
    exit(1);
  }
  output_zip.num_bytes_written = new_output_size;
}
}  // namespace

void append_cd(const uint8_t* src, uint32_t len) {
  if ((output_cd.capacity - output_cd.length) < len) {
    uint32_t new_capacity;
    uint8_t* new_data;

    new_capacity = output_cd.capacity + (output_cd.capacity >> 1);
    if (new_capacity < output_cd.length + len) new_capacity = output_cd.length + len;
    new_data = (uint8_t*)realloc(output_cd.bytes, new_capacity);
    if (!new_data) {
      printf("Error: Could not grow central-directory buffer from %lu bytes to %lu bytes.\n",
             (unsigned long)output_cd.capacity, (unsigned long)new_capacity);
      exit(1);
    }
    output_cd.bytes = new_data;
    output_cd.capacity = new_capacity;
  }
  memcpy(output_cd.bytes + output_cd.length, src, len);
  output_cd.length += len;
}

namespace {
// Copy a local-file-header and accompanying file data from an input file to the output file.
// The input file is [input_file, input_file + input_file_len).
// The offset within the input file of the local-file-header is given by lfh_offset.
// The central-directory entry corresponding to the file is given by cd.
void copy_file_data(const uint8_t* input_file,
                    size_t lfh_offset,
                    const uint8_t* cd,
                    size_t input_file_len) {
  if (lfh_offset >= input_file_len || (size_t)(input_file_len - lfh_offset) < lfh_size) {
    printf("Error: %s is invalid; central-directory references local-file-header at offset %llu, "
           "but file is only %llu bytes.\n",
           current_input_file_name, (unsigned long long)lfh_offset,
           (unsigned long long)input_file_len);
    exit(1);
  }

  const uint8_t* lfh = input_file + lfh_offset;
  if (memcmp(lfh, lfh_signature.data(), lfh_signature.size()) != 0) {
    printf("Error: Expected local-file-header signature at offset %llu of %s, but instead got %02x "
           "%02x %02x %02x.\n",
           (unsigned long long)lfh_offset, current_input_file_name, lfh[0], lfh[1], lfh[2], lfh[3]);
    exit(1);
  }

  size_t data_offset = lfh_offset + lfh_size;
  uint16_t name_len = read2(lfh + 26);
  uint16_t extra_len = read2(lfh + 28);
  uint32_t data_len = read4(cd + 20);
  append_data(lfh, 6);  // signature, version
  // flags, compression, mod-time, mod-date, crc-32, compressed-size, uncompressed-size, name-len
  append_data(cd + 8, 22);
  append_data(lfh + 28, 2);  // extra-len

  size_t total_variable_len = (size_t)name_len + (size_t)extra_len + (size_t)data_len;
  if ((size_t)(input_file_len - data_offset) < total_variable_len) {
    printf(
        "Error: %s is invalid; starting at offset %llu, reading a filename of %u bytes, extra data "
        "of %u bytes, and %lu bytes of compressed data would exceed file size of %llu bytes.\n",
        current_input_file_name, (unsigned long long)data_offset, (unsigned)name_len,
        (unsigned)extra_len, (unsigned long)data_len, (unsigned long long)input_file_len);
    exit(1);
  }
  append_data(filename_prefix.bytes, filename_prefix.length);
  append_data(input_file + data_offset, (uint32_t)total_variable_len);
}

bool removal_entry_matches(const struct removal_entry* re, const uint8_t* full_name, uint32_t len) {
  if (len < re->head_len + re->tail_len) {
    return false;
  }
  if (memcmp(full_name, re->head, re->head_len) != 0) {
    return false;
  }
  if (re->tail) {
    for (uint32_t i = re->head_len + re->tail_len;; ++i) {
      if (len == i || full_name[i] == '/') {
        if (memcmp(full_name + i - re->tail_len, re->tail, re->tail_len) == 0) {
          return true;
        }
      }
      if (len == i || full_name[i - re->tail_len] == '/') {
        return false;
      }
    }
  } else {
    return len == re->head_len || full_name[re->head_len] == '/';
  }
}
}  // namespace

bool should_include_filename_now(const uint8_t* name, uint32_t len) {
  uint8_t* full_name = (uint8_t*)malloc(filename_prefix.length + len + 1);
  memcpy(full_name, filename_prefix.bytes, filename_prefix.length);
  memcpy(full_name + filename_prefix.length, name, len);
  len += filename_prefix.length;

  for (int i = 0; i < removals.count; ++i) {
    if (removal_entry_matches(&removals.entries[i], full_name, len)) {
      free(full_name);
      return false;
    }
  }

  uint32_t hash = 5381;
  for (uint32_t i = 0; i < len; ++i)
    hash = hash * 33 ^ full_name[i];

  for (uint32_t idx = hash;; ++idx) {
    hash_entry_t* e = filename_hash_table + (idx & (filename_hash_table_size - 1));
    if (e->hash == hash && e->len == len && memcmp(e->data, full_name, len) == 0) {
      free(full_name);
      return false;
    } else if (e->data == NULL) {
      e->hash = hash;
      e->len = len;
      e->data = full_name;
      return true;
    }
  }
}

// Try to find the end-of-central-directory record in a zip file.
const uint8_t* find_eocd(const uint8_t* input_file, size_t input_file_len) {
  for (size_t i = eocd_size; i < 1024 + eocd_size && i <= input_file_len; ++i) {
    const uint8_t* candidate = input_file + input_file_len - i;
    if (memcmp(candidate, eocd_signature.data(), eocd_signature.size()) == 0) {
      return candidate;
    }
  }
  return NULL;
}

namespace {
// Copy all appropriate files from an input zip to the output zip.
void process_input_file(const uint8_t* input_file, size_t input_file_len) {
  const uint8_t* eocd = find_eocd(input_file, input_file_len);
  if (!eocd) {
    printf("Error: Could not find end-of-central-directory in %s.\n", current_input_file_name);
    exit(1);
  }
  if (read2(eocd + 4) != 0 || read2(eocd + 6) != 0) {
    printf("Error: %s is split over multiple disks, which is not supported.\n",
           current_input_file_name);
    exit(1);
  }
  if (!(uint16_t)~read2(eocd + 8) || !(uint16_t)~read2(eocd + 10) || !~read4(eocd + 12) ||
      !~read4(eocd + 16)) {
    printf("Error: %s is zip64, which is not supported.\n", current_input_file_name);
    exit(1);
  }
  uint16_t num_entries = read2(eocd + 10);
  size_t cd_offset = read4(eocd + 16);

  for (uint16_t i = 0; i < num_entries; ++i) {
    uint8_t cd[cd_size];
    if (cd_offset >= input_file_len || (size_t)(input_file_len - cd_offset) < sizeof(cd)) {
      printf("Error: %s is invalid; central-directory %u/%u would start at offset %llu, but file "
             "is only %llu bytes.\n",
             current_input_file_name, (unsigned)i, (unsigned)num_entries,
             (unsigned long long)cd_offset, (unsigned long long)input_file_len);
      exit(1);
    }

    memcpy(cd, input_file + cd_offset, sizeof(cd));
    if (memcmp(cd, cd_signature.data(), cd_signature.size()) != 0) {
      printf("Error: Expected central-directory signature at offset %llu of %s, but instead got "
             "%02x %02x %02x %02x.\n",
             (unsigned long long)cd_offset, current_input_file_name, cd[0], cd[1], cd[2], cd[3]);
      exit(1);
    }
    cd[8] &= 0xF7;  // Clear the bit indicating that a local-file-footer follows the file data
    cd_offset += sizeof(cd);

    uint16_t name_len = read2(cd + 28);
    if (((uint32_t)name_len + (uint32_t)filename_prefix.length) > 0xFFFFU) {
      printf("Error: Combining prefix of %.*s with filename of %.*s results in a filename which is "
             "too long.\n",
             (int)filename_prefix.length, (const char*)filename_prefix.bytes, (int)name_len,
             (const char*)(input_file + cd_offset));
      exit(1);
    }
    write2(cd + 28, name_len + filename_prefix.length);
    uint16_t extra_len = read2(cd + 30);
    uint16_t comment_len = read2(cd + 32);
    uint32_t offset = read4(cd + 42);
    write4(cd + 42, output_zip.num_bytes_written);
    if (!~offset || !~read4(cd + 20)) {
      printf("Error: %s is zip64 (because of %.*s), which is not supported.\n",
             current_input_file_name, (int)name_len, (const char*)(input_file + cd_offset));
      exit(1);
    }

    size_t total_variable_len = (size_t)name_len + (size_t)extra_len + (size_t)comment_len;
    if ((size_t)(input_file_len - cd_offset) < total_variable_len) {
      printf("Error: %s is invalid; starting at offset %llu, reading a filename of %u bytes, extra "
             "data of %u bytes, and comment of %u bytes exceed file size of %llu bytes.\n",
             current_input_file_name, (unsigned long long)offset, (unsigned)name_len,
             (unsigned)extra_len, (unsigned)comment_len, (unsigned long long)input_file_len);
      exit(1);
    }

    bool should_include = should_include_filename_now(input_file + cd_offset, name_len);
    if (verbose) {
      printf("%s %.*s from %s\n", should_include ? "Using" : "Skipping", (int)name_len,
             (const char*)(input_file + cd_offset), current_input_file_name);
    }
    if (should_include) {
      append_cd(cd, sizeof(cd));
      append_cd(filename_prefix.bytes, filename_prefix.length);
      append_cd(input_file + cd_offset, (uint32_t)total_variable_len);
      copy_file_data(input_file, offset, cd, input_file_len);
      if (output_zip.num_files_written == 0xFFFFU) {
        printf("Error: Too many files in output zip.\n");
        exit(1);
      }
      ++output_zip.num_files_written;
    }
    cd_offset += total_variable_len;
  }
}

// Read a file into memory and pass it to process_input_file.
void read_and_process_input_file(const char* filename) {
#ifdef _WIN32
  HANDLE file = CreateFileA(filename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING,
                            FILE_ATTRIBUTE_NORMAL, NULL);
  if (file == INVALID_HANDLE_VALUE) {
    printf("Error: Cannot open %s for reading.\n", filename);
    exit(1);
  }
  LARGE_INTEGER size;
  if (!GetFileSizeEx(file, &size)) {
    printf("Error: Cannot determine size of %s.\n", filename);
    exit(1);
  }
  if (size.HighPart != 0) {
    printf("Error: Input file %s exceeds 4 gigabytes.\n", filename);
    exit(1);
  }
  if (size.LowPart == 0) {
    printf("Error: Input file %s is empty.\n", filename);
    exit(1);
  }
  HANDLE mapping = CreateFileMappingA(file, NULL, PAGE_READONLY, 0, size.LowPart, NULL);
  if (mapping == NULL) {
    printf("Error: Cannot mmap %s (CreateFileMapping).\n", filename);
    exit(1);
  }
  void* data = MapViewOfFile(mapping, FILE_MAP_READ, 0, 0, size.LowPart);
  if (data == NULL) {
    printf("Error: Cannot mmap %s (MapViewOfFile).\n", filename);
    exit(1);
  }
  process_input_file((uint8_t*)data, size.LowPart);
  UnmapViewOfFile(data);
  CloseHandle(mapping);
  CloseHandle(file);
#else
  int file = open(filename, O_RDONLY);
  if (file == -1) {
    printf("Error: Cannot open %s for reading.\n", filename);
    exit(1);
  }
  struct stat st;
  if (fstat(file, &st) == -1) {
    printf("Error: Cannot stat %s.\n", filename);
    exit(1);
  }
  void* data = mmap(NULL, st.st_size, PROT_READ, MAP_SHARED, file, 0);
  if (data == MAP_FAILED) {
    printf("Error: Cannot mmap %s.\n", filename);
    exit(1);
  }
  process_input_file((uint8_t*)data, st.st_size);
  munmap(data, st.st_size);
  close(file);
#endif
}

// Print usage information and exit.
void usage_and_exit(const char** argv) {
  printf("Usage: %s [-v|--verbose] [--remove=FILE] outfile.zip [--prefix=PREFIX] infile1.zip "
         "[--prefix=PREFIX] infile2.zip ...\n",
         argv[0]);
  exit(1);
}

// Set filename_prefix based on a string from the command line.
void set_filename_prefix(const char* prefix) {
  free(filename_prefix.bytes);
  filename_prefix.bytes = NULL;
  filename_prefix.length = 0;

  if (prefix == NULL) {
    return;
  }
  if (*prefix == '/' || *prefix == '\\') {
    ++prefix;
  }
  size_t len = strlen(prefix);
  if (len == 0) {
    return;
  }

  filename_prefix.bytes = (uint8_t*)malloc(len + 1);
  memcpy(filename_prefix.bytes, prefix, len);
  for (size_t i = 0; i < len; ++i) {
    if (filename_prefix.bytes[i] == '\\') filename_prefix.bytes[i] = '/';
  }
  filename_prefix.bytes[len] = '/';
  filename_prefix.length = (uint16_t)(len + 1);
}

// Set various global variables based on the command line.
void parse_command_line(int argc, const char** argv) {
  int i = 1;
  for (; i < argc; ++i) {
    const char* arg = argv[i];
    if (strcmp(arg, "-v") == 0 || strcmp(arg, "--verbose") == 0) {
      verbose = true;
    } else if (strncmp(arg, "--remove=", 9) == 0) {
      arg += 9;
      if (*arg == '/' || *arg == '\\') ++arg;
      if (removals.count == maximum_removals) {
        printf("Error: Too many --remove flags.\n");
        exit(1);
      }
      const char* star = strchr(arg, '*');
      struct removal_entry* re = &removals.entries[removals.count++];
      if (star == NULL) {
        re->head_len = (uint32_t)strlen(arg);
        re->tail_len = 0;
        re->head = (const uint8_t*)arg;
        re->tail = NULL;
      } else {
        if (strchr(star + 1, '*')) {
          printf("Error: At most one * is permitted per removal (%s).\n", arg);
          exit(1);
        }
        re->head_len = (uint32_t)(star - arg);
        re->tail_len = (uint32_t)strlen(star + 1);
        re->head = (const uint8_t*)arg;
        re->tail = (const uint8_t*)(star + 1);
      }
      ++removals.count;
    } else {
      break;
    }
  }

  if (i == argc) {
    printf("Error: Missing output file name.\n");
    usage_and_exit(argv);
  }
  output_file_name = argv[i];
  ++i;

  const char* prefix = NULL;
  for (; i < argc; ++i) {
    const char* arg = argv[i];
    if (strncmp(arg, "--prefix=", 9) == 0) {
      prefix = arg + 9;
    } else {
      if (input_files.count == maximum_input_files) {
        printf("Error: Too many input files.\n");
        exit(1);
      }
      input_files.entries[input_files.count].prefix = prefix;
      input_files.entries[input_files.count].name = arg;
      ++input_files.count;
    }
  }

  if (input_files.count <= 0) {
    printf("Error: Missing input file names.\n");
    usage_and_exit(argv);
  }
}
}  // namespace

int zipmerge_main(int argc, const char** argv) {
  parse_command_line(argc, argv);

  output_zip.file = fopen(output_file_name, "wb");
  if (!output_zip.file) {
    printf("Error: Cannot open %s for writing.\n", output_file_name);
    return 1;
  }

  for (int i = input_files.count - 1; i >= 0; --i) {
    set_filename_prefix(input_files.entries[i].prefix);
    current_input_file_name = input_files.entries[i].name;
    read_and_process_input_file(current_input_file_name);
  }

  uint8_t eocd[eocd_size] = {0};
  memcpy(eocd, eocd_signature.data(), eocd_signature.size());
  write2(eocd + 8, output_zip.num_files_written);
  write2(eocd + 10, output_zip.num_files_written);
  write4(eocd + 12, output_cd.length);
  write4(eocd + 16, output_zip.num_bytes_written);
  append_data(output_cd.bytes, output_cd.length);
  append_data(eocd, sizeof(eocd));
  fclose(output_zip.file);
  return 0;
}

void reset() {
  memset(&output_zip, 0, sizeof(output_zip));
  memset(&filename_prefix, 0, sizeof(filename_prefix));
  memset(&output_cd, 0, sizeof(output_cd));
  memset(&input_files, 0, sizeof(input_files));
  memset(&filename_hash_table, 0, sizeof(filename_hash_table));
  memset(&removals, 0, sizeof(removals));
}
