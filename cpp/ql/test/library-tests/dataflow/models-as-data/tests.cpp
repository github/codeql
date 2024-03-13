
// non-MAD sources / sinks
int source();
void sink(int val);

// --- global MAD sources ---

int localMadSource(); // $ interpretElement
int remoteMadSource(); // $ interpretElement
int notASource();
int localMadSourceVoid(void); // $ interpretElement
int localMadSourceHasBody() { return 0; } // $ interpretElement
int *remoteMadSourceIndirect(); // $ interpretElement
void remoteMadSourceIndirectArg0(int *x, int *y); // $ interpretElement
void remoteMadSourceIndirectArg1(int &x, int &y); // $ interpretElement
int remoteMadSourceVar; // $ interpretElement

namespace MyNamespace {
	int namespaceLocalMadSource(); // $ interpretElement
	int namespaceLocalMadSourceVar; // $ interpretElement

	namespace MyNamespace2 {
		int namespace2LocalMadSource(); // $ interpretElement
	}

	int localMadSource(); // (not a source)
}
int namespaceLocalMadSource(); // (not a source)

void test_sources() {
	sink(0);
	sink(source()); // $ ir

	// test sources

	sink(localMadSource()); // $ ir
	sink(remoteMadSource()); // $ ir
	sink(notASource());
	sink(localMadSourceVoid()); // $ ir
	sink(localMadSourceHasBody()); // $ ir
	sink(*remoteMadSourceIndirect()); // $ MISSING: ir

	int a, b, c, d;

	remoteMadSourceIndirectArg0(&a, &b);
	sink(a); // $ MISSING: ir
	sink(a);
	remoteMadSourceIndirectArg1(c, d);
	sink(c);
	sink(d); // $ MISSING: ir

	sink(remoteMadSourceVar); // $ ir

	int e = localMadSource();
	sink(e); // $ ir

	sink(MyNamespace::namespaceLocalMadSource()); // $: ir
	sink(MyNamespace::namespaceLocalMadSourceVar); // $ ir
	sink(MyNamespace::MyNamespace2::namespace2LocalMadSource()); // $ ir
	sink(MyNamespace::localMadSource()); // $ (the MyNamespace version of this function is not a source)
	sink(namespaceLocalMadSource()); // (the global namespace version of this function is not a source)
}

void remoteMadSourceParam0(int x) // $ interpretElement
{
	sink(x); // $ ir
}

// --- global MAD sinks ---

void madSinkArg0(int x); // $ interpretElement
void notASink(int x);
void madSinkArg1(int x, int y); // $ interpretElement
void madSinkArg01(int x, int y, int z); // $ interpretElement
void madSinkArg02(int x, int y, int z); // $ interpretElement
void madSinkIndirectArg0(int *x); // $ interpretElement
int madSinkVar; // $ interpretElement

void test_sinks() {
	// test sinks

	madSinkArg0(source()); // $ ir
	notASink(source());
	madSinkArg1(source(), 0);
	madSinkArg1(0, source()); // $ ir
	madSinkArg01(source(), 0, 0); // $ ir
	madSinkArg01(0, source(), 0); // $ ir
	madSinkArg01(0, 0, source());
	madSinkArg02(source(), 0, 0); // $ ir
	madSinkArg02(0, source(), 0);
	madSinkArg02(0, 0, source()); // $ ir

	int a = source();
	madSinkIndirectArg0(&a); // $ MISSING: ir

	madSinkVar = source();  // $ ir

	// test sources + sinks together

	madSinkArg0(localMadSource()); // $ ir
	madSinkIndirectArg0(remoteMadSourceIndirect()); // $ MISSING: ir
	madSinkVar = remoteMadSourceVar; // $ ir
}

void madSinkParam0(int x) { // $ interpretElement
	x = source(); // $ MISSING: ir
}

// --- global MAD summaries ---

struct MyContainer {
	int value;
	int *ptr;
};

int madArg0ToReturn(int x); // $ interpretElement
int notASummary(int x);
int madArg0ToReturnValueFlow(int x); // $ interpretElement
int madArg0IndirectToReturn(int *x); // $ interpretElement
void madArg0ToArg1Indirect(int x, int &y); // $ interpretElement
void madArg0IndirectToArg1Indirect(const int *x, int *y); // $ interpretElement

