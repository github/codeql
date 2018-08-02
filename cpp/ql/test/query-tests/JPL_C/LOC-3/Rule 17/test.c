typedef unsigned char uint8_t;
typedef uint8_t U8;
typedef U8 something_else;
void test1(U8* xptr) { }
void test2(U8 x) { }
void test3(unsigned char x) { }
void test4(uint8_t x){ }
void test5(something_else x){ }
static U8 test6;
static uint8_t test7;
static U8 test8 [];
