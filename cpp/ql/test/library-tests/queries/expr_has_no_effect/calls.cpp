namespace Calls {

int external();

class Base {
public:
  virtual int thingy() {
    1;
  }

  int our_thingy() {
    Base::thingy();
    return 2;
  }
};

class Derived : public Base {
public:
  virtual int thingy() {
    external();
    return 3;
  }
};

void internal() {
  Base* ptr = new Derived();
  ptr->thingy();
}

}