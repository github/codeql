void CallByPointer(int* p);
void CallByReference(int& r);
int *GetPointer();
int &GetReference();

int FetchFromPointer(int *no_p) {
  return *no_p;
}

int FetchFromReference(int &no_r) {
  return no_r;
}

int *ReturnPointer(int *no_p) {
  return no_p;
}

int &ReturnReference(int &no_r) {
  return no_r;
}

void CallByPointerParamEscape(int *no_p) {
  CallByPointer(no_p);
}

void CallByReferenceParamEscape(int &no_r) {
  CallByReference(no_r);
}

int *MaybeReturn(int *no_p, int *no_q, bool no_b) {
  if (no_b) {
    return no_p;
  } else {
    return no_q;
  }
}

int &EscapeAndReturn(int &no_r) {
  CallByReference(no_r);
  return no_r;
}

struct Point {
    float x;
    float y;
    float z;
};

struct Base {
    float b;
};

struct ReusedBase {
    float rb;
};

struct Intermediate1 : Base, ReusedBase {
    float i1;
};

struct Intermediate2 : ReusedBase {
    float i2;
};

struct Derived : Intermediate1, Intermediate2 {
    float d;
};

class C;

void CEscapes(C *no_c);

class C {
public:
  void ThisEscapes() {
    CEscapes(this);
  }

  C *ThisReturned() {
    return this;
  }

  virtual C *Overridden() {
    CEscapes(this);
    return nullptr;
  }
};

class OverrideReturns : C {
public:
  virtual C *Overridden() {
    return this;
  }
};

class OverrideNone : C {
public:
  virtual C *Overridden() {
    return nullptr;
  }
};

void Escape()
{
    int no_result;
    int no_;

    no_ = 1;
    no_ = no_;
    no_result = no_;
    no_result = *&no_;
//    no_result = (int&)no_;  Restore when we have correct IR types for glvalues
    no_;
    &no_;
    no_result = *((&no_) + 0);
    no_result = *((&no_) - 0);
    no_result = *(0 + &no_);
    if (&no_) {
    }
    while (&no_) {
    }
    do {
    } while (&no_);
    for(&no_; &no_; &no_) {
    }

    if (&no_ == nullptr) {
    }
    while (&no_ != nullptr) {
    }

    int no_Array[10];
    no_Array;
    (int*)no_Array;
    no_Array[5];
    5[no_Array];
    no_result = no_Array[5];
    no_result = 5[no_Array];

    Point no_Point = { 1, 2, 3 };
    float no_x = no_Point.x;
    no_Point.y = no_x;
    float no_y = (&no_Point)->y;
    (&no_Point)->y = no_y;
    float no_z = *(&no_Point.z);
    *(&no_Point.z) = no_z;

    Derived no_Derived;
    no_Derived.b = 0;
    float no_b = no_Derived.b;
    no_Derived.i2 = 1;
    float no_i2 = no_Derived.i2;

    int no_ssa_addrOf;
    int* no_p = &no_ssa_addrOf;

    int no_ssa_refTo;
    int& no_r = no_ssa_refTo;

    int no_ssa_refToArrayElement[10];
    int& no_rae = no_ssa_refToArrayElement[5];

    int no_ssa_refToArray[10];
    int (&no_ra)[10] = no_ssa_refToArray;

    int passByPtr;
    CallByPointer(&passByPtr);

    int passByRef;
    CallByReference(passByRef);

    int no_ssa_passByPtr;
    FetchFromPointer(&no_ssa_passByPtr);

    int no_ssa_passByRef;
    FetchFromReference(no_ssa_passByRef);

    int no_ssa_passByPtr_ret;
    FetchFromPointer(&no_ssa_passByPtr_ret);

    int no_ssa_passByRef_ret;
    FetchFromReference(no_ssa_passByRef_ret);

    int passByPtr2;
    CallByPointerParamEscape(&passByPtr2);

    int passByRef2;
    CallByReferenceParamEscape(passByRef2);

    int passByPtr3;
    CallByPointerParamEscape(ReturnPointer(&passByPtr3));

    int passByRef3;
    CallByReferenceParamEscape(ReturnReference(passByRef3));

    int no_ssa_passByPtr4;
    int no_ssa_passByPtr5;
    bool no_b2 = false;
    MaybeReturn(&no_ssa_passByPtr4, &no_ssa_passByPtr5, no_b2);

    int passByRef6;
    EscapeAndReturn(passByRef6);

    int no_ssa_passByRef7;
    ReturnReference(no_ssa_passByRef7);

    C no_ssa_c;

    no_ssa_c.ThisReturned();

    C c;

    c.ThisEscapes();

    C c2;

    CEscapes(&c2);

    C c3;

    c3.ThisReturned()->ThisEscapes();

    C c4;

    CEscapes(c4.ThisReturned());

    C c5;

    c5.Overridden();

    OverrideReturns or1;
    or1.Overridden();

    OverrideReturns or2;
    CEscapes(or2.Overridden());

    OverrideNone on1;
    on1.Overridden();

    OverrideNone on2;
    CEscapes(on2.Overridden());

    int condEscape1, condEscape2;

    int *no_condTemp;
    if(GetPointer()) {
	no_condTemp = &condEscape1;
    } else {
        no_condTemp = &condEscape2;
    }
    CallByPointer(no_condTemp);
}

