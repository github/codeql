void complex_literals(void) {
  _Complex float cf = 2.0;
  cf = __I__;
  _Complex double cd = 3.0;
  cd = __I__;
  _Complex long double cld = 5.0;
  cld = __I__;

  _Imaginary float jf = __I__;
  _Imaginary double jd = __I__;
  _Imaginary long double jld = __I__;
}

void complex_arithmetic(void) {
  float f1 = 5.0;
  float f2 = 7.0;
  float f3;
  _Complex float cf1 = 2.0;
  _Complex float cf2 = __I__;
  _Complex float cf3;
  _Imaginary float jf1 = __I__;
  _Imaginary float jf2 = __I__;
  _Imaginary float jf3;

  // unaryop _Complex
  cf3 = +cf1;
  cf3 = -cf1;

  // _Complex binaryop _Complex
  cf3 = cf1 + cf2;
  cf3 = cf1 - cf2;
  cf3 = cf1 * cf2;
  cf3 = cf1 / cf2;

  // unaryop _Imaginary
  jf3 = +jf1;
  jf3 = -jf1;

  // _Imaginary binaryop _Imaginary
  jf3 = jf1 + jf2;
  jf3 = jf1 - jf2;
  f3 = jf1 * jf2;  // Result is _Real
  f3 = jf1 / jf2;  // Result is _Real

  // _Imaginary binaryop _Real
  cf3 = jf1 + f2;
  cf3 = jf1 - f2;
  jf3 = jf1 * f2;  // Result is _Imaginary
  jf3 = jf1 / f2;  // Result is _Imaginary

  // _Real binaryop _Imaginary
  cf3 = f1 + jf2;
  cf3 = f1 - jf2;
  jf3 = f1 * jf2;  // Result is _Imaginary
  jf3 = f1 / jf2;  // Result is _Imaginary
}

void complex_conversions(void) {
  float f = 2.0;
  double d = 3.0;
  long double ld = 5.0;
  _Complex float cf = 7.0;
  _Complex double cd = 11.0;
  _Complex long double cld = 13.0;
  _Imaginary float jf = __I__;
  _Imaginary double jd = __I__;
  _Imaginary long double jld = __I__;

  // _Complex to _Complex
  cf = cf;
  cf = cd;
  cf = cld;
  cd = cf;
  cd = cd;
  cd = cld;
  cld = cf;
  cld = cd;
  cld = cld;

  // _Real to _Complex
  cf = f;
  cf = d;
  cf = ld;
  cd = f;
  cd = d;
  cd = ld;
  cld = f;
  cld = d;
  cld = ld;

  // _Complex to _Real
  f = cf;
  f = cd;
  f = cld;
  d = cf;
  d = cd;
  d = cld;
  ld = cf;
  ld = cd;
  ld = cld;

  // _Imaginary to _Complex
  cf = jf;
  cf = jd;
  cf = jld;
  cd = jf;
  cd = jd;
  cd = jld;
  cld = jf;
  cld = jd;
  cld = jld;

  // _Complex to _Imaginary
  jf = cf;
  jf = cd;
  jf = cld;
  jd = cf;
  jd = cd;
  jd = cld;
  jld = cf;
  jld = cd;
  jld = cld;

  // _Real to _Imaginary
  jf = f;
  jf = d;
  jf = ld;
  jd = f;
  jd = d;
  jd = ld;
  jld = f;
  jld = d;
  jld = ld;

  // _Imaginary to _Real
  f = jf;
  f = jd;
  f = jld;
  d = jf;
  d = jd;
  d = jld;
  ld = jf;
  ld = jd;
  ld = jld;
}

// semmle-extractor-options: --microsoft --edg --c99
