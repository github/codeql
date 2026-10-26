// semmle-extractor-options: --edg --target --edg linux_arm64 --clang_version 190000

typedef __clang_svuint8x2_t svuint8x2_t;
typedef __SVCount_t svcount_t;

svuint8x2_t svsel_u8_x2(svcount_t, svuint8x2_t, svuint8x2_t);

svuint8x2_t arm_sel(svcount_t a, svuint8x2_t b, svuint8x2_t *c) {
  svuint8x2_t d = svsel_u8_x2(a, b, *c);
  return d;
}
