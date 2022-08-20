typedef int FILE;
FILE *fopen(const char *filename, const char *mode);
int umask(int pmode);
int chmod(char * filename,int pmode);
int fclose(FILE *stream);

void funcTest1()
{
  umask(0666); // BAD
  FILE *fe;
  fe = fopen("myFile.txt", "wt");
  fclose(fe);
  chmod("myFile.txt",0666);
}
void funcTest1g()
{
  umask(0022);
  FILE *fe;
  fe = fopen("myFile.txt", "wt");
  fclose(fe);
  chmod("myFile.txt",0666); // GOOD
}

void funcTest2(int mode)
{
  umask(mode);
  FILE *fe;
  fe = fopen("myFile.txt", "wt");
  fclose(fe);
  chmod("myFile.txt",0555-mode); // BAD
}

void funcTest2g(int mode)
{
  umask(mode);
  FILE *fe;
  fe = fopen("myFile.txt", "wt");
  fclose(fe);
  chmod("myFile.txt",0555&~mode); // GOOD
}

int main(int argc, char *argv[])
{
  funcTest1();
  funcTest2(27);
  funcTest1g();
  funcTest2g(27);
  return 0;
}
