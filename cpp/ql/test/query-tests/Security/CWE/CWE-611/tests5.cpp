// test cases for rule CWE-611 (createLSParser)

#include "tests.h"

// ---

class DOMConfiguration {
public:
	void setParameter(const XMLCh *parameter, bool value);
};

class DOMLSParser {
public:
	DOMConfiguration *getDomConfig();

	void parse(const InputSource &data);
};

class DOMImplementationLS {
public:
	DOMLSParser *createLSParser();
};

// ---

void test5_1(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();

	p->parse(data); // BAD (parser not correctly configured)
}

void test5_2(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();

	p->getDomConfig()->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, true);
	p->parse(data); // GOOD
}

void test5_3(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();

	p->getDomConfig()->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, false);
	p->parse(data); // BAD (parser not correctly configured)
}

void test5_4(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();
	DOMConfiguration *cfg = p->getDomConfig();

	cfg->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, true);
	p->parse(data); // GOOD
}

void test5_5(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();
	DOMConfiguration *cfg = p->getDomConfig();

	cfg->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, false);
	p->parse(data); // BAD (parser not correctly configured)
}

DOMImplementationLS *g_impl;
DOMLSParser *g_p1, *g_p2;
InputSource *g_data;

void test5_6_init() {
	g_p1 = g_impl->createLSParser();
	g_p1->getDomConfig()->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, true);

	g_p2 = g_impl->createLSParser();
}

void test5_6() {
	test5_6_init();

	g_p1->parse(*g_data); // GOOD
	g_p2->parse(*g_data); // BAD (parser not correctly configured)
}

void test5_7(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();

	p->parse(data); // BAD (parser not correctly configured)

	p->getDomConfig()->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, true);
	p->parse(data); // GOOD

	p->getDomConfig()->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, false);
	p->parse(data); // BAD (parser not correctly configured)
}

void test5_8(DOMImplementationLS *impl, InputSource &data) {
	DOMLSParser *p = impl->createLSParser();
	DOMConfiguration *cfg = p->getDomConfig();

	p->parse(data); // BAD (parser not correctly configured) [NOT DETECTED]

	cfg->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, true);
	p->parse(data); // GOOD

	cfg->setParameter(XMLUni::fgXercesDisableDefaultEntityResolution, false);
	p->parse(data); // BAD (parser not correctly configured) [NOT DETECTED]
}
