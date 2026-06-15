struct Shape {
  virtual ~Shape();

  virtual void draw() = 0;
};

struct Circle : public Shape {
  Circle();

  void draw() override {
    /* ... */
  }

  int getRadius();
};

struct Square : public Shape {
  Square();

  void draw() override {
    /* ... */
  }

  int getLength();
};
