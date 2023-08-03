typedef struct {
  int x, y;
} MyCoords;

int getX(MyCoords *coords);

void MyCoordsTest(int pos) {
  MyCoords coords = {0};
  coords.x = coords.y = pos + 1;
  coords.x = getX(&coords);
}
