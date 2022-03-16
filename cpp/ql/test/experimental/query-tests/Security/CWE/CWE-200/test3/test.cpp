typedef int FILE;
FILE *fopen(const char *filename, const char *mode);
int umask(int pmode);
int chmod(char * filename,int pmode);
int fprintf(FILE *fp,const char *fmt, ...);
char *fgets(char *str, int num, FILE *stream);
int fclose(FILE *stream);

int main(int argc, char *argv[])
{
  FILE *fp;
  char buf[128];
  fp = fopen("myFile.txt","r+"); // BAD [NOT DETECTED]
  fgets(buf,128,fp); 
  fprintf(fp,"%s\n","data to file");
  fclose(fp);
  return 0;
}
