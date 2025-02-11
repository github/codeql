class C {
  #privDecl;
  bar() {
    {#privDecl} = this; // $ TODO-SPURIOUS: Alert
  }
}