class E { };
class F {
  public:
  F() { } 
};
void f(int i) {
  try {
    if(i)
      throw E();
    else
      throw F();
  } catch(E *e) {
    throw;
  }
 
}