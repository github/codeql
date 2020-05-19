#include "shared.h"

using SinkFunction = void (*)(int);

void notSink(int notSinkParam);

void callsSink(int sinkParam) {
  sink(sinkParam);
}

struct {
  SinkFunction sinkPtr, notSinkPtr;
} globalStruct;

union {
  SinkFunction sinkPtr, notSinkPtr;
} globalUnion;

SinkFunction globalSinkPtr;

void assignGlobals() {
  globalStruct.sinkPtr = callsSink;
  globalUnion.sinkPtr = callsSink;
  globalSinkPtr = callsSink;
};

void testStruct() {
  globalStruct.sinkPtr(atoi(getenv("TAINTED"))); // should reach sinkParam [NOT DETECTED]
  globalStruct.notSinkPtr(atoi(getenv("TAINTED"))); // shouldn't reach sinkParam

  globalUnion.sinkPtr(atoi(getenv("TAINTED"))); // should reach sinkParam
  globalUnion.notSinkPtr(atoi(getenv("TAINTED"))); // should reach sinkParam

  globalSinkPtr(atoi(getenv("TAINTED"))); // should reach sinkParam
}
