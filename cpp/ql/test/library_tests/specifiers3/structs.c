struct pair {
  int a;
  int b;
};

typedef struct pair pair;

struct rect {
  pair* tl;
  pair* br;
};

struct pair2 {
  int a;
  int b;
};

typedef struct pair2 pair2;

struct square {
  struct pair2* tl;
  pair2* br;
};