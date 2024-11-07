
#include "stl.h"

using namespace std;
namespace {
char *source();
}
void sink(char *);
void sink(const char *);
void sink(bool);
void sink(std::pair<char *, char *>);
void sink(std::map<char *, char *>);
void sink(std::map<char *, char *>::iterator);
void sink(std::unordered_map<char *, char *>);
void sink(std::unordered_map<char *, char *>::iterator);
void sink(std::unordered_map<char *, std::pair<int, int> >);
void sink(std::unordered_map<char *, std::pair<int, int> >::iterator);

void test_pair()
{
	std::pair<char *, char *> a, b, c;

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

	std::pair<char *, char *> d("123", "456");
	sink(d.first);
	sink(d.second);
	sink(d);

	std::pair<char *, char *> e(source(), "456");
	sink(e.first); // $ ast,ir
	sink(e.second);
	sink(e); // $ ir MISSING: ast

	std::pair<char *, char *> f("123", source());
	sink(f.first);
	sink(f.second); // $ ast,ir
	sink(f); // $ ast,ir

	std::pair<char *, char *> g(f);
	sink(g.first);
	sink(g.second); // $ ast,ir
	sink(g); // $ ast,ir

	std::pair<char *, char *> h;
	h = f;
	sink(h.first);
	sink(h.second); // $ ast,ir
	sink(h); // $ ast,ir

	std::pair<char *, char *> i("123", "456");
	std::pair<char *, char *> j("123", source());
	std::pair<char *, char *> k("123", source());
	std::pair<char *, char *> l("123", "456");
 	i.swap(j);
	k.swap(l);
	sink(i.first);
	sink(i.second); // $ ir, MISSING: ast
	sink(i); // $ ir
	sink(j.first);
	sink(j.second); // $ SPURIOUS: ast
	sink(j); // $ SPURIOUS: ast
	sink(k.first);
	sink(k.second); // $ SPURIOUS: ast
	sink(k); // $ SPURIOUS: ast
	sink(l.first);
	sink(l.second); // $ ir, MISSING: ast
	sink(l); // $ ir

	sink(make_pair("123", "456"));
	sink(make_pair("123", "456").first);
	sink(make_pair("123", "456").second);
	sink(make_pair(source(), "456")); // $ MISSING: ast,ir
	sink(make_pair(source(), "456").first); // $ ast,ir
	sink(make_pair(source(), "456").second);
	sink(make_pair("123", source())); // $ ast,ir
	sink(make_pair("123", source()).first);
	sink(make_pair("123", source()).second); // $ ast,ir

	std::pair<std::pair<char *, char *>, char *> m;
	m = make_pair(make_pair("123", source()), "789");
	sink(m); // $ MISSING: ast,ir
	sink(m.first); // $ MISSING: ast,ir
	sink(m.first.first);
	sink(m.first.second); // $ MISSING: ast,ir
	sink(m.second);
}

