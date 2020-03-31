int source();
void sink(int);

void throughLocal() {
    int local = source();
    sink(local); // flow
}

int flowTestGlobal1 = 0;

void readWriteGlobal1() {
    sink(flowTestGlobal1); // flow
    flowTestGlobal1 = source();
}

static int flowTestGlobal2 = 0;

void readGlobal2() {
    sink(flowTestGlobal2); // flow
}

void writeGlobal2() {
    flowTestGlobal2 = source();
}
