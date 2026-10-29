
#include "stl.h"

using namespace std;
namespace {
char *source(); int source(int);
}
void sink(char *);
void sink(const char *);
void sink(bool);
void sink(std::pair<const char *, const char *>);
void sink(std::map<const char *, const char *>);
void sink(std::map<const char *, const char *>::iterator);
void sink(std::unordered_map<const char *, const char *>);
void sink(std::unordered_map<const char *, const char *>::iterator);
void sink(std::unordered_map<const char *, std::pair<int, int> >);
void sink(std::unordered_map<const char *, std::pair<int, int> >::iterator);

void test_pair()
{
	std::pair<const char *, const char *> a, b, c;

	a.first = "123";
	sink(a.first);
	sink(a.second);
	sink(a);

	b.first = source();
	sink(b.first); // $ ast,ir
	sink(b.second);
	sink(b); // $ ir MISSING: ast

	c.second = source();
	sink(c.first);
	sink(c.second); // $ ast,ir
	sink(c); // $ ir MISSING: ast

	std::pair<const char *, const char *> d("123", "456");
	sink(d.first);
	sink(d.second);
	sink(d);

	std::pair<const char *, const char *> e(source(), "456");
	sink(e.first); // $ ir MISSING: ast
	sink(e.second);
	sink(e); // $ ir MISSING: ast

	std::pair<const char *, const char *> f("123", source());
	sink(f.first);
	sink(f.second); // $ ir MISSING: ast
	sink(f); // $ ir MISSING: ast

	std::pair<const char *, const char *> g(f);
	sink(g.first);
	sink(g.second); // $ ir MISSING: ast
	sink(g); // $ ir MISSING: ast

	std::pair<const char *, const char *> h;
	h = f;
	sink(h.first);
	sink(h.second); // $ ir MISSING: ast
	sink(h); // $ ir MISSING: ast

	std::pair<const char *, const char *> i("123", "456");
	std::pair<const char *, const char *> j("123", source());
	std::pair<const char *, const char *> k("123", source());
	std::pair<const char *, const char *> l("123", "456");
 	i.swap(j);
	k.swap(l);
	sink(i.first);
	sink(i.second); // $ ir, MISSING: ast
	sink(i); // $ ir
	sink(j.first);
	sink(j.second);
	sink(j);
	sink(k.first);
	sink(k.second);
	sink(k);
	sink(l.first);
	sink(l.second); // $ ir, MISSING: ast
	sink(l); // $ ir

	sink(make_pair("123", "456"));
	sink(make_pair("123", "456").first);
	sink(make_pair("123", "456").second);
	sink(make_pair(source(), "456")); // $ ir MISSING: ast
	sink(make_pair(source(), "456").first); // $ ir MISSING: ast
	sink(make_pair(source(), "456").second);
	sink(make_pair("123", source())); // $ ir MISSING: ast
	sink(make_pair("123", source()).first);
	sink(make_pair("123", source()).second); // $ ir MISSING: ast

	std::pair<std::pair<const char *, const char *>, const char *> m;
	m = make_pair(make_pair("123", source()), "789");
	sink(m); // $ ir MISSING: ast
	sink(m.first); // $ ir MISSING: ast
	sink(m.first.first);
	sink(m.first.second); // $ ir MISSING: ast
	sink(m.second);
}

