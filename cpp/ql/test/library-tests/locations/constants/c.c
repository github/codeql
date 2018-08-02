
enum MyCEnum {
  MyCVal = 5,
  MyNextVal = 6
};

struct MyCStruct {
  int es[2];
};

static const struct MyCStruct s = {{ MyCVal, MyNextVal }};

