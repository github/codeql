
enum MyEnum {
  MyVal = 5,
  MyNextVal = 6
};

struct MyStruct {
  MyEnum es[2];
};

static const MyStruct s = {{ MyVal, MyNextVal }};

