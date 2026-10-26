
int vv1;
const int vv2 = 1;
int *vv3;
const int * const vv4 = &vv2;
int &vv5 = vv1;
const int & const vv6 = vv2;
int vv7[3];
const int vv8[3] = {};
int (*vv9)(int, int);
const int (*const vv10)(const int, const int) = 0;

const char ww2 = 'a';
const char * const ww4 = &ww2;
const char &ww6 = ww2;
const char ww8[3] = {};
const char (*const ww10)(const char, const char) = 0;

typedef int myInt;
void f(int i) {
    myInt fi[i];
}

typedef volatile int volatileInt;
volatileInt vol_int = 0;
typedef const volatileInt cvInt;
cvInt cv_int = 0;
