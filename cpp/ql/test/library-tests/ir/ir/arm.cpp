// semmle-extractor-options: --edg --target --edg linux_arm64

typedef __Uint8x8_t uint8x8_t;
typedef __Uint16x8_t uint16x8_t;

uint8x8_t vadd_u8(uint8x8_t a, uint8x8_t b) {
  return a + b;
}

// Workaround: the frontend only exposes this when the arm_neon.h
// header is encountered.
uint16x8_t __builtin_aarch64_uaddlv8qi_uuu(uint8x8_t, uint8x8_t);

uint16x8_t vaddl_u8(uint8x8_t a, uint8x8_t b) {
  return __builtin_aarch64_uaddlv8qi_uuu (a, b);
}

uint16x8_t arm_add(uint8x8_t a, uint8x8_t b) {
  uint8x8_t c = vadd_u8(a, b);
  return vaddl_u8(a, c);
}
