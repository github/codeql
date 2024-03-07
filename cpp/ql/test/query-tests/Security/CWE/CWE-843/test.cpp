struct S1 {
  int a;
  void* b;
  unsigned char c;
};

struct S1_wrapper {
  S1 s1;
};

struct Not_S1_wrapper {
  unsigned char x;
  S1 s1;
};

void test1() {
  void* p = new S1;
  S1_wrapper* s1w = static_cast<S1_wrapper*>(p); // GOOD
}

void test2() {
  void* p = new S1_wrapper;
  S1* s1 = static_cast<S1*>(p); // GOOD
}

void test3() {
  void* p = new S1;
  Not_S1_wrapper* s1w = static_cast<Not_S1_wrapper*>(p); // BAD
}

void test4() {
  void* p = new Not_S1_wrapper;
  S1* s1 = static_cast<S1*>(p); // BAD
}

struct HasBitFields {
  int x : 16;
  int y : 16;
  int z : 32;
};

struct BufferStruct {
  unsigned char buffer[sizeof(HasBitFields)];
};

void test5() {
  HasBitFields* p = new HasBitFields;
  BufferStruct* bs = reinterpret_cast<BufferStruct*>(p); // GOOD
}

struct Animal {
  virtual ~Animal();
};

struct Cat : public Animal {
  Cat();
  ~Cat();
};

struct Dog : public Animal {
  Dog();
  ~Dog();
};

void test6() {
  Animal* a = new Cat;
  Dog* d = static_cast<Dog*>(a); // BAD
}

void test7() {
  Animal* a = new Cat;
  Dog* d = dynamic_cast<Dog*>(a); // GOOD
}

void test8() {
  Animal* a = new Cat;
  Cat* d = static_cast<Cat*>(a); // GOOD
}

void test9(bool b) {
  Animal* a;
  if(b) {
    a = new Cat;
  } else {
    a = new Dog;
  }
  if(b) {
    Cat* d = static_cast<Cat*>(a); // GOOD
  }
}

/**
 * The layout of S2 is:
 *  0: int
 *  8: void*
 *  16: unsigned char
 *  16 + pad: unsigned char
 *  32 + pad: int
 *  40 + pad: void*
 *  48 + pad: unsigned char
*/
struct S2 {
  S1 s1;
  unsigned char buffer[16];
  S1 s1_2;
};

struct S2_prefix {
  int a;
  void* p;
  unsigned char c;
};

void test10() {
  S2* s2 = new S2;
  S2_prefix* s2p = reinterpret_cast<S2_prefix*>(s2); // GOOD
}

struct Not_S2_prefix {
  int a;
  void* p;
  void* p2;
  unsigned char c;
};

void test11() {
  S2* s2 = new S2;
  Not_S2_prefix* s2p = reinterpret_cast<Not_S2_prefix*>(s2); // BAD
}

struct HasSomeBitFields {
  int x : 16;
  int y;
  int z : 32;
};

void test12() {
  // This has doesn't have any non-bitfield member, so we don't detect
  // the problem here since the query currently ignores bitfields.
  S1* s1 = new S1;
  HasBitFields* hbf = reinterpret_cast<HasBitFields*>(s1); // BAD [NOT DETECTED]

  S1* s1_2 = new S1;
  // This one has a non-bitfield members. So we detect the problem
  HasSomeBitFields* hbf2 = reinterpret_cast<HasSomeBitFields*>(s1_2); // BAD
}

void test13(bool b, Cat* c) {
  Animal* a;
  if(b) {
    a = c;
  } else {
    a = new Dog;
  }
  // This FP happens despite the `not GoodFlow::flowTo(sinkNode)` condition in the query
  // because we don't find a flow path from `a = c` to `static_cast<Cat*>(a)` because
  // the "source" (i.e., `a = c`) doesn't have an allocation.
  if(b) {
    Cat* d = static_cast<Cat*>(a); // GOOD [FALSE POSITIVE]
  }
}

void test14(bool b) {
  Animal* a;
  if(b) {
    a = new Cat;
  } else {
    a = new Dog;
  }
  if(!b) {
    Cat* d = static_cast<Cat*>(a); // BAD [NOT DETECTED]
  }
}

struct UInt64 { unsigned long u64; };
struct UInt8 { unsigned char u8; };

void test14() {
  void* u64 = new UInt64;
  // ...
  UInt8* u8 = (UInt8*)u64; // GOOD
}

struct UInt8_with_more { UInt8 u8; void* p; };

void test15() {
  void* u64 = new UInt64;
  // ...
  UInt8_with_more* u8 = (UInt8_with_more*)u64; // BAD
}

struct SingleInt {
  int i;
} __attribute__((packed));;

struct PairInts {
  int x, y;
} __attribute__((packed));;

union MyUnion
{
  PairInts p;
  unsigned long long foo;
} __attribute__((packed));

void test16() {
  void* si = new SingleInt;
  // ...
  MyUnion* mu = (MyUnion*)si; // BAD [NOT DETECTED]
}

struct UnrelatedStructSize {
  unsigned char buffer[1024];
};

void test17() {
  void* p = new S1;
  UnrelatedStructSize* uss = static_cast<UnrelatedStructSize*>(p); // BAD
}

struct TooLargeBufferSize {
  unsigned char buffer[sizeof(S1) + 1];
};

void test18() {
  void* p = new S1;
  TooLargeBufferSize* uss = static_cast<TooLargeBufferSize*>(p); // BAD
}

// semmle-extractor-options: --gcc -std=c++11