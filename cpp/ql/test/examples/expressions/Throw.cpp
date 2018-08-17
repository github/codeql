class E { };
class F {
  public:
  F() { } 
};
void Throw(int i) {
  try {
    if(i)
      throw E();
    else
      throw F();
  } catch(E *e) {
    throw;
  }
 
}