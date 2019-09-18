namespace std {
  struct exception {
    virtual ~exception();
  };
}

struct exn1 : std::exception { };

struct exn2 : std::exception { };

void bypass_catch() {
  try {
    throw exn1();
  } catch (const exn2 &e) {
    return;
  }
}

void throw_from_nonstmt(int select) {
  if (select) {
    int x = (throw 1, 2);
  } else {
    ({ throw 3; });
  }
}
