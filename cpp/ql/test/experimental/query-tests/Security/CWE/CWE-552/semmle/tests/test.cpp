#define NULL 0

typedef struct {} FILE;
typedef	unsigned int	uint_t; 
typedef	uint_t	mode_t;	
typedef unsigned long size_t;

FILE *fdopen(int handle, char *mode);
FILE *fopen(const char *pathname, const char *mode);
int fclose(FILE *stream);
int open(const char *pathname, int flags);
int open(const char *pathname, int flags, mode_t mode);
int close(int file);
FILE *fdopen(int handle, char *mode);
int rename(const char *from, const char *to);
bool remove(const char *path);
int fread(char *buf, int size, int count, FILE *fp);
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);

void test1(const char *from,const char *to)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  f1 = fopen(from, "r");
  count = fread(data, 1, 1000, f1);
  fclose(f1);
  rename(from,to); // GOOD
  f2 = fopen(to, "w");
  fclose(f2);
}
void test2(const char *from,const char *to)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  
  if (!rename(from,to)) { // BAD
    f1 = fopen(from, "r");
    count = fread(data, 1, 1000, f1);
    fclose(f1);
    f2 = fopen(to, "w");
    fwrite(data, count, 1, f2);
    fclose(f2);
  }
}
void test3(const char *from,const char *to)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  
  if (rename(from,to)==-1) { // BAD : some time left to recreate the file
    f1 = fopen(from, "r");
    count = fread(data, 1, 1000, f1);
    fclose(f1);
    remove(to);
    f2 = fopen(to, "w");
    fwrite(data, count, 1, f2);
    fclose(f2);
  }
}
void test4(const char *from,const char *to)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  int fd;

  if (rename(from,to)<0) { // GOOD
    f1 = fopen(from, "r");
    count = fread(data, 1, 1000, f1);
    fclose(f1);
    fd = open(to, 00000301, 0600);
    f2 = fdopen(fd, "w");
    fwrite(data, count, 1, f2);
    fclose(f2);
  }
}

void test5(const char *from,const char *to)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  
  if (rename(from,to)==0) // BAD
    return;
  f1 = fopen(from, "r");
  count = fread(data, 1, 1000, f1);
  fclose(f1);
  remove(to);
  f2 = fopen(to, "w");
  fwrite(data, count, 1, f2);
  fclose(f2);
}

void test6(const char *from,const char *to)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  
  if (rename(from,to)==0) { // GOOD
    f1 = fopen(from, "r");
    count = fread(data, 1, 1000, f1);
    fclose(f1);
    remove(to);
    f2 = fopen(to, "w");
    fwrite(data, count, 1, f2);
    fclose(f2);
  }
  return;
}
void test7(const char *from,const char *to)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  int ret;
  ret = rename(from,to); // BAD
  if (ret==0)
    return;
  f1 = fopen(from, "r");
  count = fread(data, 1, 1000, f1);
  fclose(f1);
  remove(to);
  f2 = fopen(to, "w");
  fwrite(data, count, 1, f2);
  fclose(f2);
}
void test8(const char *from,const char *to,int flag)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  int ret;
  ret = rename(from,to); // BAD
  if (flag==5&&ret==0)
    return;
  f1 = fopen(from, "r");
  count = fread(data, 1, 1000, f1);
  fclose(f1);
  remove(to);
  f2 = fopen(to, "w");
  fwrite(data, count, 1, f2);
  fclose(f2);
}
void test9(const char *from,const char *to)
{
  FILE *f1 = NULL;
  FILE *f2 = NULL;
  char data[1000];
  int count;
  int fd;

  if (rename(from,to)) { // BAD
    f1 = fopen(from, "r");
    count = fread(data, 1, 1000, f1);
    fclose(f1);
    remove(to);
    f2 = fopen(to, "w");
    fwrite(data, count, 1, f2);
    fclose(f2);
  }
}
