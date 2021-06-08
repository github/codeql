struct Point {
  int x;
  int y;
};

struct Base1 {
  int b1;
};

struct Base2 {
  int b2;
};

struct DerivedSI : Base1 {
  int dsi;
};

struct DerivedMI : Base1, Base2 {
  int dmi;
};

struct DerivedVI : virtual Base1 {
  int dvi;
};

void Locals() {
  Point pt = {  //$ussa=pt
    1,  //$ussa=pt[0..4)<int>
    2  //$ussa=pt[4..8)<int>
  };
  int i = pt.x;  //$ussa=pt[0..4)<int>
  i = pt.y;  //$ussa=pt[4..8)<int>
  int* p = &pt.x;
  i = *p;  //$ussa=pt[0..4)<int>
  p = &pt.y;
  i = *p;  //$ussa=pt[4..8)<int>
}

void PointsTo(
  int a,         //$raw=a
  Point& b,      //$raw=b ussa=*b
  Point* c,      //$raw=c ussa=*c
  int* d,        //$raw=d ussa=*d
  DerivedSI* e,  //$raw=e ussa=*e
  DerivedMI* f,  //$raw=f ussa=*f
  DerivedVI* g   //$raw=g ussa=*g
) {

  int i = a;  //$raw=a
  i = *&a;  //$raw=a
  i = *(&a + 0);  //$raw=a
  i = b.x;  //$raw=b ussa=*b[0..4)<int>
  i = b.y;  //$raw=b ussa=*b[4..8)<int>
  i = c->x;  //$raw=c ussa=*c[0..4)<int>
  i = c->y;  //$raw=c ussa=*c[4..8)<int>
  i = *d;  //$raw=d ussa=*d[0..4)<int>
  i = *(d + 0);  //$raw=d ussa=*d[0..4)<int>
  i = d[5];  //$raw=d ussa=*d[20..24)<int>
  i = 5[d];  //$raw=d ussa=*d[20..24)<int>
  i = d[a];  //$raw=d raw=a ussa=*d[?..?)<int>
  i = a[d];  //$raw=d raw=a ussa=*d[?..?)<int>

  int* p = &b.x;  //$raw=b
  i = *p;  //$ussa=*b[0..4)<int>
  p = &b.y;  //$raw=b
  i = *p;  //$ussa=*b[4..8)<int>
  p = &c->x;  //$raw=c
  i = *p;  //$ussa=*c[0..4)<int>
  p = &c->y;  //$raw=c
  i = *p;  //$ussa=*c[4..8)<int>
  p = &d[5];  //$raw=d
  i = *p;  //$ussa=*d[20..24)<int>
  p = &d[a];  //$raw=d raw=a
  i = *p;  //$ussa=*d[?..?)<int>

  Point* q = &c[a];  //$raw=c raw=a
  i = q->x;  //$ussa=*c[?..?)<int>
  i = q->y;  //$ussa=*c[?..?)<int>

  i = e->b1;  //$raw=e ussa=*e[0..4)<int>
  i = e->dsi;  //$raw=e ussa=*e[4..8)<int>
  i = f->b1;  //$raw=f ussa=*f[0..4)<int>
  i = f->b2;  //$raw=f ussa=*f[4..8)<int>
  i = f->dmi;  //$raw=f ussa=*f[8..12)<int>
  i = g->b1;  //$raw=g ussa=*g[?..?)<int>
  i = g->dvi;  //$raw=g ussa=*g[8..12)<int>
}