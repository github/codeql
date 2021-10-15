char *getenv(const char *name);
void sink(const char *sinkparam); // $ ast,ir=global1 ast,ir=global2

void throughLocal() {
    char * local = getenv("VAR");
    sink(local);
}

char * global1 = 0;

void readWriteGlobal1() {
    sink(global1); // $ ast,ir=global1
    global1 = getenv("VAR");
}

static char * global2 = 0;

void readGlobal2() {
    sink(global2); // $ ast,ir=global2
}

void writeGlobal2() {
    global2 = getenv("VAR");
}
