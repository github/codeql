
void builtin_double(double real, double imag) {
  _Complex double a = __builtin_complex(real, imag);
  _Complex double b = __builtin_complex(2.71828, 3.14159);
}

void builtin_float(float realf, float imagf) {
  _Complex float c = __builtin_complex(realf, imagf);
  _Complex float d = __builtin_complex(1.23f, 4.56f);
}
