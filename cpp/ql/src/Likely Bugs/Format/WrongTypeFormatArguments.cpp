int main() {
  printf("%s\n", 42); //printf will treat 42 as a char*, will most likely segfault
  return 0;
}
