// semmle-extractor-options: --microsoft
// ms_var_attributes.cpp
#define DLLEXPORT __declspec(dllexport)
#include "ms_var_attributes.h"

DLLEXPORT int myInt1 = 100;
int myInt2 = 100;
DLLEXPORT int myInt4 = 100;
int myInt5 = 100;

class AddressOfGetter {
  __declspec(property(get = getter)) int field;
  int& getter() throw();
  void f() throw()
  {
    &field;
  }
};

__declspec("SAL_volatile") char* pBuf;
