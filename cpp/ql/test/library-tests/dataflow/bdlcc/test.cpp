#include "queues.h"
int source();
void sink(int);
using namespace BloombergLP::bdlcc;

void DequepushBack() {
  Deque<int> q;
  int input = source(), output = 0;
  q.pushBack(input);
  q.popBack(&output);
  sink(output); // $ ir
}
void DequepushFront() {
  Deque<int> q;
  int input = source(), output = 0;
  q.pushFront(input);
  q.popFront(&output);
  sink(output); // $ ir
}
void DequeforcePushBack() {
  Deque<int> q;
  int input = source(), output = 0;
  q.forcePushBack(input);
  q.tryPopBack(&output);
  sink(output); // $ ir
}
void DequeforcePushFront() {
  Deque<int> q;
  int input = source(), output = 0;
  q.forcePushFront(input);
  q.tryPopFront(&output);
  sink(output); // $ ir
}
void DequetryPushBack() {
  Deque<int> q;
  int input = source(), output = 0;
  q.tryPushBack(input);
  q.popBack(&output);
  sink(output); // $ ir
}
void BoundedQueuepushBack() {
  BoundedQueue<int> q(8);
  int input = source(), output = 0;
  q.pushBack(input);
  q.popFront(&output);
  sink(output); // $ ir
}
void BoundedQueuetryPushBack() {
  BoundedQueue<int> q(8);
  int input = source(), output = 0;
  q.tryPushBack(input);
  q.tryPopFront(&output);
  sink(output); // $ ir
}

void returnAndMove() {
  Deque<int> q;
  int input = source();
  q.pushBack(static_cast<int&&>(input));
  int output = 0;
  q.popBack(&output);
  sink(output); // $ ir
  sink(q.popFront()); // $ ir
  sink(q.popBack()); // $ ir
}
void returnAfterCopy() {
  Deque<int> q;
  int input = source();
  q.pushBack(input);
  sink(q.popFront()); // $ ir
}
void pointerPayload() {
  int input = source();
  int *p = &input, *output = 0;
  BoundedQueue<int*> q(8);
  q.pushBack(p);
  q.popFront(&output);
  sink(*output); // $ ir
}
void pointerReturn() {
  int input = source();
  int *p = &input;
  Deque<int*> q;
  q.pushBack(p);
  sink(*q.popFront()); // $ ir
}
struct Payload { int value; };
void objectPayload() {
  Payload input = {source()}, output = {0};
  Deque<Payload> q;
  q.pushFront(input);
  q.popBack(&output);
  sink(output.value); // $ ir
}
void statusesAreNotPayload() {
  BoundedQueue<int> q(8);
  int input = source(), output = 0;
  sink(q.tryPushBack(input));
  sink(q.tryPopFront(&output));
  sink(output); // $ ir
}
void failureCanPreserveOutput() {
  Deque<int> q;
  int output = source();
  if (q.tryPopFront(&output) != 0)
    sink(output); // $ ir
}
