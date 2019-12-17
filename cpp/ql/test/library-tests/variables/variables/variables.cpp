extern int i;
extern int i;
extern int i;

const int c = 7;
const double pi = 3.1415926535897932385;

unsigned a;

unsigned int b;

const char* kings[] = { "Antigonus", "Seleucus", "Ptolemy" };

int* p, q;
static int v1[10], *pv;

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


void f() {
	char local[] = { 'a', 'b' };
	{
		static int local;
	}
}

struct address {
  char* name;
  long int number;
  char* street;
  char* town;
  static char* country;
};

void hasExtern() {
  extern int externInFunction;
}