void test_map()
{
	// insert
	std::map<char *, char *> m1, m2, m3, m4, m5, m6;

	sink(m1.insert(std::make_pair("abc", "def")).first);
	sink(m2.insert(std::make_pair("abc", source())).first);
	sink(m3.insert(std::make_pair(source(), "def")).first); // $ MISSING: ast,ir
	sink(m4.insert(m4.begin(), std::pair<char *, char *>("abc", source()))); // $ ast,ir
	sink(m5.insert_or_assign("abc", source()).first);
	sink(m6.insert_or_assign(m6.begin(), "abc", source())); // $ ast,ir
	sink(m1);
	sink(m2); // $ ast,ir
	sink(m3); // $ MISSING: ast,ir
	sink(m4); // $ ast,ir
	sink(m5); // $ ast,ir
	sink(m6); // $ ast,ir
	sink(m1.find("abc"));
	sink(m2.find("abc")); // $ ast,ir
	sink(m3.find("abc"));
	sink(m4.find("abc")); // $ ast,ir
	sink(m5.find("abc")); // $ ast,ir
	sink(m6.find("abc")); // $ ast,ir
	sink(m1.find("def"));
	sink(m2.find("def")); // $ SPURIOUS: ast,ir
	sink(m3.find("def"));
	sink(m4.find("def")); // $ SPURIOUS: ast,ir
	sink(m5.find("def")); // $ SPURIOUS: ast,ir
	sink(m6.find("def")); // $ SPURIOUS: ast,ir

	// copy constructors and assignment
	std::map<char *, char *> m7(m2);
	std::map<char *, char *> m8 = m2;
	std::map<char *, char *> m9;
	m9 = m2;
	sink(m7); // $ ast,ir
	sink(m8); // $ ast,ir
	sink(m9); // $ ast,ir
	sink(m7.find("abc")); // $ ast,ir
	sink(m8.find("abc")); // $ ast,ir
	sink(m9.find("abc")); // $ ast,ir

	// iterators
	std::map<char *, char *>::iterator i1, i2, i3;
	for (i1 = m1.begin(); i1 != m1.end(); i1++)
	{
		sink(*i1);
		sink(i1->first);
		sink(i1->second);
	}
	for (i2 = m2.begin(); i2 != m2.end(); i2++)
	{
		sink(*i2); // $ ast,ir
		sink(i2->first); // clean
		sink(i2->second); // $ MISSING: ast,ir
	}
	for (i3 = m3.begin(); i3 != m3.end(); i3++)
	{
		sink(*i3); // $ MISSING: ast,ir
		sink(i3->first);  // $ MISSING: ast,ir
		sink(i3->second); // clean
	}

	// array-like access
	std::map<char *, char *> m10, m11, m12, m13;
	sink(m10["abc"] = "def");
	sink(m11["abc"] = source()); // $ ast,ir
	sink(m12.at("abc") = "def");
	sink(m13.at("abc") = source()); // $ ast,ir
	sink(m10["abc"]);
	sink(m11["abc"]); // $ ast,ir
	sink(m12["abc"]);
	sink(m13["abc"]); // $ ast,ir

	// ranges
	std::map<char *, char *> m14;
	m14.insert(std::make_pair("a", "a"));
	m14.insert(std::make_pair("b", source()));
	m14.insert(std::make_pair("c", source()));
	m14.insert(std::make_pair("d", "d"));
	sink(m14.lower_bound("b")); // $ ast,ir=179:33 ast,ir=180:33
	sink(m14.upper_bound("b")); // $ ast,ir=179:33 ast,ir=180:33
	sink(m14.equal_range("b").first); // $ MISSING: ast,ir
	sink(m14.equal_range("b").second); // $ MISSING: ast,ir
	sink(m14.upper_bound("c")); // $ SPURIOUS: ast,ir=179:33 ast,ir=180:33
	sink(m14.equal_range("c").second);

	// swap
	std::map<char *, char *> m15, m16, m17, m18;
	m15.insert(std::pair<char *, char *>(source(), source()));
	m18.insert(std::pair<char *, char *>(source(), source()));
	sink(m15); // $ ast,ir
	sink(m16);
	sink(m17);
	sink(m18); // $ ast,ir
	m15.swap(m16);
	m17.swap(m18);
	sink(m15); // $ SPURIOUS: ast
	sink(m16); // $ ir
	sink(m17); // $ ir
	sink(m18); // $ SPURIOUS: ast

	// merge
	std::map<char *, char *> m19, m20, m21, m22;
	m19.insert(std::pair<char *, char *>(source(), source()));
	m20.insert(std::pair<char *, char *>("abc", "def"));
	m21.insert(std::pair<char *, char *>("abc", "def"));
	m22.insert(std::pair<char *, char *>(source(), source()));
	sink(m19); // $ ast,ir
	sink(m20);
	sink(m21);
	sink(m22); // $ ast,ir
	m19.merge(m20);
	m21.merge(m22);
	sink(m19); // $ ast,ir
	sink(m20);
	sink(m21); // $ ast,ir
	sink(m22); // $ ast,ir

	// erase, clear
	std::map<char *, char *> m23;
	m23.insert(std::pair<char *, char *>(source(), source()));
	m23.insert(std::pair<char *, char *>(source(), source()));
	sink(m23); // $ ast,ir=223:49 ast,ir=224:49
	sink(m23.erase(m23.begin())); // $ ast,ir=223:49 ast,ir=224:49
	sink(m23); // $ ast,ir=223:49 ast,ir=224:49
	m23.clear();
	sink(m23); // $ SPURIOUS: ast,ir=223:49 ast,ir=224:49

	// emplace, emplace_hint
	std::map<char *, char *> m24, m25;
	sink(m24.emplace("abc", "def").first);
	sink(m24);
	sink(m24.emplace("abc", source()).first);
	sink(m24); // $ ast,ir
	sink(m25.emplace_hint(m25.begin(), "abc", "def"));
	sink(m25);
	sink(m25.emplace_hint(m25.begin(), "abc", source())); // $ ast,ir
	sink(m25); // $ ast,ir
	
	// try_emplace
	std::map<char *, char *> m26, m27;
	sink(m26.try_emplace("abc", "def").first);
	sink(m26);
	sink(m26.try_emplace("abc", source()).first);
	sink(m26); // $ ast,ir
	sink(m27.try_emplace(m27.begin(), "abc", "def"));
	sink(m27);
	sink(m27.try_emplace(m27.begin(), "abc", source())); // $ ast,ir
	sink(m27); // $ ast,ir
}

