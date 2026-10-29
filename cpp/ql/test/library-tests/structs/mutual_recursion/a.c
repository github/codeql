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
struct CompatibleC {
  struct CompatibleA *a;
  int x;
};

// The initial handling of recursion didn't catch this case - if you start from
// D, you'll never revisit it, but you will revisit A/B/C.
struct CompatibleD {
  struct CompatibleA *a;
};

// Ideally, we'd detect that the definitions of Incompatible{A,B} are incompatible, but since their
// fields are pointers, we can't deeply inspect them (it would be possible to have pointers to
// incomplete types that we *can't* deeply inspect).
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
  short x;
};

struct IncompatibleD {
  struct IncompatibleA *a;
};

// We should be able to detect that the definitions of NonRecursiveA and NonRecursiveB are
// incompatible - unlike the above cases, there's no mutual recursion and no pointer type, so we can
// deeply inspect NonRecursiveA when it's used from NonRecursiveB.
struct NonRecursiveA {
  int val;
};

struct NonRecursiveB {
  struct NonRecursiveA a;
};
