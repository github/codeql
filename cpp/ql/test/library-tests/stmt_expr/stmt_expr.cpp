#define maxint(a,b) \
  ({int _a = (a), _b = (b); _a > _b ? _a : _b; })

int maxint3(int a, int b, int c) {
  return maxint(maxint(a, b), c);
}
  
struct D { D(D const&); };

D g1(D d) {
  return ({ d; });
}

D g2(D d) {
  return d;
}
