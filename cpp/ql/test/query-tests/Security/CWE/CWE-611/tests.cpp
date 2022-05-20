// test cases for rule CWE-611 (XercesDOMParser)

#include "tests.h"

// ---

class XercesDOMParser: public AbstractDOMParser {
public:
	XercesDOMParser();
};

// ---

void test1(InputSource &data) {
	XercesDOMParser *p = new XercesDOMParser();

	p->parse(data); // BAD (parser not correctly configured)
}

void test2(InputSource &data) {
	XercesDOMParser *p = new XercesDOMParser();

	p->setDisableDefaultEntityResolution(true);
	p->parse(data); // GOOD
}

void test3(InputSource &data) {
	XercesDOMParser *p = new XercesDOMParser();

	p->setDisableDefaultEntityResolution(false);
	p->parse(data); // BAD (parser not correctly configured)
}

void test4(InputSource &data) {
	XercesDOMParser *p = new XercesDOMParser();

	p->setDisableDefaultEntityResolution(true);
	p->setCreateEntityReferenceNodes(false);
	p->parse(data); // BAD (parser not correctly configured)
}

void test5(InputSource &data) {
	XercesDOMParser *p = new XercesDOMParser();

	p->setDisableDefaultEntityResolution(true);
	p->setCreateEntityReferenceNodes(true);
	p->parse(data); // GOOD
}

void test6(InputSource &data) {
	XercesDOMParser *p = new XercesDOMParser();

	p->setDisableDefaultEntityResolution(true);
	p->parse(data); // GOOD
	p->setDisableDefaultEntityResolution(false);
	p->parse(data); // BAD (parser not correctly configured)
	p->setDisableDefaultEntityResolution(true);
	p->parse(data); // GOOD
	p->setCreateEntityReferenceNodes(false);
	p->parse(data); // BAD (parser not correctly configured)
	p->setCreateEntityReferenceNodes(true);
	p->parse(data); // GOOD
}

void test7(InputSource &data, bool cond) {
	XercesDOMParser *p = new XercesDOMParser();

	p->setDisableDefaultEntityResolution(cond);
	p->parse(data); // BAD (parser may not be correctly configured)
}

void test8(InputSource &data, bool cond) {
	XercesDOMParser *p = new XercesDOMParser();

	if (cond)
	{
		p->setDisableDefaultEntityResolution(true);
	}

	p->parse(data); // BAD (parser may not be correctly configured)
}

void test9(InputSource &data) {
	{
		XercesDOMParser *p = new XercesDOMParser();
		XercesDOMParser &q = *p;

		q.parse(data); // BAD (parser not correctly configured)
	}

	{
		XercesDOMParser *p = new XercesDOMParser();
		XercesDOMParser &q = *p;

		q.setDisableDefaultEntityResolution(true);
		q.parse(data); // GOOD
	}

	{
		XercesDOMParser *p = new XercesDOMParser();
		XercesDOMParser &q = *p;

		p->setDisableDefaultEntityResolution(true);
		q.parse(data); // GOOD [FALSE POSITIVE]
	}
}

void test10_doParseA(XercesDOMParser *p, InputSource &data) {
	p->parse(data); // GOOD
}

void test10_doParseB(XercesDOMParser *p, InputSource &data) {
	p->parse(data); // BAD (parser not correctly configured)
}

void test10_doParseC(XercesDOMParser *p, InputSource &data) {
	p->parse(data); // BAD (parser may not be correctly configured)
}

void test10(InputSource &data) {
	XercesDOMParser *p = new XercesDOMParser();
	XercesDOMParser *q = new XercesDOMParser();

	p->setDisableDefaultEntityResolution(true);
	test10_doParseA(p, data);
	test10_doParseB(q, data);
	test10_doParseC(p, data);
	test10_doParseC(q, data);
}
