bool compare_xyz(unsigned short x, unsigned short y, unsigned short z) {
  return (x + y < x + z);  // x can be canceled
}
