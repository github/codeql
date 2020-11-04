
#include "stl.h"

using namespace std;

int source();

namespace ns_int
{
	int source();
}

void sink(int);
template<typename T> void sink(std::vector<T> &);

void test_range_based_for_loop_vector(int source1) {
	std::vector<int> v(100, source1);

	for(int x : v) {
		sink(x); // tainted [NOT DETECTED by IR]
	}

	for(std::vector<int>::iterator it = v.begin(); it != v.end(); ++it) {
		sink(*it); // tainted [NOT DETECTED by IR]
	}

	for(int& x : v) {
		sink(x); // tainted [NOT DETECTED by IR]
	}

	const std::vector<int> const_v(100, source1);
	for(const int& x : const_v) {
		sink(x); // tainted [NOT DETECTED by IR]
	}
}

void test_element_taint(int x) {
	std::vector<int> v1(10), v2(10), v3(10), v4(10), v5(10), v6(10), v7(10), v8(10), v9(10);

	v1[0] = 0;
	v1[1] = 0;
	v1[x] = 0;
	v1.push_back(1);
	sink(v1);
	sink(v1[0]);
	sink(v1[1]);
	sink(v1[x]);
	sink(v1.front());
	sink(v1.back());

	v2[0] = source();
	sink(v2); // tainted
	sink(v2[0]); // tainted
	sink(v2[1]); // [FALSE POSITIVE]
	sink(v2[x]); // potentially tainted

	v3 = v2;
	sink(v3); // tainted
	sink(v3[0]); // tainted
	sink(v3[1]); // [FALSE POSITIVE]
	sink(v3[x]); // potentially tainted

	v4[x] = source();
	sink(v4); // tainted
	sink(v4[0]); // potentially tainted
	sink(v4[1]); // potentially tainted
	sink(v4[x]); // tainted

	v5.push_back(source());
	sink(v5); // tainted
	sink(v5.front()); // [FALSE POSITIVE]
	sink(v5.back()); // tainted

	v6.data()[2] = source();
	sink(v6); // tainted
	sink(v6.data()[2]); // tainted


	{
		std::vector<int>::const_iterator it = v7.begin();
		v7.insert(it, source());
	}
	sink(v7); // tainted
	sink(v7.front()); // tainted
	sink(v7.back()); // [FALSE POSITIVE]

	{
		const std::vector<int> &v8c = v8;
		std::vector<int>::const_iterator it = v8c.begin();
		v8.insert(it, 10, ns_int::source());
	}
	sink(v8); // tainted [NOT DETECTED]
	sink(v8.front()); // tainted [NOT DETECTED]
	sink(v8.back());

	v9.at(x) = source();
	sink(v9); // tainted
	sink(v9.at(0)); // potentially tainted
	sink(v9.at(1)); // potentially tainted
	sink(v9.at(x)); // tainted
}

void test_vector_swap() {
	std::vector<int> v1(10), v2(10), v3(10), v4(10);

	v1.push_back(source());
	v4.push_back(source());

	sink(v1); // tainted
	sink(v2);
	sink(v3);
	sink(v4); // tainted

	v1.swap(v2);
	v3.swap(v4);

	sink(v1); // [FALSE POSITIVE]
	sink(v2); // tainted
	sink(v3); // tainted
	sink(v4); // [FALSE POSITIVE]
}

void test_vector_clear() {
	std::vector<int> v1(10), v2(10), v3(10), v4(10);

	v1.push_back(source());
	v2.push_back(source());
	v3.push_back(source());

	sink(v1); // tainted
	sink(v2); // tainted
	sink(v3); // tainted
	sink(v4);

	v1.clear();
	v2 = v2;
	v3 = v4;

	sink(v1); // [FALSE POSITIVE]
	sink(v2); // tainted
	sink(v3); // [FALSE POSITIVE]
	sink(v4);
}

struct MyPair
{
	int a, b;
};

struct MyVectorContainer
{
	std::vector<int> vs;
};

