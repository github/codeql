// semmle-extractor-options: --microsoft
// header_export.cpp
#define DLLEXPORT __declspec(dllexport)
#include "header.h"

DLLEXPORT void myFunction1(int a, int b, int c)
{
}

void myFunction2(int a, int b, int c)
{
}

DLLEXPORT void myFunction4(int a, int b, int c)
{
}

void myFunction5(int a, int b, int c)
{
}
