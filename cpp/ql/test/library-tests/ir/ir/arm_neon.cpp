// semmle-extractor-options: --edg --target --edg linux_arm64 --gnu_version 150000

typedef __Uint8x8_t uint8x8_t;
typedef __Uint16x8_t uint16x8_t;

uint8x8_t vadd_u8(uint8x8_t a, uint8x8_t b) {
  return a + b;
}

uint16x8_t vaddl_u8(uint8x8_t a, uint8x8_t b);

uint16x8_t arm_add(uint8x8_t a, uint8x8_t *b) {
  uint8x8_t c = vadd_u8(a, *b);
  return vaddl_u8(a, c);
}

typedef __attribute__((neon_vector_type(8))) __mfp8 mfloat8x8_t;
typedef __attribute__((neon_vector_type(8))) char int8x8_t;

mfloat8x8_t vreinterpret_mf8_s8(int8x8_t);

mfloat8x8_t arm_reinterpret(int8x8_t *a) {
  return vreinterpret_mf8_s8(*a);
}
