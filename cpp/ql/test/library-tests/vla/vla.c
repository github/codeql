int atoi(const char*);

int main(int argc, char** argv)
{
  char* matrix[argc][atoi(argv[1])];
  return 0;
}

int getInt(void);

void f(void) {
    typedef char myType[10 * 4][3 + getInt()][3][90 * getInt()];
    myType var;
    char c1, c2 = 'x', buf[10 * 4][2 + getInt()][3][80 * getInt()], buf2[getInt()], *ptr = buf;
}
