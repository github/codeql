int source();
void sink(int);

void throughLocal() {
    int local = source();
    sink(local); // $ ast,ir
}

int flowTestGlobal1 = 0;

void readWriteGlobal1() {
    sink(flowTestGlobal1); // $ ir MISSING: ast
    flowTestGlobal1 = source();
}

static int flowTestGlobal2 = 0;

void readGlobal2() {
    sink(flowTestGlobal2); // $ ir MISSING: ast
}

void writeGlobal2() {
    flowTestGlobal2 = source();
}
