// semmle-extractor-options: -std=c++23

#define BAR

#ifdef FOO
#warning C++23 1
#elifdef BAR
#warning C++23 2
#endif

#ifdef FOO
#warning C++23 3
#elifndef FOO
#warning C++23 3
#endif