void test_nested_vectors()
{
	{
		int aa[10][20] = {0};

		sink(aa[0][0]);
		aa[0][0] = source();
		sink(aa[0][0]); // tainted
	}

	{
		std::vector<std::vector<int> > bb(30);

		bb[0].push_back(0);
		sink(bb[0][0]);
		bb[0][0] = source();
		sink(bb[0][0]); // tainted
	}

	{
		std::vector<int> cc[40];

		cc[0].push_back(0);
		sink(cc[0][0]);
		cc[0][0] = source();
		sink(cc[0][0]); // tainted
	}

	{
		std::vector<MyPair> dd;
		MyPair mp = {0, 0};

		dd.push_back(mp);
		sink(dd[0].a);
		sink(dd[0].b);
		dd[0].a = source();
		sink(dd[0].a); // tainted [NOT DETECTED]
		sink(dd[0].b);
	}

	{
		MyVectorContainer ee;

		ee.vs.push_back(0);
		sink(ee.vs[0]);
		ee.vs[0] = source();
		sink(ee.vs[0]); // tainted
	}

	{
		std::vector<MyVectorContainer> ff;
		MyVectorContainer mvc;

		mvc.vs.push_back(0);
		ff.push_back(mvc);
		sink(ff[0].vs[0]);
		ff[0].vs[0] = source();
		sink(ff[0].vs[0]); // tainted [NOT DETECTED]
	}
}

void sink(std::vector<int>::iterator &);

typedef int myInt;
typedef float myFloat;

namespace ns_myFloat
{
	myFloat source();
}

namespace ns_ci_ptr
{
	const int *source();
}

void sink(std::vector<myFloat> &);
void sink(std::vector<const int *> &);

void test_vector_assign() {
	std::vector<int> v1, v2, v3;

	v1.assign(100, 0);
	v2.assign(100, ns_int::source());
	v3.push_back(source());

	sink(v1);
	sink(v2); // tainted
	sink(v3); // tainted

	{
		std::vector<int> v4, v5, v6;
		std::vector<int>::iterator i1, i2;
	
		v4.assign(v1.begin(), v1.end());
		v5.assign(v3.begin(), v3.end());
		i1 = v3.begin();
		i1++;
		i2 = i1;
		i2++;
		v6.assign(i1, i2);

		sink(v4);
		sink(v5); // tainted
		sink(i1); // tainted
		sink(i2); // tainted
		sink(v6); // tainted
	}

	{
		std::vector<myInt> v7;
		std::vector<myFloat> v8;
		std::vector<const int *> v9;

		v7.assign(100, ns_int::source());
		v8.assign(100, ns_myFloat::source());
		v9.assign(100, ns_ci_ptr::source());

		sink(v7); // tainted
		sink(v8); // tainted
		sink(v9); // tainted
	}
}

void sink(int *);

void test_data_more() {
	std::vector<int> v1, v2;

	v1.push_back(source());
	sink(v1); // tainted
	sink(v1.data()); // tainted
	sink(v1.data()[2]); // tainted

	*(v2.data()) = ns_int::source();
	sink(v2); // tainted
	sink(v2.data()); // tainted
	sink(v2.data()[2]); // tainted
}

void sink(std::vector<int>::iterator);

void test_vector_insert() {
	std::vector<int> a;
	std::vector<int> b;
	std::vector<int> c;
	std::vector<int> d;

	d.push_back(source());

	sink(a.insert(a.end(), b.begin(), b.end()));
	sink(a);

	sink(c.insert(c.end(), d.begin(), d.end())); // tainted
	sink(c); // tainted

	sink(d.insert(d.end(), a.begin(), a.end())); // tainted
	sink(d); // tainted
}

void test_vector_constructors_more() {
	std::vector<int> v1;
	std::vector<int> v2;
	v2.push_back(source());

	std::vector<int> v3(v1.begin(), v1.end());
	std::vector<int> v4(v2.begin(), v2.end());

	sink(v1);
	sink(v2); // tainted
	sink(v3);
	sink(v4); // tainted
}

void taint_vector_output_iterator(std::vector<int>::iterator iter) {
	*iter = source();
}

void vector_iterator_assign_wrapper(std::vector<int>::iterator iter, int i) {
	*iter = i;
}

