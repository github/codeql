

enum Cheese { cheddar, brie, camembert, gouda };

// This struct is POD in C++03, but not in C++11.
struct Foo
{
  int a = 0;
  int b = 0;
  Cheese cheese = cheddar;
};
