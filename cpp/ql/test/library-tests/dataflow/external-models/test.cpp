
int ymlSource();
void ymlSink(int value);
int ymlStepManual(int value);
int ymlStepGenerated(int value);
int ymlStepManual_with_body(int value1, int value2) { return value2; }
int ymlStepGenerated_with_body(int value, int value2) { return value2; }

void test() {
	int x = ymlSource();

	ymlSink(0);

	ymlSink(x); // $ ir

	// ymlStepManual is manually modeled so we should always use the model
	int y = ymlStepManual(x);
	ymlSink(y); // $ ir

	// ymlStepGenerated is modeled by the model generator so we should use the model only if there is no body
	int z = ymlStepGenerated(x);
	ymlSink(z); // $ ir

	// ymlStepManual_with_body is manually modeled so we should always use the model
	int y2 = ymlStepManual_with_body(x, 0);
	ymlSink(y2); // $ ir

	int y3 = ymlStepManual_with_body(0, x);
	ymlSink(y3); // clean

	// ymlStepGenerated_with_body is modeled by the model generator so we should use the model only if there is no body
	int z2 = ymlStepGenerated_with_body(0, x);
	ymlSink(z2); // $ ir

	int z3 = ymlStepGenerated_with_body(x, 0);
	ymlSink(z3); // clean
}

struct S {
	int x;
};

using pthread_t = unsigned long;
using pthread_attr_t = void*;

void *myThreadFunction(void *arg) {
    S* s = (S *)arg;
    ymlSink(s->x); // $ ir
    return nullptr;
}

int pthread_create(pthread_t *thread, const pthread_attr_t * attr, void *(*start_routine)(void*), void *arg);

int test_pthread_create() {
	S s;
	s.x = ymlSource();

	pthread_t threadId;
	pthread_create(&threadId, nullptr, myThreadFunction, (void *)&s);
}

template<typename F>
void callWithArgument(F f, int x);

struct StructWithOperatorCall_has_constructor {
	StructWithOperatorCall_has_constructor();

	void operator()(int y) {
		ymlSink(y); // $ ir
	}
};

struct StructWithOperatorCall_no_constructor {
	void operator()(int y) {
		ymlSink(y); // $ ir
	}
};

struct StructWithOperatorCall_has_constructor_2 {
	StructWithOperatorCall_has_constructor_2();

	void operator()(int y) {
		ymlSink(y); // $ ir
	}
};

struct StructWithOperatorCall_no_constructor_2 {
	void operator()(int y) {
		ymlSink(y); // $ ir
	}
};

void test_callWithArgument() {
	int x = ymlSource();
	{
		StructWithOperatorCall_has_constructor func;
		callWithArgument(func, x);
	}
	{
		StructWithOperatorCall_no_constructor func;
		callWithArgument(func, x);
	}
	callWithArgument(StructWithOperatorCall_has_constructor_2(), x);
	callWithArgument(StructWithOperatorCall_no_constructor_2(), x);
}

template<int N, typename T>
T callWithNonTypeTemplate(const T&);

template<typename T, int N>
T callWithNonTypeTemplate(const T&);

void test_callWithNonTypeTemplate() {
	int x = ymlSource();
	int y1 = callWithNonTypeTemplate<10, int>(x);
	ymlSink(y1); // $ MISSING: ir

	int y2 = callWithNonTypeTemplate<int, 10>(x);
	ymlSink(y2); // $ ir
}

template<class T>
struct TemplateClass1 {
  template<class U>
  U templateFunction(T, U);

	template<class U, class V>
  V templateFunction2(U, V);
};

void test_template_function_in_template_class() {
	TemplateClass1<int> b;
	int x = ymlSource();
	auto y = b.templateFunction<unsigned long>(x, 0UL);
	ymlSink(y); // $ ir
}

template<class S, class T>
struct TemplateClass2 {
	T function(T, S);
};

template<class V> using PartialInstantiationOfTemplateClass2 = TemplateClass2<int, V>;

void test_partial_class_instantiation() {
	int x = ymlSource();
	PartialInstantiationOfTemplateClass2<unsigned long> y;
	int z = y.function(0UL, x);
	ymlSink(z); // $ ir
}

template<class V> struct DeriveFromFromPartialTemplateInstantiation : TemplateClass2<int, V> { };

void test_inheritance() {
	int x = ymlSource();
	DeriveFromFromPartialTemplateInstantiation<long> y;
	auto z = y.function(0L, x);
	ymlSink(z); // $ ir
}

template<class T>
struct Class1 : TemplateClass1<T> {
  template<class U>
  int templateFunction3(U u, int x) {
    return TemplateClass1<T>::template templateFunction2<U, int>(u, x);
  }
};

void test_class1() {
	int x = ymlSource();
	Class1<int> c;
	auto y = c.templateFunction3<unsigned long>(0UL, x);
	ymlSink(y); // $ ir
}

struct ReverseFlow {
	int value;
	int& get_ptr();
};

struct MyString {
	char& operator[](unsigned);
};

void test_reverse_flow(unsigned i, unsigned j) {
	{
		ReverseFlow rf;
		rf.get_ptr() = ymlSource();
		int x = rf.value;
		ymlSink(x); // $ MISSING: ir
	}
	{
		MyString s;
		s[i] = ymlSource();
		char c = s[j];
		ymlSink(c); // $ MISSING: ir
	}
}