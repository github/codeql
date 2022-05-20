// This test ensures that we can efficiently generate IR for a large
// value-initialized array.

struct Big {
  char buffer[1 << 30]; // 1 GiB
  Big() : buffer() {} // This explicit init of `buffer` makes it value-initialized
};

int main() {
  Big *big = new Big;

  return 0;
}