int madArg0FieldToReturn(MyContainer mc); // $ interpretElement
int madArg0IndirectFieldToReturn(MyContainer *mc); // $ interpretElement
int madArg0FieldIndirectToReturn(MyContainer mc); // $ interpretElement
MyContainer madArg0ToReturnField(int x); // $ interpretElement

void test_summaries() {
	// test summaries

	int a, b, c, d, e;

	sink(madArg0ToReturn(0));
	sink(madArg0ToReturn(source())); // $ ir
	sink(notASummary(source()));
	sink(madArg0ToReturnValueFlow(0));
	sink(madArg0ToReturnValueFlow(source())); // $ ir

	a = source();
	sink(madArg0IndirectToReturn(&a)); // $ MISSING: ir

	madArg0ToArg1Indirect(source(), b);
	sink(b); // $ MISSING: ir

	madArg0IndirectToArg1Indirect(&a, &c);
	sink(c); // $ MISSING: ir

	MyContainer mc1, mc2;

	d = 0;
	mc1.value = 0;
	mc1.ptr = &d;
	sink(madArg0FieldToReturn(mc1));
	sink(madArg0IndirectFieldToReturn(&mc1));
	sink(madArg0FieldIndirectToReturn(mc1));

	e = source();
	mc2.value = source();
	mc2.ptr = &e;
	sink(madArg0FieldToReturn(mc2)); // $ MISSING: ir
	sink(madArg0IndirectFieldToReturn(&mc2)); // $ MISSING: ir
	sink(madArg0FieldIndirectToReturn(mc2)); // $ MISSING: ir

	sink(madArg0ToReturnField(0).value);
	sink(madArg0ToReturnField(source()).value); // $ MISSING: ir

	// test source + sinks + summaries together

	madSinkArg0(madArg0ToReturn(remoteMadSource())); // $ ir
	madSinkArg0(madArg0ToReturnValueFlow(remoteMadSource())); // $ ir
	madSinkArg0(madArg0IndirectToReturn(remoteMadSourceIndirect())); // $ MISSING: ir*/
}

// --- MAD class members ---

class MyClass {
public:
	// sources
	int memberRemoteMadSource(); // $ interpretElement
	void memberRemoteMadSourceIndirectArg0(int *x); // $ interpretElement
	int memberRemoteMadSourceVar; // $ interpretElement
	void qualifierSource(); // $ interpretElement

	// sinks
	void memberMadSinkArg0(int x); // $ interpretElement
	int memberMadSinkVar; // $ interpretElement
	void qualifierSink(); // $ interpretElement
	void qualifierArg0Sink(int x); // $ interpretElement

	// summaries
	void madArg0ToSelf(int x); // $ interpretElement
	int madSelfToReturn(); // $ interpretElement
	int notASummary();
	void madArg0ToField(int x); // $ interpretElement
	int madFieldToReturn(); // $ interpretElement

	int val;
};

class MyDerivedClass : public MyClass {
public:
	int subtypeRemoteMadSource1(); // $ interpretElement
	int subtypeNonSource();
	int subtypeRemoteMadSource2(); // $ interpretElement
};

MyClass source2();
void sink(MyClass mc);

namespace MyNamespace {
	class MyClass {
	public:
		// sinks
		void namespaceMemberMadSinkArg0(int x); // $ interpretElement
		static void namespaceStaticMemberMadSinkArg0(int x); // $ interpretElement
		int namespaceMemberMadSinkVar; // $ interpretElement
		static int namespaceStaticMemberMadSinkVar; // $ interpretElement

		// summaries
		int namespaceMadSelfToReturn(); // $ interpretElement
	};
}

MyNamespace::MyClass source3();

