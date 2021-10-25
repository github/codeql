typedef int FILE;
FILE *fopen(const char *filename, const char *mode);
int umask(int pmode);
int chmod(char * filename,int pmode);
int fprintf(FILE *fp,const char *fmt, ...);
int fclose(FILE *stream);

int main(int argc, char *argv[])
{
  //umask(0022);
  FILE *fp;
  fp = fopen("myFile.txt","w"); // BAD
  //chmod("myFile.txt",0644);
  fprintf(fp,"%s\n","data to file");
  fclose(fp);
  return 0;
}
