struct someStruct {
    int i;
    int j;
};

struct someOtherStruct {
    int a;
    int b;
};

union someUnion {
    int n;
    double d;
};

void f(int x, int y) {
    struct someStruct sInit1 = {
        .i = x + x,
        .j = y - y,
    };

    struct someStruct sInit2 = { x + x, y - y };

    struct someStruct ss[] = {{x + x, y - y}, {x * x, y / y}};

    struct someStruct sInit3 = { x };

    struct someStruct sInit4 = { .j = y };

    int aInit1[2] = { x, y };

    int aInit2[2] = { x };

    int aInit3[2] = { [1] = y };

    union someUnion uInit1 = { x };
    union someUnion uInit2 = { .n = x };
    union someUnion uInit3 = { .d = 5.0 };
}

struct complexStruct {
    struct someStruct sss[3];
    int as[3];
    struct someOtherStruct soss[3];
    int z;
};

void g(int x, int y) {
  // Nested aggregate designated initializers
  struct complexStruct complexInit1 = {
    .as = {
      [2] = x,
      [0] = y,
      x+y // as[1]
    },
    .z = 42,
    .soss = {
      [1] = {
        .a = x+y,
        .b = x-y
      },
      [0] = {
        .b = x*y,
        .a = x/y
      }
      // soss[2] is value initializaed
    }
    // sss is value initialized
  };

  // Nested aggregate non-designated initializers
  struct complexStruct complexInit2 = {
    { // sss
      { // sss[0]
        x, // sss[0].i
        y  // sss[0].j
      },
      { // sss[1]
        x+1, // sss[1].i
        // sss[1].j is value initialized
      }
      // ss[2] is value initialized
    },
    { // as
      99, // as[0]
      x*y // as[1]
      // as[2] is value initialized
    },
    { // soss
      { // soss[0]
        123, // soss[0].a
        y+1  // soss[0].b
      },
      { // soss[1]
        x, // soss[1].a
        // soss[1].b is value initialized
      }
      // soss[2] is value initialized
    }
    // z is value initialized
  };
}
