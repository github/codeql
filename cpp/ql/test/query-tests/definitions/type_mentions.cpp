class MyClass1 {};
typedef MyClass1 MyType1;
#define MYTYPE MyType1


int test1() {
	MyClass1 a;
	MyType1 b;
	MYTYPE c;
	return 0;
}

template<int n>
class MyClass2{
	char array[n];
};

static MyClass2<sizeof(MyClass1)> MyVal2;

namespace my_namespace {
  struct MyStruct1{
  };
}

my_namespace
  ::
  MyStruct1;


template<typename T1, typename T2>
class BinaryTemplate {
	T1 first;
	T2 second;
};
BinaryTemplate<MyClass1, my_namespace::MyStruct1> myBinaryTemplate;

class MyClass3 {
public:
	typedef my_namespace::MyStruct1 MyTypedefStruct1;
};


static MyClass3::MyTypedefStruct1 myStruct1Value;

void (myFuncPtr)(MyClass3);

enum MyEnum {
	myEnumVal
};

union MyUnion {
	MyClass1 myVal1;
	MyClass3 myVal3;
};

void test2() {
	MyUnion un;
	un.myVal1 = un.myVal1;

	MyEnum en = myEnumVal;

	MyType1 *t = new MyType1;
	MyType1 *t100 = new MyType1[100];

	en = (MyEnum)0;
}

template<class T>
void myTemplateFunction()
{
};

template<>
void myTemplateFunction<MyType1>()
{
};

MyType1 *ptr;
