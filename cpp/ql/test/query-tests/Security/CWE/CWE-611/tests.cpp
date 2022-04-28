// test cases for rule CWE-611

#include "tests.h"

// ---

class AbstractDOMParser {
public:
	AbstractDOMParser();

	void setDisableDefaultEntityResolution(bool); // default is false
	void setCreateEntityReferenceNodes(bool); // default is true
	void setSecurityManager(SecurityManager *const manager);
	void parse(const InputSource &data);
};

class XercesDOMParser: public AbstractDOMParser {
public:
	XercesDOMParser();
};

class DOMLSParser : public AbstractDOMParser {
};

class DOMImplementationLS {
public:
	DOMLSParser *createLSParser();
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

void test11(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();

	p->parse(data); // BAD (parser not correctly configured)
}

void test12(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();

	p->setDisableDefaultEntityResolution(true);
	p->parse(data); // GOOD
}

DOMImplementationLS *g_impl;
DOMLSParser *g_p1, *g_p2;
InputSource *g_data;

void test13_init() {
	g_p1 = g_impl->createLSParser();
	g_p1->setDisableDefaultEntityResolution(true);

	g_p2 = g_impl->createLSParser();
}

void test13() {
	test13_init();

	g_p1->parse(*g_data); // GOOD
	g_p2->parse(*g_data); // BAD (parser not correctly configured) [NOT DETECTED]
}
