struct foo {
  void a() {
  }
};

int main() {
  foo f;
  foo* pf = &f;
  void (foo::* pa)() = &foo::a;

  // NB: The C++ standard states that "if the result of .* or ->* is a function, then that
  // result can be used only as the operand for the function call operator ()", but g++ 4.4
  // and later accept the following anyway.
  void(*f_pa)(foo&) = (void(*)(foo&))(f.*pa);
  void(*pf_pa)(foo&) = (void(*)(foo&))(pf->*pa);

  f_pa(f);
  pf_pa(f);
}
