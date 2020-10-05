# Upcast array used in pointer arithmetic

```
ID: cpp/upcast-array-pointer-arithmetic
Kind: path-problem
Severity: warning
Precision: high
Tags: correctness reliability security external/cwe/cwe-119 external/cwe/cwe-843

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Conversion/CastArrayPointerArithmetic.ql)

A pointer to a derived class may be implicitly converted to a pointer to its base type when passed as an argument to a function expecting a pointer to the base type. If pointer arithmetic or an array dereference is then used, it will be performed using the size of the base type. This can lead to reading data from unexpected fields in the derived type.


## Recommendation
Only convert pointers to single objects. If you must work with a sequence of objects that are converted to a base type, use an array of pointers rather than a pointer to an array.


## Example

```cpp
class Base {
public:
	int x;
}

class Derived: public Base {
public:
	int y;
};

void dereference_base(Base *b) {
	b[2].x;
}

void dereference_derived(Derived *d) {
	d[2].x;
}

void test () {
	Derived[4] d;
	dereference_base(d); // BAD: implicit conversion to Base*

	dereference_derived(d); // GOOD: implicit conversion to Derived*, which will be the right size
}

```