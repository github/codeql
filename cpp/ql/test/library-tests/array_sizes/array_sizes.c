// semmle-extractor-options: --g++ --gnu_version 40602
// this test is in a .c file with compiler flags set to be like g++.  This is a workaround to
// build as C++ without C++11, a configuration where we've had problems in the past.
enum {
  sizeof_arr5 = 11,
  sizeof_arr6 = 13,
  sizeof_arr7 = 15
};

int arr5[sizeof_arr5] = {0};
char arr6[sizeof_arr6 * 2];

int main(int argc) {
  short arr7[sizeof_arr7];
  long arr8[argc];
}
