
class IntVector;

class IntVectorIter {
    public:
    IntVectorIter (IntVector *p_vec, int pos);
    bool operator!= (IntVectorIter& other);
    int operator* ();
    IntVectorIter& operator++ ();
};

class IntVector {
    public:
    IntVectorIter begin ();
    IntVectorIter end ();
};

void cpp_range_based_for(void) {
    IntVector vec;
    int j = 0;

    for (int i : vec)
        j++;
}

class CopyConstructorClass {
    public:
    CopyConstructorClass();
    ~CopyConstructorClass();
    CopyConstructorClass(const CopyConstructorClass &x);
};

CopyConstructorClass cpp_CopyConstructorClass(CopyConstructorClass x) {
    return CopyConstructorClass(x);
}