void test_unordered_map()
{
	// insert
	std::unordered_map<char *, char *> m1, m2, m3, m4, m5, m6;

	sink(m1.insert(std::make_pair("abc", "def")).first);
	sink(m2.insert(std::make_pair("abc", source())).first);
	sink(m3.insert(std::make_pair(source(), "def")).first); // $ MISSING: ast,ir
	sink(m4.insert(m4.begin(), std::pair<char *, char *>("abc", source()))); // $ ast,ir
	sink(m5.insert_or_assign("abc", source()).first);
	sink(m6.insert_or_assign(m6.begin(), "abc", source())); // $ ast,ir
	sink(m1);
	sink(m2); // $ ast,ir
	sink(m3); // $ MISSING: ast,ir
	sink(m4); // $ ast,ir
	sink(m5); // $ ast,ir
	sink(m6); // $ ast,ir
	sink(m1.find("abc"));
	sink(m2.find("abc")); // $ ast,ir
	sink(m3.find("abc"));
	sink(m4.find("abc")); // $ ast,ir
	sink(m5.find("abc")); // $ ast,ir
	sink(m6.find("abc")); // $ ast,ir
	sink(m1.find("def"));
	sink(m2.find("def")); // $ SPURIOUS: ast,ir
	sink(m3.find("def"));
	sink(m4.find("def")); // $ SPURIOUS: ast,ir
	sink(m5.find("def")); // $ SPURIOUS: ast,ir
	sink(m6.find("def")); // $ SPURIOUS: ast,ir

	// copy constructors and assignment
	std::unordered_map<char *, char *> m7(m2);
	std::unordered_map<char *, char *> m8 = m2;
	std::unordered_map<char *, char *> m9;
	m9 = m2;
	sink(m7); // $ ast,ir
	sink(m8); // $ ast,ir
	sink(m9); // $ ast,ir
	sink(m7.find("abc")); // $ ast,ir
	sink(m8.find("abc")); // $ ast,ir
	sink(m9.find("abc")); // $ ast,ir

	// iterators
	std::unordered_map<char *, char *>::iterator i1, i2, i3;
	for (i1 = m1.begin(); i1 != m1.end(); i1++)
	{
		sink(*i1);
		sink(i1->first);
		sink(i1->second);
	}
	for (i2 = m2.begin(); i2 != m2.end(); i2++)
	{
		sink(*i2); // $ ast,ir
		sink(i2->first); // clean
		sink(i2->second); // $ MISSING: ast,ir
	}
	for (i3 = m3.begin(); i3 != m3.end(); i3++)
	{
		sink(*i3); // $ MISSING: ast,ir
		sink(i3->first); // $ MISSING: ast,ir
		sink(i3->second); // clean
	}

	// array-like access
	std::unordered_map<char *, char *> m10, m11, m12, m13;
	sink(m10["abc"] = "def");
	sink(m11["abc"] = source()); // $ ast,ir
	sink(m12.at("abc") = "def");
	sink(m13.at("abc") = source()); // $ ast,ir
	sink(m10["abc"]);
	sink(m11["abc"]); // $ ast,ir
	sink(m12["abc"]);
	sink(m13["abc"]); // $ ast,ir

	// ranges
	std::unordered_map<char *, char *> m14;
	m14.insert(std::make_pair("a", "a"));
	m14.insert(std::make_pair("b", source()));
	m14.insert(std::make_pair("c", source()));
	m14.insert(std::make_pair("d", "d"));
	sink(m14.equal_range("b").first);
	sink(m14.equal_range("b").second); // $ MISSING: ast,ir
	sink(m14.equal_range("c").second);

	// swap
	std::unordered_map<char *, char *> m15, m16, m17, m18;
	m15.insert(std::pair<char *, char *>(source(), source()));
	m18.insert(std::pair<char *, char *>(source(), source()));
	sink(m15); // $ ast,ir
	sink(m16);
	sink(m17);
	sink(m18); // $ ast,ir
	m15.swap(m16);
	m17.swap(m18);
	sink(m15); // $ SPURIOUS: ast
	sink(m16); // $ ir
	sink(m17); // $ ir
	sink(m18); // $ SPURIOUS: ast

	// merge
	std::unordered_map<char *, char *> m19, m20, m21, m22;
	m19.insert(std::pair<char *, char *>(source(), source()));
	m20.insert(std::pair<char *, char *>("abc", "def"));
	m21.insert(std::pair<char *, char *>("abc", "def"));
	m22.insert(std::pair<char *, char *>(source(), source()));
	sink(m19); // $ ast,ir
	sink(m20);
	sink(m21);
	sink(m22); // $ ast,ir
	m19.merge(m20);
	m21.merge(m22);
	sink(m19); // $ ast,ir
	sink(m20);
	sink(m21); // $ ast,ir
	sink(m22); // $ ast,ir

	// erase, clear
	std::unordered_map<char *, char *> m23;
	m23.insert(std::pair<char *, char *>(source(), source()));
	m23.insert(std::pair<char *, char *>(source(), source()));
	sink(m23); // $ ast,ir=372:49 ast,ir=373:49
	sink(m23.erase(m23.begin())); // $ ast,ir=372:49 ast,ir=373:49
	sink(m23); // $ ast,ir=372:49 ast,ir=373:49
	m23.clear();
	sink(m23); // $ SPURIOUS: ast,ir=372:49 ast,ir=373:49

	// emplace, emplace_hint
	std::unordered_map<char *, char *> m24, m25;
	sink(m24.emplace("abc", "def").first);
	sink(m24);
	sink(m24.emplace("abc", source()).first);
	sink(m24); // $ ast,ir
	sink(m25.emplace_hint(m25.begin(), "abc", "def"));
	sink(m25);
	sink(m25.emplace_hint(m25.begin(), "abc", source())); // $ ast,ir
	sink(m25); // $ ast,ir

	// try_emplace
	std::unordered_map<char *, char *> m26, m27, m28;
	sink(m26.try_emplace("abc", "def").first);
	sink(m26.try_emplace("abc", "def").second);
	sink(m26);
	sink(m26.try_emplace("abc", source()).first);
	sink(m26.try_emplace("abc", source()).second); // $ MISSING: ast,ir=396:30
	sink(m26); // $ ast,ir=396:30 SPURIOUS: ast,ir=397:30
	sink(m27.try_emplace(m27.begin(), "abc", "def"));
	sink(m27);
	sink(m27.try_emplace(m27.begin(), "abc", source())); // $ ast,ir
	sink(m27); // $ ast,ir
	sink(m28.try_emplace(m28.begin(), "abc", "def"));
	sink(m28);
	sink(m28.try_emplace(m28.begin(), source(), "def")); // $ MISSING: ast,ir
	sink(m28); // $ MISSING: ast,ir

	// additional try_emplace test cases
	std::unordered_map<char *, std::pair<int, int>> m29, m30, m31, m32;
	sink(m29.try_emplace("abc", 1, 2));
	sink(m29);
	sink(m29["abc"]);
	sink(m30.try_emplace(source(), 1, 2)); // $ MISSING: ast,ir
	sink(m30); // $ MISSING: ast,ir
	sink(m30["abc"]);
	sink(m31.try_emplace("abc", source(), 2)); // $ ast,ir
	sink(m31); // $ ast,ir
	sink(m31["abc"]); // $ ast,ir
	sink(m32.try_emplace("abc", 1, source())); // $ ast,ir
	sink(m32); // $ ast,ir
	sink(m32["abc"]); // $ ast,ir

	// additional emplace test cases
	std::unordered_map<char *, char *> m33;
	sink(m33.emplace(source(), "def").first); // $ MISSING: ast,ir
	sink(m33); // $ MISSING: ast,ir

	std::unordered_map<char *, char *> m34, m35;
	sink(m34.emplace(std::pair<char *, char *>("abc", "def")).first);
	sink(m34);
	sink(m34.emplace(std::pair<char *, char *>("abc", source())).first);
	sink(m34); // $ ast,ir
	sink(m34.emplace_hint(m34.begin(), "abc", "def")); // $ ast,ir
	sink(m35.emplace().first);
	sink(m35);
	sink(m35.emplace(std::pair<char *, char *>(source(), "def")).first); // $ MISSING: ast,ir
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