// test cases for rule CWE-611 (libxml2)

#include "tests.h"

// ---

enum xmlParserOption
{
	XML_PARSE_NOENT = 2,
	XML_PARSE_DTDLOAD = 4,
	XML_PARSE_OPTION_HARMLESS = 8
};

class xmlDoc;

xmlDoc *xmlReadFile(const char *fileName, const char *encoding, int flags);
xmlDoc *xmlReadMemory(const char *ptr, int sz, const char *url, const char *encoding, int flags);

void xmlFreeDoc(xmlDoc *ptr);

// ---

void test4_1(const char *fileName) {
	xmlDoc *p;

	p = xmlReadFile(fileName, NULL, XML_PARSE_NOENT); // BAD (parser not correctly configured)
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_2(const char *fileName) {
	xmlDoc *p;

	p = xmlReadFile(fileName, NULL, XML_PARSE_DTDLOAD); // BAD (parser not correctly configured)
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_3(const char *fileName) {
	xmlDoc *p;

	p = xmlReadFile(fileName, NULL, XML_PARSE_NOENT | XML_PARSE_DTDLOAD); // BAD (parser not correctly configured)
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_4(const char *fileName) {
	xmlDoc *p;

	p = xmlReadFile(fileName, NULL, 0); // GOOD
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_5(const char *fileName) {
	xmlDoc *p;

	p = xmlReadFile(fileName, NULL, XML_PARSE_OPTION_HARMLESS); // GOOD
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_6(const char *fileName) {
	xmlDoc *p;
	int flags = XML_PARSE_NOENT;

	p = xmlReadFile(fileName, NULL, flags); // BAD (parser not correctly configured)
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_7(const char *fileName) {
	xmlDoc *p;
	int flags = 0;

	p = xmlReadFile(fileName, NULL, flags); // GOOD
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_8(const char *fileName) {
	xmlDoc *p;
	int flags = XML_PARSE_OPTION_HARMLESS;

	p = xmlReadFile(fileName, NULL, flags | XML_PARSE_NOENT); // BAD (parser not correctly configured) [NOT DETECTED]
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_9(const char *fileName) {
	xmlDoc *p;
	int flags = XML_PARSE_NOENT;

	p = xmlReadFile(fileName, NULL, flags | XML_PARSE_OPTION_HARMLESS); // BAD (parser not correctly configured) [NOT DETECTED]
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_10(const char *ptr, int sz) {
	xmlDoc *p;

	p = xmlReadMemory(ptr, sz, "", NULL, 0); // GOOD
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}

void test4_11(const char *ptr, int sz) {
	xmlDoc *p;

	p = xmlReadMemory(ptr, sz, "", NULL, XML_PARSE_DTDLOAD); // BAD (parser not correctly configured)
	if (p != NULL)
	{
		xmlFreeDoc(p);
	}
}