void test_map()
{
	// insert
	std::map<const char *, const char *> m1, m2, m3, m4, m5, m6;

	sink(m1.insert(std::make_pair("abc", "def")).first);
	sink(m2.insert(std::make_pair("abc", source())).first); // $ ir MISSING: ast
	sink(m3.insert(std::make_pair(source(), "def")).first); // $ MISSING: ast,ir
	sink(m4.insert(m4.begin(), std::pair<const char *, const char *>("abc", source()))); // $ ir MISSING: ast
	sink(m5.insert_or_assign("abc", source()).first); // $ ir MISSING: ast
	sink(m6.insert_or_assign(m6.begin(), "abc", source())); // $ ir MISSING: ast
	sink(m1);
	sink(m2); // $ ir MISSING: ast
	sink(m3); // $ MISSING: ast,ir
	sink(m4); // $ ir MISSING: ast
	sink(m5); // $ ir MISSING: ast
	sink(m6); // $ ir MISSING: ast
	sink(m1.find("abc"));
	sink(m2.find("abc")); // $ ir MISSING: ast
	sink(m3.find("abc"));
	sink(m4.find("abc")); // $ ir MISSING: ast
	sink(m5.find("abc")); // $ ir MISSING: ast
	sink(m6.find("abc")); // $ ir MISSING: ast
	sink(m1.find("def"));
	sink(m2.find("def")); // $ ir MISSING: ast
	sink(m3.find("def"));
	sink(m4.find("def")); // $ ir MISSING: ast
	sink(m5.find("def")); // $ ir MISSING: ast
	sink(m6.find("def")); // $ ir MISSING: ast

	// copy constructors and assignment
	std::map<const char *, const char *> m7(m2);
	std::map<const char *, const char *> m8 = m2;
	std::map<const char *, const char *> m9;
	m9 = m2;
	sink(m7); // $ ir MISSING: ast
	sink(m8); // $ ir MISSING: ast
	sink(m9); // $ ir MISSING: ast
	sink(m7.find("abc")); // $ ir MISSING: ast
	sink(m8.find("abc")); // $ ir MISSING: ast
	sink(m9.find("abc")); // $ ir MISSING: ast

	// iterators
	std::map<const char *, const char *>::iterator i1, i2, i3;
	for (i1 = m1.begin(); i1 != m1.end(); i1++)
	{
		sink(*i1);
		sink(i1->first);
		sink(i1->second);
	}
	for (i2 = m2.begin(); i2 != m2.end(); i2++)
	{
		sink(*i2); // $ ir MISSING: ast
		sink(i2->first); // clean
		sink(i2->second); // $ MISSING: ast,ir
	}
	for (i3 = m3.begin(); i3 != m3.end(); i3++)
	{
		sink(*i3); // $ ir MISSING: ast
		sink(i3->first);  // $ MISSING: ast,ir
		sink(i3->second); // clean
	}

	// array-like access
	std::map<const char *, const char *> m10, m11, m12, m13;
	sink(m10["abc"] = "def");
	sink(m11["abc"] = source()); // $ ast,ir
	sink(m12.at("abc") = "def");
	sink(m13.at("abc") = source()); // $ ast,ir
	sink(m10["abc"]);
	sink(m11["abc"]); // $ ir MISSING: ast
	sink(m12["abc"]);
	sink(m13["abc"]); // $ ir MISSING: ast

	// ranges
	std::map<const char *, const char *> m14;
	m14.insert(std::make_pair("a", "a"));
	m14.insert(std::make_pair("b", source()));
	m14.insert(std::make_pair("c", source()));
	m14.insert(std::make_pair("d", "d"));
	sink(m14.lower_bound("b")); // $ ir=179:33 ir=180:33 MISSING: ast=179:33 ast=180:33
	sink(m14.upper_bound("b")); // $ ir=179:33 ir=180:33 MISSING: ast=179:33 ast=180:33
	sink(m14.equal_range("b").first); // $ ir=179:33 ir=180:33 MISSING: ast=179:33 ast=180:33
	sink(m14.equal_range("b").second); // $ ir=179:33 ir=180:33 MISSING: ast=179:33 ast=180:33
	sink(m14.upper_bound("c")); // $ ir=179:33 ir=180:33 MISSING: ast=179:33 ast=180:33
	sink(m14.equal_range("c").second); // $ ir=179:33 ir=180:33 MISSING: ast=179:33 ast=180:33

	// swap
	std::map<const char *, const char *> m15, m16, m17, m18;
	m15.insert(std::pair<const char *, const char *>(source(), source()));
	m18.insert(std::pair<const char *, const char *>(source(), source()));
	sink(m15); // $ ir MISSING: ast
	sink(m16);
	sink(m17);
	sink(m18); // $ ir MISSING: ast
	m15.swap(m16);
	m17.swap(m18);
	sink(m15);
	sink(m16); // $ ir
	sink(m17); // $ ir
	sink(m18);

	// merge
	std::map<const char *, const char *> m19, m20, m21, m22;
	m19.insert(std::pair<const char *, const char *>(source(), source()));
	m20.insert(std::pair<const char *, const char *>("abc", "def"));
	m21.insert(std::pair<const char *, const char *>("abc", "def"));
	m22.insert(std::pair<const char *, const char *>(source(), source()));
	sink(m19); // $ ir MISSING: ast
	sink(m20);
	sink(m21);
	sink(m22); // $ ir MISSING: ast
	m19.merge(m20);
	m21.merge(m22);
	sink(m19); // $ ir MISSING: ast
	sink(m20);
	sink(m21); // $ ir MISSING: ast
	sink(m22); // $ ir MISSING: ast

	// erase, clear
	std::map<const char *, const char *> m23; std::map<const char *, const char *>::value_type(source(), source()); // ensure instantiation
	m23.insert(std::pair<const char *, const char *>(source(), source()));
	m23.insert(std::pair<const char *, const char *>(source(), source()));
	sink(m23); // $ ir=223:61 ir=224:61 MISSING: ast=223:61 ast=224:61
	sink(m23.erase(m23.begin())); // $ ir=223:61 ir=224:61 MISSING: ast=223:61 ast=224:61
	sink(m23); // $ ir=223:61 ir=224:61 MISSING: ast=223:61 ast=224:61
	m23.clear();
	sink(m23); // $ SPURIOUS: ir=223:61 ir=224:61

	// emplace, emplace_hint
	std::map<const char *, const char *> m24, m25; std::map<const char *, const char *>::value_type("abc", source()); // force the template instantiation
	sink(m24.emplace("abc", "def").first);
	sink(m24);
	sink(m24.emplace("abc", source()).first); // $ ir MISSING: ast
	sink(m24); // $ ir MISSING: ast
	sink(m25.emplace_hint(m25.begin(), "abc", "def"));
	sink(m25);
	sink(m25.emplace_hint(m25.begin(), "abc", source())); // $ ir MISSING: ast
	sink(m25); // $ ir MISSING: ast
	
	// try_emplace
	std::map<const char *, const char *> m26, m27;
	sink(m26.try_emplace("abc", "def").first);
	sink(m26);
	sink(m26.try_emplace("abc", source()).first); // $ ir MISSING: ast
	sink(m26); // $ ir MISSING: ast
	sink(m27.try_emplace(m27.begin(), "abc", "def"));
	sink(m27);
	sink(m27.try_emplace(m27.begin(), "abc", source())); // $ ir MISSING: ast
	sink(m27); // $ ir MISSING: ast
}