void test_vector_output_iterator(int b) {
	std::vector<int> v1(10), v2(10), v3(10), v4(10), v5(10), v6(10), v7(10), v8(10), v9(10), v10(10), v11(10), v12(10), v13(10), v14(10);

	std::vector<int>::iterator i1 = v1.begin();
	*i1 = source();
	sink(v1); // tainted [NOT DETECTED by IR]

	for(std::vector<int>::iterator it = v2.begin(); it != v2.end(); ++it) {
		*it = source();
	}
	sink(v2); // tainted [NOT DETECTED by IR]

	for(int& x : v3) {
		x = source();
	}
	sink(v3); // tainted [NOT DETECTED]

	for(std::vector<int>::iterator it = v4.begin(); it != v4.end(); ++it) {
		taint_vector_output_iterator(it);
	}
	sink(v4); // tainted [NOT DETECTED by IR]
	
	std::vector<int>::iterator i5 = v5.begin();
	*i5 = source();
	sink(v5); // tainted [NOT DETECTED by IR]
	*i5 = 1;
	sink(v5); // tainted [NOT DETECTED by IR]

	std::vector<int>::iterator i6 = v6.begin();
	*i6 = source();
	sink(v6); // tainted [NOT DETECTED by IR]
	v6 = std::vector<int>(10);
	sink(v6); // [FALSE POSITIVE in AST]

	std::vector<int>::iterator i7 = v7.begin();
	if(b) {
		*i7 = source();
		sink(v7); // tainted [NOT DETECTED by IR]
	} else {
		*i7 = 1;
		sink(v7);
	}
	sink(v7); // tainted [NOT DETECTED by IR]

	std::vector<int>::iterator i8 = v8.begin();
	*i8 = source();
	sink(v8); // tainted [NOT DETECTED by IR]
	*i8 = 1;
	sink(v8);

	std::vector<int>::iterator i9 = v9.begin();

	*i9 = source();
	taint_vector_output_iterator(i9);

	sink(v9);

	std::vector<int>::iterator i10 = v10.begin();
	vector_iterator_assign_wrapper(i10, 10);
	sink(v10);

	std::vector<int>::iterator i11 = v11.begin();
	vector_iterator_assign_wrapper(i11, source());
	sink(v11); // tainted [NOT DETECTED by IR]

	std::vector<int>::iterator i12 = v12.begin();
	*i12++ = 0;
	*i12 = source();
	sink(v12); // tainted [NOT DETECTED by IR]

	std::vector<int>::iterator i13 = v13.begin();
	*i13++ = source();
	sink(v13); // tainted [NOT DETECTED by IR]

	std::vector<int>::iterator i14 = v14.begin();
	i14++;
	*i14++ = source();
	sink(v14); // tainted [NOT DETECTED by IR]
}

void test_vector_inserter(char *source_string) {
	{
		std::vector<std::string> out;
		auto it = out.end();
		*it++ = std::string(source_string);
		sink(out); // tainted [NOT DETECTED by IR]
	}

	{
		std::vector<std::string> out;
		auto it = std::back_inserter(out);
		*it++ = std::string(source_string);
		sink(out); // tainted [NOT DETECTED by IR]
	}

	{
		std::vector<int> out;
		auto it = std::back_inserter(out);
		*it++ = source();
		sink(out); // tainted [NOT DETECTED by IR]
	}

	{
		std::vector<std::string> out;
		auto it = std::back_inserter(out);
		*++it = std::string(source_string);
		sink(out); // tainted [NOT DETECTED by IR]
	}

	{
		std::vector<int> out;
		auto it = std::back_inserter(out);
		*++it = source();
		sink(out); // tainted [NOT DETECTED by IR]
	}
}

void *memcpy(void *s1, const void *s2, size_t n);

namespace ns_string
{
	std::string source();
}

void sink(std::vector<char> &);
void sink(std::string &);

void test_vector_memcpy()
{
	{
		std::vector<int> v(100);
		int s = source();
		int i = 0;

		sink(v);
		memcpy(&v[i], &s, sizeof(int));
		sink(v); // tainted [NOT DETECTED by IR]
	}

	{
		std::vector<char> cs(100);
		std::string src = ns_string::source();
		const size_t offs = 10;
		const size_t len = src.length();

		sink(src); // tainted
		sink(cs);
		memcpy(&cs[offs + 1], src.c_str(), len);
		sink(src); // tainted
		sink(cs); // tainted [NOT DETECTED by IR]
	}
}

void test_vector_emplace() {
	std::vector<int> v1(10), v2(10);

	v1.emplace_back(source());
	sink(v1); // tainted

	v2.emplace(v2.begin(), source());
	sink(v2); // tainted
}
