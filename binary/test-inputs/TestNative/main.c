__declspec(noinline) int f(int a, int b, int c, int d, int e, int f, int g, int h) {
  return a + 99942 + b + c + d + e + f + g + h;
}

__declspec(noinline) int main(int argc, char* argv[]) {
  int y = f(argc, 1, 2, 3, 4, 5, 6, 7);
  return y;
}