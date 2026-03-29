#ifndef __CHELPER_H__
#define __CHELPER_H__

#include <libxml/tree.h>
#include <libxml/parser.h>
#include <libxml/HTMLtree.h>
#include <libxml/HTMLparser.h>
#include <libxml/xmlsave.h>
#include <libxml/xpath.h>
#include <libxml/debugXML.h>

xmlDoc* xmlParse(void *buffer, int buffer_len, void *url, void *encoding, int options, void *error_buffer, int errror_buffer_len);
xmlNode* xmlParseFragment(void* doc, void *buffer, int buffer_len, void *url, int options, void *error_buffer, int error_buffer_len);
xmlNode* xmlParseFragmentAsDoc(void *doc, void *buffer, int buffer_len, void *url, void *encoding, int options, void *error_buffer, int error_buffer_len);
int xmlSaveNode(void *node, void *encoding, int options);
void xmlRemoveDefaultNamespace(xmlNode *node);

void xmlSetContent(void *node, char *content);

xmlDoc* newEmptyXmlDoc();
xmlElementType getNodeType(xmlNode *node);
char *xmlDocDumpToString(xmlDoc *doc, void *encoding, int format);
char *htmlDocDumpToString(xmlDoc *doc, int format);
void xmlFreeChars(char *buffer);
int xmlUnlinkNodeWithCheck(xmlNode *node);
int xmlNodePtrCheck(void *node);
void xmlNodeWriteCallback(void *data, int data_len);
void xmlUnlinkNodeCallback(void *nodePtr);

typedef struct XmlBufferContext {
	void *obj;
	char *buffer;
	int buffer_len;
	int data_size;
} XmlBufferContext;

#endif //__CHELPER_H__
