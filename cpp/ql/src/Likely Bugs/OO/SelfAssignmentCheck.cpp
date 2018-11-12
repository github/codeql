
class MyClass
{
public:
  MyClass() : data(new Data()) {}
  ~MyClass() {delete data;}

  MyClass &operator=(const MyClass &other)
  {
    delete data;
    data = other.data->clone(); // wrong: if other == *this, other.data has already been deleted!
    return *this;
  }

private:
  Data *data;
};

// If someone assigns a `MyClass` object to itself, the delete expression deletes both `this->data`
// and `other.data`, since `*this` and `other` are the same object. But the call to `clone` uses
// `*other.data`, which is no longer a valid object.  Fix this by adding a check:

class MyClass
{
public:
  MyClass() : data(new Data()) {}
  ~MyClass() {delete data;}

  MyClass &operator=(const MyClass &other)
  {
    if (this == &other) { return *this; } // correct
    delete data;
    data = other.data->clone();
    return *this;
  }

private:
  Data *data;
};
