struct Base {
  virtual void a();
  virtual void b();
};

struct Derived : Base {
  void a() override;
  void b();
};
