template <typename X>
struct MyTemplate {
  MyTemplate() {}

  typedef MyTemplate<X> mytype;
};
