struct X {
  static int i;
};

void v(int i, X &xref) {
//  i = X::i;
  i = xref.i;
  
}