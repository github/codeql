#include "queues.h"
int source();
void sink(int);

struct InputIterator {
  int value;
  const int &operator*() const { return value; }
};

// Reduced range overload body. The single-element models must not replace it.
namespace BloombergLP { namespace bdlcc {
template<class TYPE>
template<class ITER>
void Deque<TYPE>::forcePushBack(ITER begin, ITER end) {
  pushBack(*begin);
}
} }

void rangeOverloadKeepsItsBody() {
  BloombergLP::bdlcc::Deque<int> q;
  InputIterator begin = {source()}, end = {0};
  q.forcePushBack(begin, end);
  sink(q.popFront()); // $ ir
}