void test_unordered_map()
{
	// insert
	std::unordered_map<const char *, const char *> m1, m2, m3, m4, m5, m6;

	sink(m1.insert(std::make_pair("abc", "def")).first);
	sink(m2.insert(std::make_pair("abc", source())).first); // $ ir MISSING: ast
	sink(m3.insert(std::make_pair(source(), "def")).first); // $ MISSING: ast,ir
	sink(m4.insert(m4.begin(), std::pair<const char *, const char *>("abc", source()))); // $ ir MISSING: ast
	sink(m5.insert_or_assign("abc", source()).first); // $ ir MISSING: ast
	sink(m6.insert_or_assign(m6.begin(), "abc", source())); // $ ir MISSING: ast
	sink(m1);
	sink(m2); // $ ir MISSING: ast
	sink(m3); // $ MISSING: ast,ir
	sink(m4); // $ ir MISSING: ast
	sink(m5); // $ ir MISSING: ast
	sink(m6); // $ ir MISSING: ast
	sink(m1.find("abc"));
	sink(m2.find("abc")); // $ ir MISSING: ast
	sink(m3.find("abc"));
	sink(m4.find("abc")); // $ ir MISSING: ast
	sink(m5.find("abc")); // $ ir MISSING: ast
	sink(m6.find("abc")); // $ ir MISSING: ast
	sink(m1.find("def"));
	sink(m2.find("def")); // $ SPURIOUS: ir
	sink(m3.find("def"));
	sink(m4.find("def")); // $ SPURIOUS: ir
	sink(m5.find("def")); // $ SPURIOUS: ir
	sink(m6.find("def")); // $ SPURIOUS: ir

	// copy constructors and assignment
	std::unordered_map<const char *, const char *> m7(m2);
	std::unordered_map<const char *, const char *> m8 = m2;
	std::unordered_map<const char *, const char *> m9;
	m9 = m2;
	sink(m7); // $ ir MISSING: ast
	sink(m8); // $ ir MISSING: ast
	sink(m9); // $ ir MISSING: ast
	sink(m7.find("abc")); // $ ir MISSING: ast
	sink(m8.find("abc")); // $ ir MISSING: ast
	sink(m9.find("abc")); // $ ir MISSING: ast

	// iterators
	std::unordered_map<const char *, const char *>::iterator i1, i2, i3;
	for (i1 = m1.begin(); i1 != m1.end(); i1++)
	{
		sink(*i1);
		sink(i1->first);
		sink(i1->second);
	}
	for (i2 = m2.begin(); i2 != m2.end(); i2++)
	{
		sink(*i2); // $ ir MISSING: ast
		sink(i2->first); // clean
		sink(i2->second); // $ MISSING: ast,ir
	}
	for (i3 = m3.begin(); i3 != m3.end(); i3++)
	{
		sink(*i3); // $ ir MISSING: ast
		sink(i3->first); // $ MISSING: ast,ir
		sink(i3->second); // clean
	}

	// array-like access
	std::unordered_map<const char *, const char *> m10, m11, m12, m13;
	sink(m10["abc"] = "def");
	sink(m11["abc"] = source()); // $ ast,ir
	sink(m12.at("abc") = "def");
	sink(m13.at("abc") = source()); // $ ast,ir
	sink(m10["abc"]);
	sink(m11["abc"]); // $ ir MISSING: ast
	sink(m12["abc"]);
	sink(m13["abc"]); // $ ir MISSING: ast

	// ranges
	std::unordered_map<const char *, const char *> m14;
	m14.insert(std::make_pair("a", "a"));
	m14.insert(std::make_pair("b", source()));
	m14.insert(std::make_pair("c", source()));
	m14.insert(std::make_pair("d", "d"));
	sink(m14.equal_range("b").first); // $ ir=331:33 ir=332:33
	sink(m14.equal_range("b").second); // $ ir=331:33 ir=332:33 MISSING: ast
	sink(m14.equal_range("c").second); // $ SPURIOUS: ir=331:33 ir=332:33

	// swap
	std::unordered_map<const char *, const char *> m15, m16, m17, m18;
	m15.insert(std::pair<const char *, const char *>(source(), source()));
	m18.insert(std::pair<const char *, const char *>(source(), source()));
	sink(m15); // $ ir MISSING: ast
	sink(m16);
	sink(m17);
	sink(m18); // $ ir MISSING: ast
	m15.swap(m16);
	m17.swap(m18);
	sink(m15);
	sink(m16); // $ ir
	sink(m17); // $ ir
	sink(m18);

	// merge
	std::unordered_map<const char *, const char *> m19, m20, m21, m22;
	m19.insert(std::pair<const char *, const char *>(source(), source()));
	m20.insert(std::pair<const char *, const char *>("abc", "def"));
	m21.insert(std::pair<const char *, const char *>("abc", "def"));
	m22.insert(std::pair<const char *, const char *>(source(), source()));
	sink(m19); // $ ir MISSING: ast
	sink(m20);
	sink(m21);
	sink(m22); // $ ir MISSING: ast
	m19.merge(m20);
	m21.merge(m22);
	sink(m19); // $ ir MISSING: ast
	sink(m20);
	sink(m21); // $ ir MISSING: ast
	sink(m22); // $ ir MISSING: ast

	// erase, clear
	std::unordered_map<const char *, const char *> m23;
	m23.insert(std::pair<const char *, const char *>(source(), source()));
	m23.insert(std::pair<const char *, const char *>(source(), source()));
	sink(m23); // $ ir=372:61 ir=373:61 MISSING: ast=372:61 ast=373:61
	sink(m23.erase(m23.begin())); // $ ir=372:61 ir=373:61 MISSING: ast=372:61 ast=373:61
	sink(m23); // $ ir=372:61 ir=373:61 MISSING: ast=372:61 ast=373:61
	m23.clear();
	sink(m23); // $ SPURIOUS: ir=372:61 ir=373:61

	// emplace, emplace_hint
	std::unordered_map<const char *, const char *> m24, m25;
	sink(m24.emplace("abc", "def").first);
	sink(m24);
	sink(m24.emplace("abc", source()).first); // $ ir
	sink(m24); // $ ir MISSING: ast
	sink(m25.emplace_hint(m25.begin(), "abc", "def"));
	sink(m25);
	sink(m25.emplace_hint(m25.begin(), "abc", source())); // $ ir MISSING: ast
	sink(m25); // $ ir MISSING: ast

	// try_emplace
	std::unordered_map<const char *, const char *> m26, m27, m28;
	sink(m26.try_emplace("abc", "def").first);
	sink(m26.try_emplace("abc", "def").second);
	sink(m26);
	sink(m26.try_emplace("abc", source()).first); // $ ir
	sink(m26.try_emplace("abc", source()).second); // $ MISSING: ast,ir=396:30
	sink(m26); // $ ir=396:30 MISSING: ast SPURIOUS: ir=397:30
	sink(m27.try_emplace(m27.begin(), "abc", "def"));
	sink(m27);
	sink(m27.try_emplace(m27.begin(), "abc", source())); // $ ir MISSING: ast
	sink(m27); // $ ir MISSING: ast
	sink(m28.try_emplace(m28.begin(), "abc", "def"));
	sink(m28);
	sink(m28.try_emplace(m28.begin(), source(), "def")); // $ MISSING: ast,ir
	sink(m28); // $ MISSING: ast,ir

	// additional try_emplace test cases
	std::unordered_map<const char *, std::pair<int, int>> m29, m30, m31, m32; std::pair<int, int> inst1(0, 0); int x; std::pair<int, int> inst2(x, x);
	sink(m29.try_emplace("abc", 1, 2));
	sink(m29);
	sink(m29["abc"]);
	sink(m30.try_emplace(source(), 1, 2)); // $ ir MISSING: ast
	sink(m30); // $ MISSING: ast,ir
	sink(m30["abc"]);
	sink(m31.try_emplace("abc", source(0), 2).first->second.first); // $ ir MISSING: ast
	sink(m31);
	sink(m31["abc"]); // $ ir MISSING: ast
	sink(m32.try_emplace("abc", 1, source(0)).first->second.second); // $ ir MISSING: ast
	sink(m32); // $ ir MISSING: ast
	sink(m32["abc"]); // $ ir MISSING: ast

	// additional emplace test cases
	std::unordered_map<const char *, const char *> m33;
	sink(m33.emplace(source(), "def").first); // $ MISSING: ast,ir
	sink(m33); // $ MISSING: ast,ir

	std::unordered_map<const char *, const char *> m34, m35;
	sink(m34.emplace(std::pair<const char *, const char *>("abc", "def")).first);
	sink(m34);
	sink(m34.emplace(std::pair<const char *, const char *>("abc", source())).first); // $ ir
	sink(m34); // $ ir
	sink(m34.emplace_hint(m34.begin(), "abc", "def")); // $ ir
	sink(m35.emplace().first);
	sink(m35);
	sink(m35.emplace(std::pair<const char *, const char *>(source(), "def")).first); // $ MISSING: ast,ir
	sink(m35); // $ MISSING: ast,ir
}

namespace {
	int* indirect_source();
	void indirect_sink(int*);
}

void test_indirect_taint() {
  std::map<int, int*> m;
  int* p = indirect_source();
  m[1] = p;
  int* q = m[1];
  sink(q); // $ ir MISSING: ast
}