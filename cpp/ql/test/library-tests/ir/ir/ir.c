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

// semmle-extractor-options: --microsoft
