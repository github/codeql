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

// semmle-extractor-options: --microsoft
