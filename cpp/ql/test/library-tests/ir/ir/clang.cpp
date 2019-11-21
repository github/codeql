// codeql-extractor-compiler: clang

int globalInt;

int *globalIntAddress() {
  return __builtin_addressof(globalInt);
}
