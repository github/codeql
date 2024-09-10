
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
	sink(s2.insert(source()).first); // $ MISSING: ast,ir
	sink(s3.insert(s3.begin(), "abc"));
	sink(s4.insert(s4.begin(), source())); // $ ast,ir
	s5.insert(s1.begin(), s1.end());
	s6.insert(s2.begin(), s2.end());
	sink(s1);
	sink(s2); // $ ast,ir
	sink(s3);
	sink(s4); // $ ast,ir
	sink(s5);
	sink(s6); // $ ast,ir
	sink(s1.find("abc"));
	sink(s2.find("abc")); // $ ast,ir
	sink(s3.find("abc"));
	sink(s4.find("abc")); // $ ast,ir
	sink(s5.find("abc"));
	sink(s6.find("abc")); // $ ast,ir

	// copy constructors and assignment
	std::set<char *> s7(s2);
	std::set<char *> s8 = s2;
	std::set<char *> s9(s2.begin(), s2.end());
	std::set<char *> s10;
	s10 = s2;
	sink(s7); // $ ast,ir
	sink(s8); // $ ast,ir
	sink(s9); // $ ast,ir
	sink(s10); // $ ast,ir
	sink(s7.find("abc")); // $ ast,ir
	sink(s8.find("abc")); // $ ast,ir
	sink(s9.find("abc")); // $ ast,ir
	sink(s10.find("abc")); // $ ast,ir

	// iterators
	std::set<char *>::iterator i1, i2;
	for (i1 = s1.begin(); i1 != s1.end(); i1++)
	{
		sink(*i1);
	}
	for (i2 = s2.begin(); i2 != s2.end(); i2++)
	{
		sink(*i2); // $ ast,ir
	}

	// ranges
	std::set<char *> s11;
	s11.insert("a");
	s11.insert(source());
	s11.insert("c");
	sink(s11.lower_bound("b")); // $ ast,ir
	sink(s11.upper_bound("b")); // $ ast,ir
	sink(s11.equal_range("b").first); // $ MISSING: ast,ir
	sink(s11.equal_range("b").second); // $ MISSING: ast,ir

	// swap
	std::set<char *> s12, s13, s14, s15;
	s12.insert(source());
	s15.insert(source());
	sink(s12); // $ ast,ir
	sink(s13);
	sink(s14);
	sink(s15); // $ ast,ir
	s12.swap(s13);
	s14.swap(s15);
	sink(s12); // $ SPURIOUS: ast
	sink(s13); // $ ir
	sink(s14); // $ ir
	sink(s15); // $ SPURIOUS: ast

	// merge
	std::set<char *> s16, s17, s18, s19;
	s16.insert(source());
	s17.insert("abc");
	s18.insert("def");
	s19.insert(source());
	sink(s16); // $ ast,ir
	sink(s17);
	sink(s18);
	sink(s19); // $ ast,ir
	s16.merge(s17);
	s18.merge(s19);
	sink(s16); // $ ast,ir
	sink(s17);
	sink(s18); // $ ast,ir
	sink(s19); // $ ast,ir

	// erase, clear
	std::set<char *> s20;
	s20.insert(source());
	s20.insert(source());
	sink(s20); // $ ast,ir=108:13 ast,ir=109:13
	sink(s20.erase(s20.begin())); // $ ast,ir=108:13 ast,ir=109:13
	sink(s20); // $ ast,ir=108:13 ast,ir=109:13
	s20.clear();
	sink(s20); // $ SPURIOUS: ast,ir=108:13 ast,ir=109:13

	// emplace, emplace_hint
	std::set<char *> s21, s22;
	sink(s21.emplace("abc").first);
	sink(s21);
	sink(s21.emplace(source()).first); // $ MISSING: ast,ir
	sink(s21); // $ ast,ir
	sink(s22.emplace_hint(s22.begin(), "abc"));
	sink(s22);
	sink(s22.emplace_hint(s22.begin(), source())); // $ ast,ir
	sink(s22); // $ ast,ir
}

