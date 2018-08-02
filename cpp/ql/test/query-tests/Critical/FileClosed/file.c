
typedef void FILE;
FILE *fopen(const char *path, const char *mode);
int fclose(FILE *fp);
#define NULL ((FILE *)0)

void f1(int i) {
    FILE *f = fopen("somefile.txt", "r");

    if (!f) return;

    if (!i) return; // Not closed here

    fclose(f);
}

FILE *f2(int i) {
    FILE *f = fopen("somefile.txt", "r");

    if (!f) return NULL;

    if (!i) return NULL; // Not closed here

    return f;
}

void g2(int i) {
    FILE *f = f2(i);

    fclose(f); // This makes the final return in f2 count as closed
}

void f3(int i) {
    FILE *f = fopen("somefile.txt", "r"); // Never closed

    if (!f) return;

    if (!i) return;
}

void f4(void) {
    FILE *f = fopen("somefile.txt", "r"); // Always closed

    if (!f) return;

    fclose(f);
}

FILE *f5(void) {
    FILE *f = fopen("somefile.txt", "r"); // Always closed, by g5

    if (!f) return NULL;

    return f;
}

void g5(void) {
    FILE *f = f5();

    fclose(f);
}

int f6(int b) {
    FILE *f;

    f = fopen("somefile.txt", "r"); // Not always closed

    if (f) {
        if (b) {
            fclose(f);
        }
    }

    return 0;
}

int f7(void) {
    FILE *f;

    f = fopen("somefile.txt", "r"); // Always closed

    if (f) {
        fclose(f);
    }

    return 0;
}

int f8(void) {
    FILE *f;

    if (f = fopen("somefile.txt", "r")) { // Always closed
        fclose(f);
    }

    return 0;
}

