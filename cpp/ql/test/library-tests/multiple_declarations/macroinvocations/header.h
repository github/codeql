#define MY_MACRO()

MY_MACRO()

#ifdef UNRELATED_MACRO
#undef UNRELATED_MACRO
#endif
