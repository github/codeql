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

void branch_on_integral_in_c(int x1, int x2) {
  if (x1) {}
  if(!x1) {}

  int y = !x1;
  if(y) {}
  if(!y) {}

  if(x1 && x2) {}
  if(!x1 && x2) {}
  if(x1 && !x2) {}
  if(!x1 && !x2) {}
  if(x1 || x2) {}
  if(!x1 || x2) {}
  if(x1 || !x2) {}
  if(!x1 || !x2) {}

  int x_1_and_2 = x1 && x2;
  if(x_1_and_2) {}
  if(!x_1_and_2) {}
}

// semmle-extractor-options: --microsoft
