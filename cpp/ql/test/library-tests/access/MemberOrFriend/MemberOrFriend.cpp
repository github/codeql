int topLevelFriend();

class HasFriendFunction {
public:
  static int friendFunction();
};

class C {
  friend class Friend;
  friend int f() { return 1; }
  friend int topLevelFriend();
  friend int HasFriendFunction::friendFunction();

  C();
  C(const C& c) {}
  static int return2() { return 2; }

  class Nested {
    Nested();
    int nested1() {
      struct Local {
        int localOfNested() { return return2(); }
      } l;
      return l.localOfNested();
    }
    struct Nested2 {
      void nested2();
    };
  };
};

class Friend {
  int f() {
    auto lambdaFriend = [](int a, int b) { return a + b + C::return2(); };
    return lambdaFriend(1, 2);
  }
};

class NotFriend {
  int f() {
    auto lambdaNotFriend = [](int a, int b) { return a + b; };
    return lambdaNotFriend(1, 2);
  }
};

int topLevelFriend() {
  struct LocalOfFriend {
    int localOfFriend() { return C::return2(); }
  } l;
  return l.localOfFriend();
}

class DerivesFromC : public C {
  int f();
};

C::C() {
  (void)return2();
}
