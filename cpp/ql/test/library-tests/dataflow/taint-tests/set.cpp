
#include "stl.h"

using namespace std;
namespace {
char *source();
}
void sink(char *);
void sink(std::set<char *>);
void sink(std::set<char *>::iterator);
void sink(std::unordered_set<char *>);
void sink(std::unordered_set<char *>::iterator);

void test_set()
{
	// insert, find
	std::set<char *> s1, s2, s3, s4, s5, s6;

	sink(s1.insert("abc").first);
	sink(s2.insert(source()).first); // $ MISSING: ir
	sink(s3.insert(s3.begin(), "abc"));
	sink(s4.insert(s4.begin(), source())); // $ ir
	s5.insert(s1.begin(), s1.end());
	s6.insert(s2.begin(), s2.end());
	sink(s1);
	sink(s2); // $ ir
	sink(s3);
	sink(s4); // $ ir
	sink(s5);
	sink(s6); // $ ir
	sink(s1.find("abc"));
	sink(s2.find("abc")); // $ ir
	sink(s3.find("abc"));
	sink(s4.find("abc")); // $ ir
	sink(s5.find("abc"));
	sink(s6.find("abc")); // $ ir

	// copy constructors and assignment
	std::set<char *> s7(s2);
	std::set<char *> s8 = s2;
	std::set<char *> s9(s2.begin(), s2.end());
	std::set<char *> s10;
	s10 = s2;
	sink(s7); // $ ir
	sink(s8); // $ ir
	sink(s9); // $ ir
	sink(s10); // $ ir
	sink(s7.find("abc")); // $ ir
	sink(s8.find("abc")); // $ ir
	sink(s9.find("abc")); // $ ir
	sink(s10.find("abc")); // $ ir

	// iterators
	std::set<char *>::iterator i1, i2;
	for (i1 = s1.begin(); i1 != s1.end(); i1++)
	{
		sink(*i1);
	}
	for (i2 = s2.begin(); i2 != s2.end(); i2++)
	{
		sink(*i2); // $ ir
	}

	// ranges
	std::set<char *> s11;
	s11.insert("a");
	s11.insert(source());
	s11.insert("c");
	sink(s11.lower_bound("b")); // $ ir
	sink(s11.upper_bound("b")); // $ ir
	sink(s11.equal_range("b").first); // $ MISSING: ir
	sink(s11.equal_range("b").second); // $ MISSING: ir

	// swap
	std::set<char *> s12, s13, s14, s15;
	s12.insert(source());
	s15.insert(source());
	sink(s12); // $ ir
	sink(s13);
	sink(s14);
	sink(s15); // $ ir
	s12.swap(s13);
	s14.swap(s15);
	sink(s12); // $ SPURIOUS: ir
	sink(s13); // $ ir
	sink(s14); // $ ir
	sink(s15); // $ SPURIOUS: ir

	// merge
	std::set<char *> s16, s17, s18, s19;
	s16.insert(source());
	s17.insert("abc");
	s18.insert("def");
	s19.insert(source());
	sink(s16); // $ ir
	sink(s17);
	sink(s18);
	sink(s19); // $ ir
	s16.merge(s17);
	s18.merge(s19);
	sink(s16); // $ ir
	sink(s17);
	sink(s18); // $ ir
	sink(s19); // $ ir

	// erase, clear
	std::set<char *> s20;
	s20.insert(source());
	s20.insert(source());
	sink(s20); // $ ir=108:13 ir=109:13
	sink(s20.erase(s20.begin())); // $ ir=108:13 ir=109:13
	sink(s20); // $ ir=108:13 ir=109:13
	s20.clear();
	sink(s20); // $ SPURIOUS: ir=108:13 ir=109:13

	// emplace, emplace_hint
	std::set<char *> s21, s22;
	sink(s21.emplace("abc").first);
	sink(s21);
	sink(s21.emplace(source()).first); // $ MISSING: ir
	sink(s21); // $ ir
	sink(s22.emplace_hint(s22.begin(), "abc"));
	sink(s22);
	sink(s22.emplace_hint(s22.begin(), source())); // $ ir
	sink(s22); // $ ir
}

