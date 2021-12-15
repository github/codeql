
int gi;
extern int gj;
static int gk;

void f(void) {
    int i;

    if (1) {
        int j;
        if (1)
            if(1) {
                int k;
                if(1) {
                    int i; // BAD (hides local)
                    int j; // BAD (hides local)
                    int k; // BAD (hides local)
                    int l;
                    int m;
                    int n;

                    int gi; // BAD (hides global)
                    int gj; // BAD (hides global)
                    int gk; // BAD (hides global)
                }
                int l; // GOOD (scopes do not overlap)
            }
            int m; // GOOD (scopes do not overlap)
    }
    int n; // GOOD (scopes do not overlap)
}

int g1, g2, g3, g4, g5;

void function1(int g1); // GOOD (the hiding name isn't associated with a code block)
extern void function2(int g2); // GOOD (the hiding name isn't associated with a code block)
void function3(int g3) {}; // BAD

void function4(int g4); // GOOD (the hiding name isn't associated with a code block)
void function4(int g5) {}; // BAD
