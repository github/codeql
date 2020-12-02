
#define NULL ((void *)0)
typedef void *id;
int i;
unsigned long long ull;

class ClassNoDef;

class ClassWithDef {
    int x; int y;
};

struct StructNoDef;
struct StructWithDef {
    int x; int y;
};

typedef struct StructWithDef TypeDefStructWithDef;

union UnionNoDef;
union UnionWithDef {
    int x; int y;
};

void *voidStar;
char *charStar;

char * const charStarConst = (char * const)NULL;
const char * constCharStar;
const char * const constCharStarConst = "test";

int &ref = i;

int arr[3];
int arrr[3][4];

typedef int v4si __attribute__ ((vector_size (16)));

int fun(int x) {};
int (*funptr)(int x);
int (&funref)(int x) = fun;

int &&rvalref = i+1;

typedef char *SEL;

auto blockPtr = ^ int (int x, int y) {return x + y;};


