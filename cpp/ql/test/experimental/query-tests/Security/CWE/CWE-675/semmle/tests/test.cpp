#define NULL (0)
typedef int FILE;
FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);
extern FILE * fe;
void test1()
{
  FILE *f;
  
  f = fopen("myFile.txt", "wt");
  fclose(f); // GOOD
  f = NULL;
}

void test2()
{
  FILE *f;
	
  f = fopen("myFile.txt", "wt");
  fclose(f); // BAD
  fclose(f);
}

void test3()
{
  FILE *f;
  FILE *g;
	
  f = fopen("myFile.txt", "wt");
  g = f;
  fclose(f); // BAD
  fclose(g);
}

int fGtest4_1()
{
  fe = fopen("myFile.txt", "wt"); 
  fclose(fe); // BAD
  return -1;
}

int fGtest4_2()
{
  fclose(fe);
  return -1;
}

void Gtest4()
{   
  fGtest4_1();
  fGtest4_2();
}

int fGtest5_1()
{
  fe = fopen("myFile.txt", "wt");
  fclose(fe); // GOOD
  fe = NULL;
  return -1;
}

int fGtest5_2()
{
  fclose(fe);
  return -1;
}

void Gtest5()
{
  fGtest5_1();
  fGtest5_2();
}

int main(int argc, char *argv[])
{
  test1();
  test2();
  test3();
  
  Gtest4();
  Gtest5();
  return 0;
}
