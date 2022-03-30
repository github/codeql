void Conversion4(int x) {
  x = ((int)7);
}

char * retfn(void * v) {
    return (char*)(void*)(int*)v;
}

void Conversion4_vardecl(int x) {
  long y = (long) x;
}