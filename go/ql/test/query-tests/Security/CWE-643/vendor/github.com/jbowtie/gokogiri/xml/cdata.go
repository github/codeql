package xml

/* CDataNode represents a CDATA section. This XML node type allows the embedding of unescaped, verbatim text within an XML document.

It is otherwise identical to a TextNode. It is most often used to wrap content that is whitespace-sensitive or likely to contain
large numbers of less-than or greater-than signs (such as code snippets or example documents).

If you use the XML_PARSE_NOCDATA parsing option, the parser will always present the CDATA sections as TextNodes.
*/
type CDataNode struct {
	*XmlNode
}
