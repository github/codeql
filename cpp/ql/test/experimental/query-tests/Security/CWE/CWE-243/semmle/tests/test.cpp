typedef int FILE;
#define size_t int
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
FILE *fopen(const char *filename, const char *mode);
int fread(char *buf, int size, int count, FILE *fp);
int fclose(FILE *fp);
int chroot(char *path);
int chdir(char *path);
void exit(int status);

int funTest1(){
  if (chroot("/myFold/myTmp") == -1) {  // BAD
    exit(-1);
  }
  return 0;
}

int funTest2(){  
  if (chdir("/myFold/myTmp") == -1) { // GOOD
    exit(-1);
  }
  if (chroot("/myFold/myTmp") == -1) {  // GOOD
    exit(-1);
  }
  return 0;
}

int funTest3(){  
  chdir("/myFold/myTmp"); // BAD
  return 0;
}
int main(int argc, char *argv[])
{
  if(argc = 0) {
    funTest3();
    return 2;
  }
  if(argc = 1)
    funTest1();
  else
    funTest2();
  FILE *fp = fopen(argv[1], "w");
  fwrite("12345", 5, 1, fp);
  fclose(fp);
  return 0;
}
