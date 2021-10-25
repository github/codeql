struct Point2 {
  int x;
  int y;
};

struct Point3 : Point2 {
  int z;
};

void f() {
  Point2 p2;
  Point3 p3;
  p2 = p3;
}

void g() {
  Point2* p2 = 0;
  Point3* p3 = 0;
  p2 = p3;
}
