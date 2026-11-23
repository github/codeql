typedef long long frame_size_t;
#define MAX_FRAME_SIZE 18446744073709551615ULL

int invalid_frame_size(frame_size_t size) {
  return size < 1024 || size >= (frame_size_t)MAX_FRAME_SIZE; // $ Alert[cpp/constant-comparison]
}

int valid_frame_size(frame_size_t size) {
  return size >= 1024 && (frame_size_t)MAX_FRAME_SIZE > size; // $ Alert[cpp/constant-comparison]
}

int value_preserving_conversion(frame_size_t size) {
  return size >= 1024 && size >= 1U; // $ Alert[cpp/constant-comparison]
}
