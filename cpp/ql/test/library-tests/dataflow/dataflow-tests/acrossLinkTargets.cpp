int source();
void sink(int);

// For the purpose of this test, this function acts like it's defined in a
// different link target such that we get two different functions named
// `calleeAcrossLinkTargets` and no link from the caller to this one. The test
// is getting that effect because the library can't distinguish the two
// overloaded functions that differ only on `int` vs. `long`, so we might lose
// this result and be forced to write a better test if the function signature
// detection should improve.
void calleeAcrossLinkTargets(long x) {
  sink(x); // $ ast,ir
}

void calleeAcrossLinkTargets(int x); // no body


void callerAcrossLinkTargets() {
  calleeAcrossLinkTargets(source());
}

///////////////////////////////////////////////////////////////////////////////


// No flow into this function as its signature is not unique (in the limited
// model of the library).
void ambiguousCallee(long x) {
  sink(x);
}

// No flow into this function as its signature is not unique (in the limited
// model of the library).
void ambiguousCallee(short x) {
  sink(x);
}

void ambiguousCallee(int x); // no body


void ambiguousCaller() {
  ambiguousCallee(source());
}
