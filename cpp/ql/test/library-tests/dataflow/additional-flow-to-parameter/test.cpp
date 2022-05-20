// This test confirms that `DataFlow::Config.isAdditionalFlowStep` can be
// overridden to cause flow from an expression to a parameter.

int source();
void sink(...);

// In this test, a function with this name becomes the target of all calls to
// function pointers.
void targetOfAllFunctionPointerCalls(int i1, int i2, int i3) {
    sink(i1);
    sink(i2);
}

typedef void (*ftype)(int, int, int);

void test1(ftype callback) {
    callback(source(), 0, 0);
    callback(0, source(), 0);
    callback(0, 0, source());
}
