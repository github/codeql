typedef int FILE;
#define NULL (0)
FILE *fopen(char *filename, const char *mode);
FILE *fdopen(int handle, char *mode);
char * tmpnam(char * name);
int mkstemp(char * name);
char * strcat(char *str1, const char *str2);
int umask(int pmode);
int chmod(char * filename,int pmode);
int fprintf(FILE *fp,const char *fmt, ...);
int fclose(FILE *stream);

int funcTest1()
{
  FILE *fp;
  char *filename = tmpnam(NULL); // BAD
  fp = fopen(filename,"w");
  fprintf(fp,"%s\n","data to file");
  fclose(fp);
  return 0;
}

int funcTest2()
{
  FILE *fp;
  int fd;
  char filename[80];
  strcat (filename, "/tmp/name.XXXXXX");
  fd = mkstemp(filename);
  if ( fd < 0 ) {
    return 1;
  }
  fp = fdopen(fd,"w"); // GOOD
  return 0;
}

int funcTest3()
{
  FILE *fp;
  char filename[80];
  strcat(filename, "/tmp/tmp.name");
  fp = fopen(filename,"w"); // BAD [NOT DETECTED]
  fprintf(fp,"%s\n","data to file");
  fclose(fp);
  return 0;
}

int funcTest4()
{
  FILE *fp;
  char filename[80];
  umask(0022);
  strcat(filename, "/tmp/tmp.name");
  fp = fopen(filename,"w"); // GOOD
  chmod(filename,0666);
  fprintf(fp,"%s\n","data to file");
  fclose(fp);
  return 0;
}

int main(int argc, char *argv[])
{
  funcTest1();
  funcTest2();
  funcTest3();
  funcTest4();
  return 0;
}
