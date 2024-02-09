
// non-MAD sources / sinks
int source();
void sink(int val);

// --- global MAD sources ---

int localMadSource();
int remoteMadSource();
int notASource();
int localMadSourceVoid(void);
int localMadSourceHasBody() { return 0; }
int *remoteMadSourceIndirect();
void remoteMadSourceArg0(int *x, int *y);
void remoteMadSourceArg1(int &x, int &y);
int remoteMadSourceVar;
void remoteMadSourceParam0(int x);

namespace MyNamespace {
	int namespaceLocalMadSource();
	int namespaceLocalMadSourceVar;

	namespace MyNamespace2 {
		int namespace2LocalMadSource();
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

	remoteMadSourceArg0(&a, &b);
	sink(a); // $ MISSING: ir
	sink(a);
	remoteMadSourceArg1(c, d);
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

void remoteMadSourceParam0(int x)
{
	sink(x); // $ ir
}

// --- global MAD sinks ---

void madSinkArg0(int x);
void notASink(int x);
void madSinkArg1(int x, int y);
void madSinkArg01(int x, int y, int z);
void madSinkArg02(int x, int y, int z);
void madSinkIndirectArg0(int *x);
int madSinkVar;

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

void madSinkParam0(int x) {
	x = source(); // $ MISSING: ir
}

// --- MAD summaries ---

struct MyContainer {
	int value;
};

int madArg0ToReturn(int x);
int notASummary(int x);
int madArg0ToReturnValueFlow(int x);
int madArg0IndirectToReturn(int *x);
void madArg0ToArg1(int x, int &y);
void madArg0IndirectToArg1(const int *x, int *y);

int madArg0FieldToReturn(MyContainer mc);
int madArg0IndirectFieldToReturn(MyContainer *mc);
MyContainer madArg0ToReturnField(int x);

void test_summaries() {
	// test summaries

	int a, b, c;

	sink(madArg0ToReturn(0));
	sink(madArg0ToReturn(source())); // $ MISSING: ir
	sink(notASummary(source()));
	sink(madArg0ToReturnValueFlow(0));
	sink(madArg0ToReturnValueFlow(source())); // $ MISSING: ir

	a = source();
	sink(madArg0IndirectToReturn(&a)); // $ MISSING: ir

	madArg0ToArg1(source(), b);
	sink(b); // $ MISSING: ir

	madArg0IndirectToArg1(&a, &c);
	sink(c); // $ MISSING: ir

	MyContainer mc1, mc2;

	mc1.value = 0;
	sink(madArg0FieldToReturn(mc1));
	sink(madArg0IndirectFieldToReturn(&mc1));

	mc2.value = source();
	sink(madArg0FieldToReturn(mc2)); // $ MISSING: ir
	sink(madArg0IndirectFieldToReturn(&mc2)); // $ MISSING: ir

	sink(madArg0ToReturnField(0).value);
	sink(madArg0ToReturnField(source()).value); // $ MISSING: ir

	// test source + sinks + summaries together

	madSinkArg0(madArg0ToReturn(remoteMadSource())); // $ MISSING: ir
	madSinkArg0(madArg0ToReturnValueFlow(remoteMadSource())); // $ MISSING: ir
	madSinkArg0(madArg0IndirectToReturn(remoteMadSourceIndirect())); // $ MISSING: ir*/
}

// --- MAD class members ---

class MyClass {
public:
	// sources
	int memberRemoteMadSource();
	void memberRemoteMadSourceArg0(int *x);
	int memberRemoteMadSourceVar;

	// sinks
	void memberMadSinkArg0(int x);
	int memberMadSinkVar;

	// summaries
	void madArg0ToSelf(int x);
	int madSelfToReturn();
	int notASummary();
	void madArg0ToField(int x);
	int madFieldToReturn();

	int val;
};

class MyDerivedClass : public MyClass {
public:
	int subtypeRemoteMadSource1();
	int subtypeNonSource();
	int subtypeRemoteMadSource2();
};

MyClass source2();
void sink(MyClass mc);

namespace MyNamespace {
	class MyClass {
	public:
		// sinks
		void namespaceMemberMadSinkArg0(int x);
		static void namespaceStaticMemberMadSinkArg0(int x);
		int namespaceMemberMadSinkVar;
		static int namespaceStaticMemberMadSinkVar;

		// summaries
		int namespaceMadSelfToReturn();
	};
}

MyNamespace::MyClass source3();

void test_class_members() {
	MyClass mc, mc2, mc3, mc4, mc5, mc6;
	MyDerivedClass mdc;
	MyNamespace::MyClass mnc;

	// test class member sources

	sink(mc.memberRemoteMadSource()); // $ ir

	int a;
	mc.memberRemoteMadSourceArg0(&a);
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
	sink(mc2); // $ MISSING: ir

	mc3.madArg0ToField(source());
	sink(mc3.val); // $ MISSING: ir

	sink(source2().madSelfToReturn()); // $ MISSING: ir
	sink(source2().notASummary());

	mc4.val = source();
	sink(mc4.madFieldToReturn()); // $ MISSING: ir

	sink(source3().namespaceMadSelfToReturn()); // $ MISSING: ir

	// test class member sources + sinks + summaries together

	mc.memberMadSinkArg0(mc.memberRemoteMadSource()); // $ ir

	mc5.madArg0ToSelf(source());
	sink(mc5.madSelfToReturn()); // $ MISSING: ir

	mc6.madArg0ToField(source());
	sink(mc6.madFieldToReturn()); // $ MISSING: ir
}
