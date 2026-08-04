
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
                    int i; // $ Alert[cpp/declaration-hides-variable] // BAD (hides local)
                    int j; // $ Alert[cpp/declaration-hides-variable] // BAD (hides local)
                    int k; // $ Alert[cpp/declaration-hides-variable] // BAD (hides local)
                    int l;
                    int m;
                    int n;

                    int gi; // $ Alert[cpp/local-variable-hides-global-variable] // BAD (hides global)
                    int gj; // $ Alert[cpp/local-variable-hides-global-variable] // BAD (hides global)
                    int gk; // $ Alert[cpp/local-variable-hides-global-variable] // BAD (hides global)
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
void function3(int g3) {}; // $ Alert[cpp/local-variable-hides-global-variable] // BAD

void function4(int g4); // GOOD (the hiding name isn't associated with a code block)
void function4(int g5) {}; // $ Alert[cpp/local-variable-hides-global-variable] // BAD
