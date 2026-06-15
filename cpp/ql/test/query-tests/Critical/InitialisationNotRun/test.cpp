// --- stubs ---

char *strcpy(char *dest, const char *src);

// --- tests ---

class GlobalStorage {
public:
    char name[1000];
};

GlobalStorage *g1; // BAD
static GlobalStorage g2; // GOOD
static GlobalStorage *g3; // BAD
// static variables are initialized by compilers
static int a;  // GOOD
static int b = 0;  // GOOD

void init() { //initializes g_storage, but is never run from main
  g1 = new GlobalStorage();
  g3 = new GlobalStorage();
}

void init2(int b) {
  for (int i = 0; i < b; ++i)
    a *= -1;
}

int main(int argc, char *argv[]) {
	//init not called
  strcpy(g1->name, argv[1]); // g1 is used before init() is called
  strcpy(g2.name, argv[1]); // g2 is initialised by compiler
  strcpy(g3->name, argv[1]);
  b++;
  return 0;
}
