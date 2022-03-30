#define NULL (0)
typedef int FILE;
FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);
extern FILE * fe;
extern int printf(const char *fmt, ...);
void exit(int status);

void myFclose(FILE * fmy)
{
  int i;
  if(fmy) {
    i = fclose(fmy);
    fmy = NULL;
    printf("close end is code %d",i);
    if(i!=0) exit(1);
  }
}

int main(int argc, char *argv[])
{
  fe = fopen("myFile.txt", "wt");
  fclose(fe); // BAD
  fe = fopen("myFile.txt", "wt");
  myFclose(fe); // GOOD
  return 0;
}
