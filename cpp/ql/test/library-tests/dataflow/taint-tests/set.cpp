
#include "stl.h"

using namespace std;

char *source();

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
	sink(s2.insert(source()).first); // tainted
	sink(s3.insert(s3.begin(), "abc"));
	sink(s4.insert(s4.begin(), source())); // tainted
	s5.insert(s1.begin(), s1.end());
	s6.insert(s2.begin(), s2.end());
	sink(s1);
	sink(s2); // tainted
	sink(s3);
	sink(s4); // tainted
	sink(s5);
	sink(s6); // tainted
	sink(s1.find("abc"));
	sink(s2.find("abc")); // tainted
	sink(s3.find("abc"));
	sink(s4.find("abc")); // tainted
	sink(s5.find("abc"));
	sink(s6.find("abc")); // tainted

	// copy constructors and assignment
	std::set<char *> s7(s2);
	std::set<char *> s8 = s2;
	std::set<char *> s9(s2.begin(), s2.end());
	std::set<char *> s10;
	s10 = s2;
	sink(s7); // tainted
	sink(s8); // tainted
	sink(s9); // tainted
	sink(s10); // tainted
	sink(s7.find("abc")); // tainted
	sink(s8.find("abc")); // tainted
	sink(s9.find("abc")); // tainted
	sink(s10.find("abc")); // tainted

	// iterators
	std::set<char *>::iterator i1, i2;
	for (i1 = s1.begin(); i1 != s1.end(); i1++)
	{
		sink(*i1);
	}
	for (i2 = s2.begin(); i2 != s2.end(); i2++)
	{
		sink(*i2); // tainted
	}

	// ranges
	std::set<char *> s11;
	s11.insert("a");
	s11.insert(source());
	s11.insert("c");
	sink(s11.lower_bound("b")); // tainted
	sink(s11.upper_bound("b")); // tainted
	sink(s11.equal_range("b").first); // tainted
	sink(s11.equal_range("b").second); // tainted

	// swap
	std::set<char *> s12, s13, s14, s15;
	s12.insert(source());
	s15.insert(source());
	sink(s12); // tainted
	sink(s13);
	sink(s14);
	sink(s15); // tainted
	s12.swap(s13);
	s14.swap(s15);
	sink(s12); // [FALSE POSITIVE]
	sink(s13); // tainted
	sink(s14); // tainted
	sink(s15); // [FALSE POSITIVE]

	// merge
	std::set<char *> s16, s17, s18, s19;
	s16.insert(source());
	s17.insert("abc");
	s18.insert("def");
	s19.insert(source());
	sink(s16); // tainted
	sink(s17);
	sink(s18);
	sink(s19); // tainted
	s16.merge(s17);
	s18.merge(s19);
	sink(s16); // tainted
	sink(s17);
	sink(s18); // tainted
	sink(s19); // tainted

	// erase, clear
	std::set<char *> s20;
	s20.insert(source());
	s20.insert(source());
	sink(s20); // tainted
	sink(s20.erase(s20.begin())); // tainted
	sink(s20); // tainted
	s20.clear();
	sink(s20); // [FALSE POSITIVE]

	// emplace, emplace_hint
	std::set<char *> s21, s22;
	sink(s21.emplace("abc").first);
	sink(s21);
	sink(s21.emplace(source()).first); // tainted
	sink(s21); // tainted
	sink(s22.emplace_hint(s22.begin(), "abc"));
	sink(s22);
	sink(s22.emplace_hint(s22.begin(), source())); // tainted
	sink(s22); // tainted
}

void test_unordered_set()
{
	// insert, find
	std::unordered_set<char *> s1, s2, s3, s4, s5, s6;

	sink(s1.insert("abc").first);
	sink(s2.insert(source()).first); // tainted
	sink(s3.insert(s3.begin(), "abc"));
	sink(s4.insert(s4.begin(), source())); // tainted
	s5.insert(s1.begin(), s1.end());
	s6.insert(s2.begin(), s2.end());
	sink(s1);
	sink(s2); // tainted
	sink(s3);
	sink(s4); // tainted
	sink(s5);
	sink(s6); // tainted
	sink(s1.find("abc"));
	sink(s2.find("abc")); // tainted
	sink(s3.find("abc"));
	sink(s4.find("abc")); // tainted
	sink(s5.find("abc"));
	sink(s6.find("abc")); // tainted

	// copy constructors and assignment
	std::unordered_set<char *> s7(s2);
	std::unordered_set<char *> s8 = s2;
	std::unordered_set<char *> s9(s2.begin(), s2.end());
	std::unordered_set<char *> s10;
	s10 = s2;
	sink(s7); // tainted
	sink(s8); // tainted
	sink(s9); // tainted
	sink(s10); // tainted
	sink(s7.find("abc")); // tainted
	sink(s8.find("abc")); // tainted
	sink(s9.find("abc")); // tainted
	sink(s10.find("abc")); // tainted

	// iterators
	std::unordered_set<char *>::iterator i1, i2;
	for (i1 = s1.begin(); i1 != s1.end(); i1++)
	{
		sink(*i1);
	}
	for (i2 = s2.begin(); i2 != s2.end(); i2++)
	{
		sink(*i2); // tainted
	}

	// ranges
	std::unordered_set<char *> s11;
	s11.insert("a");
	s11.insert(source());
	s11.insert("c");
	sink(s11.equal_range("b").first); // tainted
	sink(s11.equal_range("b").second); // tainted

	// swap
	std::unordered_set<char *> s12, s13, s14, s15;
	s12.insert(source());
	s15.insert(source());
	sink(s12); // tainted
	sink(s13);
	sink(s14);
	sink(s15); // tainted
	s12.swap(s13);
	s14.swap(s15);
	sink(s12); // [FALSE POSITIVE]
	sink(s13); // tainted
	sink(s14); // tainted
	sink(s15); // [FALSE POSITIVE]

	// merge
	std::unordered_set<char *> s16, s17, s18, s19;
	s16.insert(source());
	s17.insert("abc");
	s18.insert("def");
	s19.insert(source());
	sink(s16); // tainted
	sink(s17);
	sink(s18);
	sink(s19); // tainted
	s16.merge(s17);
	s18.merge(s19);
	sink(s16); // tainted
	sink(s17);
	sink(s18); // tainted
	sink(s19); // tainted

	// erase, clear
	std::unordered_set<char *> s20;
	s20.insert(source());
	s20.insert(source());
	sink(s20); // tainted
	sink(s20.erase(s20.begin())); // tainted
	sink(s20); // tainted
	s20.clear();
	sink(s20); // [FALSE POSITIVE]

	// emplace, emplace_hint
	std::unordered_set<char *> s21, s22;
	sink(s21.emplace("abc").first);
	sink(s21);
	sink(s21.emplace(source()).first); // tainted
	sink(s21); // tainted
	sink(s22.emplace_hint(s22.begin(), "abc"));
	sink(s22);
	sink(s22.emplace_hint(s22.begin(), source())); // tainted
	sink(s22); // tainted
}
