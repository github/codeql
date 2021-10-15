
struct MyStruct1;

class MyClass1 { // POD
public:
	int a, b, c;
};

class MyClass2 { // non-POD due to user-defined constructor
public:
	MyClass2();

	int a, b, c;
};

class MyClass3 { // non-POD due to user-defined constructor
public:
	MyClass3(int i);

private:
	int a, b, c;
};

class MyClass4a : public MyClass1 { // POD because it does not add extra fields
};

class MyClass4b : public MyClass1 { // non-POD because it adds extra fields
public:
	int x, y, z;
};

class MyClass5 : public MyClass2 { // non-POD due to inherited user-defined constructor
};

class MyClass6 { // POD
public:
	MyClass1 mc1;
};

class MyClass7 { // non-POD due to contained user-defined constructor
public:
	MyClass2 mc2;
};

class MyClass8 { // POD
public:
	MyClass2 *mc2;
};

template<class T> class MyClass9 { // non-POD, because T is not POD
	T t;
};
MyClass9<int> v1; // POD
MyClass9<MyClass2> v2; // non-POD

template<class T> class MyClass10 { // POD (T is not used)
	int i;
};
MyClass10<int> v3; // POD
MyClass10<MyClass2> v4; // POD
