
// non-MAD sources / sinks
int source();
int *sourcePtr();
int *sourceIndirect();
void sink(int val);
void sink(int *ptr);

// --- global MAD sources ---

int localMadSource(); // $ interpretElement
int remoteMadSource(); // $ interpretElement
int notASource();
int localMadSourceVoid(void); // $ interpretElement
int localMadSourceHasBody() { return 0; } // $ interpretElement
int *remoteMadSourceIndirect(); // $ interpretElement
int **remoteMadSourceDoubleIndirect(); // $ interpretElement
void remoteMadSourceIndirectArg0(int *x, int *y); // $ interpretElement
void remoteMadSourceIndirectArg1(int &x, int &y); // $ interpretElement
int remoteMadSourceVar; // $ interpretElement
int *remoteMadSourceVarIndirect; // $ interpretElement

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

	sink(sourceIndirect());
	sink(*sourceIndirect()); // $ ir

	int v = localMadSource();
	int *v_indirect = &v;
	int v_direct = *v_indirect;
	sink(v); // $ ir
	sink(v_indirect);
	sink(*v_indirect); // $ ir
	sink(v_direct); // $ ir

	sink(remoteMadSourceIndirect());
	sink(*remoteMadSourceIndirect()); // $ MISSING: ir
	sink(*remoteMadSourceDoubleIndirect());
	sink(**remoteMadSourceDoubleIndirect()); // $ MISSING: ir

	int a, b, c, d;

	remoteMadSourceIndirectArg0(&a, &b);
	sink(a); // $ ir
	sink(b);
	remoteMadSourceIndirectArg1(c, d);
	sink(c);
	sink(d); // $ ir

	sink(remoteMadSourceVar); // $ ir
	sink(*remoteMadSourceVarIndirect); // $ MISSING: ir

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
void madSinkDoubleIndirectArg0(int **x); // $ interpretElement
int madSinkVar; // $ interpretElement
int *madSinkVarIndirect; // $ interpretElement

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
	int *a_ptr = &a;
	madSinkIndirectArg0(&a); // $ ir
	madSinkIndirectArg0(a_ptr); // $ ir
	madSinkDoubleIndirectArg0(&a_ptr); // $ ir

	madSinkVar = source();  // $ ir

	// test sources + sinks together

	madSinkArg0(localMadSource()); // $ ir
	madSinkIndirectArg0(remoteMadSourceIndirect()); // $ MISSING: ir
	madSinkVar = remoteMadSourceVar; // $ ir
	*madSinkVarIndirect = remoteMadSourceVar; // $ MISSING: ir
}

void madSinkParam0(int x) { // $ interpretElement
	x = source(); // $ MISSING: ir
}

// --- global MAD summaries ---

struct MyContainer {
	int value;
	int value2;
	int *ptr;
};

int madArg0ToReturn(int x); // $ interpretElement
int *madArg0ToReturnIndirect(int x); // $ interpretElement
int notASummary(int x);
int madArg0ToReturnValueFlow(int x); // $ interpretElement
int madArg0IndirectToReturn(int *x); // $ interpretElement
int madArg0DoubleIndirectToReturn(int **x); // $ interpretElement
int madArg0NotIndirectToReturn(int *x); // $ interpretElement
void madArg0ToArg1Indirect(int x, int &y); // $ interpretElement
void madArg0IndirectToArg1Indirect(const int *x, int *y); // $ interpretElement
int madArgsComplex(int *a, int *b, int c, int d); // $ interpretElement
int madArgsAny(int a, int *b); // $ interpretElement
int madAndImplementedComplex(int a, int b, int c) { // $ interpretElement
	// (`b` can be seen to flow to the return value in code, `c` via the MAD model)
	return b;
}

int madArg0FieldToReturn(MyContainer mc); // $ interpretElement
int madArg0IndirectFieldToReturn(MyContainer *mc); // $ interpretElement
int madArg0FieldIndirectToReturn(MyContainer mc); // $ interpretElement
MyContainer madArg0ToReturnField(int x); // $ interpretElement
MyContainer *madArg0ToReturnIndirectField(int x); // $ interpretElement
MyContainer madArg0ToReturnFieldIndirect(int x); // $ interpretElement

