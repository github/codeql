struct Node {
  struct Node *next;
};

struct CompatibleB;
struct CompatibleC;

struct CompatibleA {
  struct CompatibleB *b;
};

struct CompatibleB {
  struct CompatibleC *c;
};

// The 2 definitions of CompatibleC use different but compatible types for x
typedef int AnInt;
struct CompatibleC {
  struct CompatibleA *a;
  AnInt x;
};

struct CompatibleD {
  struct CompatibleA *a;
};

struct IncompatibleB;
struct IncompatibleC;

struct IncompatibleA {
  struct IncompatibleB *b;
};

struct IncompatibleB {
  struct IncompatibleC *c;
};

// The 2 definitions of IncompatibleC use different and incompatible types for x
struct IncompatibleC {
  struct IncompatibleA *a;
  int x;
};

struct IncompatibleD {
  struct IncompatibleA *a;
};

// We should be able to detect that the definitions of NonRecursiveA and NonRecursiveB are
// incompatible - unlike the above cases, there's no mutual recursion and no pointer type, so we can
// deeply inspect NonRecursiveA when it's used from NonRecursiveB.
struct NonRecursiveA {
  short val;
};

struct NonRecursiveB {
  struct NonRecursiveA a;
};
