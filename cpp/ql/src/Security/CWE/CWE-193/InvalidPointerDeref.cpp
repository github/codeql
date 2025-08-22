void *malloc(unsigned);
unsigned get_size();
void write_data(const unsigned char*, const unsigned char*);

int main(int argc, char* argv[]) {
  unsigned size = get_size();
  
  {
    unsigned char *begin = (unsigned char*)malloc(size);
    if(!begin) return -1;

    unsigned char* end = begin + size;
    write_data(begin, end);
    *end = '\0'; // BAD: Out-of-bounds write
  }

  {
    unsigned char *begin = (unsigned char*)malloc(size);
    if(!begin) return -1;

    unsigned char* end = begin + size;
    write_data(begin, end);
    *(end - 1) = '\0'; // GOOD: writing to the last byte
  }

}