MyContainer madFieldToFieldVar; // $ interpretElement
MyContainer madFieldToIndirectFieldVar; // $ interpretElement
MyContainer *madIndirectFieldToFieldVar; // $ interpretElement

void test_summaries() {
	// test summaries

	int a, b, c, d, e;
	int *a_ptr;

	sink(madArg0ToReturn(0));
	sink(madArg0ToReturn(source())); // $ ir
	sink(*madArg0ToReturnIndirect(0));
	sink(*madArg0ToReturnIndirect(source())); // $ ir
	sink(notASummary(source()));
	sink(madArg0ToReturnValueFlow(0));
	sink(madArg0ToReturnValueFlow(source())); // $ ir

	a = source();
	a_ptr = &a;
	sink(madArg0IndirectToReturn(&a)); // $ ir
	sink(madArg0IndirectToReturn(a_ptr)); // $ ir
	sink(madArg0DoubleIndirectToReturn(&a_ptr)); // $ ir
	sink(madArg0NotIndirectToReturn(a_ptr));
	sink(madArg0NotIndirectToReturn(sourcePtr())); // $ ir
	sink(madArg0NotIndirectToReturn(sourceIndirect()));

	madArg0ToArg1Indirect(source(), b);
	sink(b); // $ ir

	madArg0IndirectToArg1Indirect(&a, &c);
	sink(c); // $ ir

	sink(madArgsComplex(0, 0, 0, 0));
	sink(madArgsComplex(sourceIndirect(), 0, 0, 0)); // $ ir
	sink(madArgsComplex(0, sourceIndirect(), 0, 0)); // $ ir
	sink(madArgsComplex(0, 0, source(), 0)); // $ ir
	sink(madArgsComplex(0, 0, 0, source()));

	sink(madAndImplementedComplex(0, 0, 0));
	sink(madAndImplementedComplex(source(), 0, 0));
	sink(madAndImplementedComplex(0, source(), 0)); // Clean. We have a MaD model specifying different behavior.
	sink(madAndImplementedComplex(0, 0, source())); // $ ir

	sink(madArgsAny(0, 0));
	sink(madArgsAny(source(), 0)); // (syntax not supported)
	sink(madArgsAny(0, sourcePtr())); // (syntax not supported)
	sink(madArgsAny(0, sourceIndirect())); // (syntax not supported)

	// test summaries involving structs / fields

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
	sink(madArg0FieldToReturn(mc2)); // $ ir
	sink(madArg0IndirectFieldToReturn(&mc2)); // $ ir
	sink(madArg0FieldIndirectToReturn(mc2)); // $ ir

	sink(madArg0ToReturnField(0).value);
	sink(madArg0ToReturnField(source()).value); // $ ir

	MyContainer *rtn1 = madArg0ToReturnIndirectField(source());
	sink(rtn1->value); // $ ir

	MyContainer rtn2 = madArg0ToReturnFieldIndirect(source());
	int *rtn2_ptr = rtn2.ptr;
	sink(*rtn2_ptr); // $ ir

	// test global variable summaries

	madFieldToFieldVar.value = source();
	sink(madFieldToFieldVar.value2); // $ MISSING: ir

	madFieldToIndirectFieldVar.value = source();
	sink(madFieldToIndirectFieldVar.ptr);
	sink(*(madFieldToIndirectFieldVar.ptr)); // $ MISSING: ir

	madIndirectFieldToFieldVar->value = source();
	sink((*madIndirectFieldToFieldVar).value2); // $ MISSING: ir
	sink(madIndirectFieldToFieldVar->value2); // $ MISSING: ir

	// test source + sinks + summaries together

	madSinkArg0(madArg0ToReturn(remoteMadSource())); // $ ir
	madSinkArg0(madArg0ToReturnValueFlow(remoteMadSource())); // $ ir
	madSinkArg0(madArg0IndirectToReturn(sourcePtr()));
	madSinkArg0(madArg0IndirectToReturn(sourceIndirect())); // $ ir
}

// --- MAD class members ---

class MyClass {
public:
	// sources
	int memberRemoteMadSource(); // $ interpretElement
	void memberRemoteMadSourceIndirectArg0(int *x); // $ interpretElement
	int memberRemoteMadSourceVar; // $ interpretElement
	void qualifierSource(); // $ interpretElement
	void qualifierFieldSource(); // $ interpretElement

