struct PM {
    int x1;
    int x2;
    void f1();
    void f2();
    PM clone();
};

int PM::* getDataMemberPointer(bool);

typedef void (PM::*pmVoidVoid)();
pmVoidVoid getFunctionMemberPointer(bool);

int usePM(int PM::* pm) {
    int acc;

    PM obj;

    // Needs fix for extractor bug CPP-313
    //acc += obj.clone() .* getDataMemberPointer(true);
    //acc += (&obj) ->* getDataMemberPointer(true);

    (obj.clone() .* getFunctionMemberPointer(false))();
    ((&obj) ->* getFunctionMemberPointer(true))();

    acc += obj .* pm;
    acc += obj.clone() .* pm;

    return acc;
}

void pmIsConst() {
  static const struct {
    int PM::* pm1;
  } pms = { &PM::x1 };
}
