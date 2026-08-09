typedef int BOOL;

typedef int myAmbiguousType;

typedef signed int mySignedType;

enum myEnum {
	myEnumVal
};

struct {
	int nosign : 2; // $ Alert // BAD
	signed int sign1 : 2; // GOOD
	unsigned int sign2 : 2; // GOOD
	signed sign3: 2; // GOOD
	unsigned sign4 : 2; // GOOD
	BOOL typedefbool: 2; // GOOD
	bool cppbool : 2; // GOOD
	char nosignchar : 2; // $ Alert // BAD
	short nosignshort : 2; // $ Alert // BAD
	myAmbiguousType nosigntypedef : 2; // $ Alert // BAD
    mySignedType signedtypedef : 2; // GOOD
    const int nosignconst : 2; // $ Alert // BAD
    const signed int signedconst : 2;
    myEnum nosignenum : 2;
    const myEnum constnosignenum : 2;
};

template<typename T>
struct TemplateWithBitfield {
  T templatesign : 2; // GOOD
};

TemplateWithBitfield<signed int> twb;