	// sinks
	void memberMadSinkArg0(int x); // $ interpretElement
	int memberMadSinkVar; // $ interpretElement
	void qualifierSink(); // $ interpretElement
	void qualifierArg0Sink(int x); // $ interpretElement
	void qualifierFieldSink(); // $ interpretElement

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
	MyClass mc, mc2, mc3, mc4, mc5, mc6, mc7, mc8, mc9, mc10, mc11;
	MyClass *ptr, *mc4_ptr;
	MyDerivedClass mdc;
	MyNamespace::MyClass mnc, mnc2;
	MyNamespace::MyClass *mnc2_ptr;

	// test class member sources

	sink(mc.memberRemoteMadSource()); // $ ir

	int a;
	mc.memberRemoteMadSourceIndirectArg0(&a);
	sink(a); // $ ir

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
	sink(mc3.val); // $ ir

	mc4 = source2();
	mc4_ptr = &mc4;
	sink(mc4); // $ ir
	sink(mc4.madSelfToReturn()); // $ ir
	sink(mc4.notASummary());
	sink(mc4_ptr->madSelfToReturn()); // $ ir
	sink(mc4_ptr->notASummary());
	sink(source2().madSelfToReturn()); // $ ir
	sink(source2().notASummary());

	mc5.val = source();
	sink(mc5.madFieldToReturn()); // $ ir

	mnc2 = source3();
	mnc2_ptr = &mnc2;
	sink(mnc2.namespaceMadSelfToReturn()); // $ ir
	sink(mnc2_ptr->namespaceMadSelfToReturn()); // $ ir
	sink(source3().namespaceMadSelfToReturn()); // $ ir

	// test class member sources + sinks + summaries together

	mc.memberMadSinkArg0(mc.memberRemoteMadSource()); // $ ir

	mc6.madArg0ToSelf(source());
	sink(mc6.madSelfToReturn()); // $ ir

	mc7.madArg0ToField(source());
	sink(mc7.madFieldToReturn()); // $ ir

	// test taint involving qualifier

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

	// test taint involving qualifier field

	sink(mc10.val);
	mc10.qualifierFieldSource();
	sink(mc10.val); // $ MISSING: ir

	mc11.val = source();
	sink(mc11.val); // $ ir
	mc11.qualifierFieldSink(); // $ MISSING: ir
}

// --- MAD cases involving function pointers ---

struct intPair {
	int first;
	int second;
};

int madCallArg0ReturnToReturn(int (*fun_ptr)()); // $ interpretElement
intPair madCallArg0ReturnToReturnFirst(int (*fun_ptr)()); // $ interpretElement
void madCallArg0WithValue(void (*fun_ptr)(int), int value); // $ interpretElement
int madCallReturnValueIgnoreFunction(void (*fun_ptr)(int), int value); // $ interpretElement

int getTainted() { return source(); }
void useValue(int x) { sink(x); } // $ ir
void dontUseValue(int x) { }

void test_function_pointers() {
	sink(madCallArg0ReturnToReturn(&notASource));
	sink(madCallArg0ReturnToReturn(&getTainted)); // $ ir
	sink(madCallArg0ReturnToReturn(&source)); // $ MISSING: ir
	sink(madCallArg0ReturnToReturnFirst(&getTainted).first); // $ ir
	sink(madCallArg0ReturnToReturnFirst(&getTainted).second);

	madCallArg0WithValue(&useValue, source());
	madCallArg0WithValue(&sink, source()); // $ MISSING: ir
	madCallReturnValueIgnoreFunction(&sink, source());
	sink(madCallReturnValueIgnoreFunction(&dontUseValue, source())); // $ ir
}

template<typename X>
struct StructWithTypedefInParameter {
	typedef X Type;
	X& parameter_ref_to_return_ref(const Type& x); // $ interpretElement
};

void test_parameter_ref_to_return_ref() {
	int x = source();
	StructWithTypedefInParameter<int> s;
	int y = s.parameter_ref_to_return_ref(x);
	sink(y); // $ ir
}

using INT = int;

int receive_array(INT a[20]); // $ interpretElement

void test_receive_array() {
	int x = source();
	int array[10] = {x};
	int y = receive_array(array);
	sink(y); // $ ir
}