void test_unordered_set()
{
	// insert, find
	std::unordered_set<char *> s1, s2, s3, s4, s5, s6;

	sink(s1.insert("abc").first);
	sink(s2.insert(source()).first); // $ MISSING: ast,ir
	sink(s3.insert(s3.begin(), "abc"));
	sink(s4.insert(s4.begin(), source())); // $ ast,ir
	s5.insert(s1.begin(), s1.end());
	s6.insert(s2.begin(), s2.end());
	sink(s1);
	sink(s2); // $ ast,ir
	sink(s3);
	sink(s4); // $ ast,ir
	sink(s5);
	sink(s6); // $ ast,ir
	sink(s1.find("abc"));
	sink(s2.find("abc")); // $ ast,ir
	sink(s3.find("abc"));
	sink(s4.find("abc")); // $ ast,ir
	sink(s5.find("abc"));
	sink(s6.find("abc")); // $ ast,ir

	// copy constructors and assignment
	std::unordered_set<char *> s7(s2);
	std::unordered_set<char *> s8 = s2;
	std::unordered_set<char *> s9(s2.begin(), s2.end());
	std::unordered_set<char *> s10;
	s10 = s2;
	sink(s7); // $ ast,ir
	sink(s8); // $ ast,ir
	sink(s9); // $ ast,ir
	sink(s10); // $ ast,ir
	sink(s7.find("abc")); // $ ast,ir
	sink(s8.find("abc")); // $ ast,ir
	sink(s9.find("abc")); // $ ast,ir
	sink(s10.find("abc")); // $ ast,ir

	// iterators
	std::unordered_set<char *>::iterator i1, i2;
	for (i1 = s1.begin(); i1 != s1.end(); i1++)
	{
		sink(*i1);
	}
	for (i2 = s2.begin(); i2 != s2.end(); i2++)
	{
		sink(*i2); // $ ast,ir
	}

	// ranges
	std::unordered_set<char *> s11;
	s11.insert("a");
	s11.insert(source());
	s11.insert("c");
	sink(s11.equal_range("b").first); // $ MISSING: ast,ir
	sink(s11.equal_range("b").second); // $ MISSING: ast,ir

	// swap
	std::unordered_set<char *> s12, s13, s14, s15;
	s12.insert(source());
	s15.insert(source());
	sink(s12); // $ ast,ir
	sink(s13);
	sink(s14);
	sink(s15); // $ ast,ir
	s12.swap(s13);
	s14.swap(s15);
	sink(s12); // $ SPURIOUS: ast
	sink(s13); // $ ir
	sink(s14); // $ ir
	sink(s15); // $ SPURIOUS: ast

	// merge
	std::unordered_set<char *> s16, s17, s18, s19;
	s16.insert(source());
	s17.insert("abc");
	s18.insert("def");
	s19.insert(source());
	sink(s16); // $ ast,ir
	sink(s17);
	sink(s18);
	sink(s19); // $ ast,ir
	s16.merge(s17);
	s18.merge(s19);
	sink(s16); // $ ast,ir
	sink(s17);
	sink(s18); // $ ast,ir
	sink(s19); // $ ast,ir

	// erase, clear
	std::unordered_set<char *> s20;
	s20.insert(source());
	s20.insert(source());
	sink(s20); // $ ast,ir=220:13 ast,ir=221:13
	sink(s20.erase(s20.begin())); // $ ast,ir=220:13 ast,ir=221:13
	sink(s20); // $ ast,ir=220:13 ast,ir=221:13
	s20.clear();
	sink(s20); // $ SPURIOUS: ast,ir=220:13 ast,ir=221:13

	// emplace, emplace_hint
	std::unordered_set<char *> s21, s22;
	sink(s21.emplace("abc").first);
	sink(s21);
	sink(s21.emplace(source()).first); // $ MISSING: ast,ir
	sink(s21); // $ ast,ir
	sink(s22.emplace_hint(s22.begin(), "abc"));
	sink(s22);
	sink(s22.emplace_hint(s22.begin(), source())); // $ ast,ir
	sink(s22); // $ ast,ir
}
