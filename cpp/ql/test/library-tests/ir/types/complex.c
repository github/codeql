void Complex(void) {
  _Complex float cf;  //$irtype=cfloat8
  _Complex double cd;  //$irtype=cfloat16
  _Complex long double cld;  //$irtype=cfloat32
  // _Complex __float128 cf128;
}

void Imaginary(void) {
  _Imaginary float jf;  //$irtype=ifloat4
  _Imaginary double jd;  //$irtype=ifloat8
  _Imaginary long double jld;  //$irtype=ifloat16
  // _Imaginary __float128 jf128;
}

// semmle-extractor-options: --microsoft -std=c99