void test_class_members() {
	MyClass mc, mc2, mc3, mc4, mc5, mc6, mc7, mc8, mc9;
	MyClass *ptr, *mc4_ptr;
	MyDerivedClass mdc;
	MyNamespace::MyClass mnc, mnc2;
	MyNamespace::MyClass *mnc2_ptr;

	// test class member sources

	sink(mc.memberRemoteMadSource()); // $ ir

	int a;
	mc.memberRemoteMadSourceIndirectArg0(&a);
	sink(a); // $ MISSING: ir

	sink(mc.memberRemoteMadSourceVar); // $ ir

	// test subtype sources

	sink(mdc.memberRemoteMadSource()); // $ ir
	sink(mdc.subtypeRemoteMadSource1()); // $ ir
	sink(mdc.subtypeNonSource());
	sink(mdc.subtypeRemoteMadSource2()); // $ ir

	// test class member sinks

	mc.memberMadSinkArg0(source()); // $ ir

	mc.memberMadSinkVar = source(); // $ ir

	mnc.namespaceMemberMadSinkArg0(source()); // $ ir
	MyNamespace::MyClass::namespaceStaticMemberMadSinkArg0(source()); // $ ir
	mnc.namespaceMemberMadSinkVar = source(); // $ ir
	MyNamespace::MyClass::namespaceStaticMemberMadSinkVar = source(); // $ ir

	// test class member summaries

	sink(mc2);
	mc2.madArg0ToSelf(0);
	sink(mc2);
	mc2.madArg0ToSelf(source());
	sink(mc2); // $ ir

	ptr = new MyClass();
	sink(*ptr);
	ptr->madArg0ToSelf(0);
	sink(*ptr);
	ptr->madArg0ToSelf(source());
	sink(*ptr); // $ ir

	mc3.madArg0ToField(source());
	sink(mc3.val); // $ MISSING: ir

	mc4 = source2();
	mc4_ptr = &mc4;
	sink(mc4); // $ ir
	sink(mc4.madSelfToReturn()); // $ ir
	sink(mc4.notASummary());
	sink(mc4_ptr->madSelfToReturn()); // $ ir
	sink(mc4_ptr->notASummary());
	sink(source2().madSelfToReturn()); // $ MISSING: ir (works if flow is modelled from qualifier *address*)
	sink(source2().notASummary());

	mc5.val = source();
	sink(mc5.madFieldToReturn()); // $ MISSING: ir

	mnc2 = source3();
	mnc2_ptr = &mnc2;
	sink(mnc2.namespaceMadSelfToReturn()); // $ ir
	sink(mnc2_ptr->namespaceMadSelfToReturn()); // $ ir
	sink(source3().namespaceMadSelfToReturn()); // $ MISSING: ir (works if flow is modelled from qualifier *address*)

	// test class member sources + sinks + summaries together

	mc.memberMadSinkArg0(mc.memberRemoteMadSource()); // $ ir

	mc6.madArg0ToSelf(source());
	sink(mc6.madSelfToReturn()); // $ ir

	mc7.madArg0ToField(source());
	sink(mc7.madFieldToReturn()); // $ MISSING: ir

	// test taint through qualifier

	sink(mc8);
	mc8.qualifierArg0Sink(0);
	mc8.qualifierArg0Sink(source()); // $ ir

	mc9 = source2();
	mc9.qualifierSink(); // $ ir
	mc9.qualifierArg0Sink(0); // $ ir

	mc8.qualifierSource();
	sink(mc8); // $ ir
	mc8.qualifierSink(); // $ ir
	mc9.qualifierArg0Sink(0); // $ ir
}

// --- MAD cases involving function pointers ---

struct intPair {
	int first;
	int second;
};

int madCallArg0ReturnToReturn(int (*fun_ptr)()); // $ interpretElement
intPair madCallArg0ReturnToReturnFirst(int (*fun_ptr)()); // $ interpretElement
void madCallArg0WithValue(void (*fun_ptr)(int), int value); // $ interpretElement

int getTainted() { return source(); }
void useValue(int x) { sink(x); }

void test_function_pointers() {
	sink(madCallArg0ReturnToReturn(&notASource));
	sink(madCallArg0ReturnToReturn(&getTainted)); // $ MISSING: ir
	sink(madCallArg0ReturnToReturn(&source)); // $ MISSING: ir
	sink(madCallArg0ReturnToReturnFirst(&source).first); // $ MISSING: ir
	sink(madCallArg0ReturnToReturnFirst(&source).second);
	madCallArg0WithValue(&useValue, 0);
	madCallArg0WithValue(&useValue, source()); // $ MISSING: ir
	madCallArg0WithValue(&sink, source()); // $ MISSING: ir
}
