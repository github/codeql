typedef struct {
  int x, y;
} MyCoords;

int getX(MyCoords *coords);

void MyCoordsTest(int pos) {
  MyCoords coords = {0};
  coords.x = coords.y = pos + 1;
  coords.x = getX(&coords);
}

void CStyleCast(void *src)
{
    char *dst = (char*)src;
}

void ExRaiseAccessViolation(int);
#define EXCEPTION_EXECUTE_HANDLER 1

int TryExceptTest(int x) {
  int *localPtr;
  
  __try {
    ExRaiseAccessViolation(x);
  } __except(EXCEPTION_EXECUTE_HANDLER) {  
    return 1;
  }
  return 0;
}

void unexplained_loop_regression()
{
  __try
  {
    ExRaiseAccessViolation(0);
  }
  __except (EXCEPTION_EXECUTE_HANDLER)
  {
    ExRaiseAccessViolation(1);
  }
}

void try_with_finally()
{
  int x = 0;
  __try
  {
    x = 1;
  }
  __finally
  {
    x = 2;
  }
}

void throw_in_try_with_finally()
{
  int x = 0;
  __try
  {
    ExRaiseAccessViolation(0);
  }
  __finally
  {
    x = 1;
  }
}

void throw_in_try_with_throw_in_finally()
{
  __try {
    ExRaiseAccessViolation(0);
  }
  __finally {
    ExRaiseAccessViolation(0);
  }
}

void raise_access_violation() {
  ExRaiseAccessViolation(1);
}

// semmle-extractor-options: --microsoft
