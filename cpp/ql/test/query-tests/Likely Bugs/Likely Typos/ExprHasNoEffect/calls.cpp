namespace Calls {

int external();

class Base {
public:
  virtual int thingy() {
    1; // BAD
  }

  int our_thingy() {
    Base::thingy(); // BAD
    return 2;
  }
};

class Derived : public Base {
public:
  virtual int thingy() {
    external(); // GOOD
    return 3;
  }
};

void internal() {
  Base* ptr = new Derived();
  ptr->thingy(); // GOOD
}

}