struct X {
  static int i;
};

void StaticMemberAccess(int i, X &xref) {
//  i = X::i;
  i = xref.i;
  
}