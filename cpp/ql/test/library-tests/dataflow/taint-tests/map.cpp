
#include "stl.h"

using namespace std;

char *source();

void sink(char *);
void sink(const char *);
void sink(std::pair<char *, char *>);

void test_pair()
{
	std::pair<char *, char *> a, b, c;

	a.first = "123";
	sink(a.first);
	sink(a.second);
	sink(a);

	b.first = source();
	sink(b.first); // tainted
	sink(b.second);
	sink(b); // tainted [NOT DETECTED]

	c.second = source();
	sink(c.first);
	sink(c.second); // tainted
	sink(c); // tainted [NOT DETECTED]

	std::pair<char *, char *> d("123", "456");
	sink(d.first);
	sink(d.second);
	sink(d);

	std::pair<char *, char *> e(source(), "456");
	sink(e.first); // tainted [NOT DETECTED]
	sink(e.second);
	sink(e); // tainted [NOT DETECTED]

	std::pair<char *, char *> f("123", source());
	sink(f.first);
	sink(f.second); // tainted [NOT DETECTED]
	sink(f); // tainted [NOT DETECTED]

	std::pair<char *, char *> g(f);
	sink(f.first);
	sink(f.second); // tainted [NOT DETECTED]
	sink(f); // tainted [NOT DETECTED]
	
	std::pair<char *, char *> h;
	h = f;
	sink(h.first);
	sink(h.second); // tainted [NOT DETECTED]
	sink(h); // tainted [NOT DETECTED]

	std::pair<char *, char *> i("123", "456");
	std::pair<char *, char *> j("123", source());
	std::pair<char *, char *> k("123", source());
	std::pair<char *, char *> l("123", "456");
 	i.swap(j);
	k.swap(l);
	sink(i.first);
	sink(i.second); // tainted [NOT DETECTED]
	sink(i); // tainted [NOT DETECTED]
	sink(j.first);
	sink(j.second);
	sink(j);
	sink(k.first);
	sink(k.second);
	sink(k);
	sink(l.first);
	sink(l.second); // tainted [NOT DETECTED]
	sink(l); // tainted [NOT DETECTED]

	sink(make_pair("123", "456"));
	sink(make_pair("123", "456").first);
	sink(make_pair("123", "456").second);
	sink(make_pair(source(), "456")); // tainted [NOT DETECTED]
	sink(make_pair(source(), "456").first); // tainted [NOT DETECTED]
	sink(make_pair(source(), "456").second);
	sink(make_pair("123", source())); // tainted [NOT DETECTED]
	sink(make_pair("123", source()).first);
	sink(make_pair("123", source()).second); // tainted [NOT DETECTED]

	std::pair<std::pair<char *, char *>, char *> m;
	m = make_pair(make_pair("123", source()), "789");
	sink(m); // tainted [NOT DETECTED]
	sink(m.first); // tainted [NOT DETECTED]
	sink(m.first.first);
	sink(m.first.second); // tainted [NOT DETECTED]
	sink(m.second);
}
