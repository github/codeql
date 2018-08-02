// This is a small C++ addition to the compatible_c test.
// Note: files `a1.cpp` and `a2.cpp` are completely identical.

struct Empty { };

struct NonEmpty {
  int x;
};

struct Bar {
    struct Empty *empty;
    struct NonEmpty *nonempty;
    int i;
};
