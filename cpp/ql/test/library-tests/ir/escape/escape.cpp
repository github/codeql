void CallByPointer(int* p);
void CallByReference(int& r);

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
}
