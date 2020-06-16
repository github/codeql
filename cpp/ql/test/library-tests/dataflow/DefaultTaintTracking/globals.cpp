#include "shared.h"


void throughLocal() {
    char * local = getenv("VAR");
    sink(local); // flow
}

char * global1 = 0;

void readWriteGlobal1() {
    sink(global1); // flow
    global1 = getenv("VAR");
}

static char * global2 = 0;

void readGlobal2() {
    sink(global2); // flow
}

void writeGlobal2() {
    global2 = getenv("VAR");
}