void test_unordered_set()
{
	// insert, find
	std::unordered_set<char *> s1, s2, s3, s4, s5, s6;

	sink(s1.insert("abc").first);
	sink(s2.insert(source()).first); // $ MISSING: ir
	sink(s3.insert(s3.begin(), "abc"));
	sink(s4.insert(s4.begin(), source())); // $ ir
	s5.insert(s1.begin(), s1.end());
	s6.insert(s2.begin(), s2.end());
	sink(s1);
	sink(s2); // $ ir
	sink(s3);
	sink(s4); // $ ir
	sink(s5);
	sink(s6); // $ ir
	sink(s1.find("abc"));
	sink(s2.find("abc")); // $ ir
	sink(s3.find("abc"));
	sink(s4.find("abc")); // $ ir
	sink(s5.find("abc"));
	sink(s6.find("abc")); // $ ir

	// copy constructors and assignment
	std::unordered_set<char *> s7(s2);
	std::unordered_set<char *> s8 = s2;
	std::unordered_set<char *> s9(s2.begin(), s2.end());
	std::unordered_set<char *> s10;
	s10 = s2;
	sink(s7); // $ ir
	sink(s8); // $ ir
	sink(s9); // $ ir
	sink(s10); // $ ir
	sink(s7.find("abc")); // $ ir
	sink(s8.find("abc")); // $ ir
	sink(s9.find("abc")); // $ ir
	sink(s10.find("abc")); // $ ir

	// iterators
	std::unordered_set<char *>::iterator i1, i2;
	for (i1 = s1.begin(); i1 != s1.end(); i1++)
	{
		sink(*i1);
	}
	for (i2 = s2.begin(); i2 != s2.end(); i2++)
	{
		sink(*i2); // $ ir
	}

	// ranges
	std::unordered_set<char *> s11;
	s11.insert("a");
	s11.insert(source());
	s11.insert("c");
	sink(s11.equal_range("b").first); // $ MISSING: ir
	sink(s11.equal_range("b").second); // $ MISSING: ir

	// swap
	std::unordered_set<char *> s12, s13, s14, s15;
	s12.insert(source());
	s15.insert(source());
	sink(s12); // $ ir
	sink(s13);
	sink(s14);
	sink(s15); // $ ir
	s12.swap(s13);
	s14.swap(s15);
	sink(s12); // $ SPURIOUS: ir
	sink(s13); // $ ir
	sink(s14); // $ ir
	sink(s15); // $ SPURIOUS: ir

	// merge
	std::unordered_set<char *> s16, s17, s18, s19;
	s16.insert(source());
	s17.insert("abc");
	s18.insert("def");
	s19.insert(source());
	sink(s16); // $ ir
	sink(s17);
	sink(s18);
	sink(s19); // $ ir
	s16.merge(s17);
	s18.merge(s19);
	sink(s16); // $ ir
	sink(s17);
	sink(s18); // $ ir
	sink(s19); // $ ir

	// erase, clear
	std::unordered_set<char *> s20;
	s20.insert(source());
	s20.insert(source());
	sink(s20); // $ ir=220:13 ir=221:13
	sink(s20.erase(s20.begin())); // $ ir=220:13 ir=221:13
	sink(s20); // $ ir=220:13 ir=221:13
	s20.clear();
	sink(s20); // $ SPURIOUS: ir=220:13 ir=221:13

	// emplace, emplace_hint
	std::unordered_set<char *> s21, s22;
	sink(s21.emplace("abc").first);
	sink(s21);
	sink(s21.emplace(source()).first); // $ MISSING: ir
	sink(s21); // $ ir
	sink(s22.emplace_hint(s22.begin(), "abc"));
	sink(s22);
	sink(s22.emplace_hint(s22.begin(), source())); // $ ir
	sink(s22); // $ ir
}
