
struct mySmallStruct {
	char data[4];
};

struct myLargeStruct {
	char data[4096];
};

template <class T>
class myTemplateClass
{
public:
	myTemplateClass() {}

	void set(T _t) { // BAD: T can be myLargeStruct, which is large
		t = _t;
	}

	T t;
};

template<class T>
void myTemplateFunction(myTemplateClass<T> mtc_t) // BAD: T can be myLargeStruct, which is large
{
}

void myFunction1(mySmallStruct a, myLargeStruct b) // BAD: b is large
{
	myTemplateClass<mySmallStruct> mtc_a;
	myTemplateClass<myLargeStruct> mtc_b;

	mtc_a.set(a);
	mtc_b.set(b);

	myTemplateFunction(mtc_a);
	myTemplateFunction(mtc_b);
}

void myFunction2(mySmallStruct *a, myLargeStruct *b) // GOOD
{
}

void myFunction3(mySmallStruct &a, myLargeStruct &b) // GOOD
{
}

struct CustomAssignmentOp {
  // GOOD: it's an accepted pattern to implement copy assignment via copy and
  // swap. This delegates the resource management involved in copying to the
  // copy constructor so that logic only has to be written once.
  CustomAssignmentOp &operator=(CustomAssignmentOp rhs);
  char data[4096];
};
