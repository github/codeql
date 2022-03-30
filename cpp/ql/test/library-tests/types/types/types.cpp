extern int i;

const int c = 7;
const double pi = 3.1415926535897932385;

unsigned a;

unsigned int b;

typedef char* Pchar;

const char* kings[] = { "Antigonus", "Seleucus", "Ptolemy" };

int* p, q;
int v1[10], *pv;

int (*fp)(char *); // pointer to function

float v2[3];
char* v3[32];

int d2[10][20];

char v4[3] = { 'a', 'b', 0 };

int v5[8] = { 1, 2, 3, 4 };

char* p2 = "Plato";
char p3[] = "Zeno";

char alpha[] = "abcdefghijklmnopqrstuvwxyz"
	           "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

int av[] = { 1, 2 , 3, 4 };
int* ap1 = av;
int* ap2 = &av[0];
int* ap3 = &av[4];

int f(int* pi)
{
	void* pv = pi;
	return 0;
}

void f1(char* p)
{
  char s[] = "Gorm";
  const char* pc = s;
  pc = p;

  char *const cp = s;
  cp[3] = 'a';

  const char *const cpc = s;
  char const* pc2 = s;
}

void f2()
{
  int i = 1;
  int& r = i;
  int x = r;
  r = 2;
  const double& cdr = 1;
}

void increment(int& aa) { aa++; }

__int128 i128;
signed __int128 i128s;
unsigned __int128 i128u;

Pchar pchar;

typedef unsigned long size_t;
typedef long ssize_t;
typedef long ptrdiff_t;

size_t st;
ssize_t sst;
ptrdiff_t pdt;
wchar_t wct;
