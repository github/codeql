class C {
  #privDecl;
  bar() {
    {#privDecl} = this; // $ Alert
  }
}