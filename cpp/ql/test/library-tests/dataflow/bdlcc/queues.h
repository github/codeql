// Public single-element overloads from bloomberg/bde groups/bdl/bdlcc.
namespace BloombergLP { namespace bslma { class Allocator; } namespace bdlcc {
template<class TYPE> class Deque {
public:
  void pushBack(const TYPE& value);
  void pushBack(TYPE&& value);
  void pushFront(const TYPE& value);
  void pushFront(TYPE&& value);
  void forcePushBack(const TYPE& value);
  void forcePushBack(TYPE&& value);
  void forcePushFront(const TYPE& value);
  void forcePushFront(TYPE&& value);
  int tryPushBack(const TYPE& value);
  int tryPushBack(TYPE&& value);
  void popBack(TYPE *value);
  void popFront(TYPE *value);
  int tryPopBack(TYPE *value);
  int tryPopFront(TYPE *value);
  TYPE popBack();
  TYPE popFront();
  template<class ITER> void forcePushBack(ITER begin, ITER end);
  void tryPopFront(unsigned long count);
};
template<class TYPE> class BoundedQueue {
public:
  BoundedQueue(unsigned long capacity, bslma::Allocator *allocator = 0);
  int pushBack(const TYPE& value);
  int pushBack(TYPE&& value);
  int tryPushBack(const TYPE& value);
  int tryPushBack(TYPE&& value);
  int popFront(TYPE *value);
  int tryPopFront(TYPE *value);
};
} }
