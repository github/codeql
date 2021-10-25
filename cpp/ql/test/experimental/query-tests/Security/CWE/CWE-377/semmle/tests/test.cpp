typedef int FILE;
#define NULL (0)
FILE *fopen(char *filename, const char *mode);
char * tmpnam(char * name);
int fprintf(FILE *fp,const char *fmt, ...);
int fclose(FILE *stream);

int main(int argc, char *argv[])
{
  FILE *fp;
  char *filename = tmpnam(NULL); // BAD
  fp = fopen(filename,"w");
  fprintf(fp,"%s\n","data to file");
  fclose(fp);
  return 0;
}
