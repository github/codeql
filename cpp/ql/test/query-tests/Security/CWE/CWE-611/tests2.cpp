// test cases for rule CWE-611 (SAXParser)

#include "tests.h"

// ---

class SAXParser
{
public:
	SAXParser();

	void setDisableDefaultEntityResolution(bool); // default is false
	void setSecurityManager(SecurityManager *const manager);
	void parse(const InputSource &data);
};

// ---

void test2_1(InputSource &data) {
	SAXParser *p = new SAXParser();

	p->parse(data); // BAD (parser not correctly configured)
}

void test2_2(InputSource &data) {
	SAXParser *p = new SAXParser();

	p->setDisableDefaultEntityResolution(true);
	p->parse(data); // GOOD
}

void test2_3(InputSource &data) {
	SAXParser *p = new SAXParser();
	bool v = false;

	p->setDisableDefaultEntityResolution(v);
	p->parse(data); // BAD (parser not correctly configured)
}

void test2_4(InputSource &data) {
	SAXParser *p = new SAXParser();
	bool v = true;

	p->setDisableDefaultEntityResolution(v);
	p->parse(data); // GOOD
}

void test2_5(InputSource &data) {
	SAXParser p;

	p.parse(data); // BAD (parser not correctly configured)
}

void test2_6(InputSource &data) {
	SAXParser p;

	p.setDisableDefaultEntityResolution(true);
	p.parse(data); // GOOD
}
