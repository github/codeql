package xml

/*
AttributeNode represents an attribute, which has a name and a value.

AttributeNodes are created by calling SetAttr or SetNsAttr on an element node,
and retrieved by the Attribute and Attributes functions on an element node.

Note that while mamespace declarations resemble attributes, they are a distinct node type
and cannot be used or retrieved as an AttributeNode.
*/
type AttributeNode struct {
	*XmlNode
}

// String returns the value of the attribute.
func (attrNode *AttributeNode) String() string {
	return attrNode.Content()
}

// Value returns the value of the attribute.
func (attrNode *AttributeNode) Value() string {
	return attrNode.Content()
}

//SetValue sets the value of the attribute. Note that the argument will
// be converted to a string, and automatically XML-escaped when the
// document is serialized.
func (attrNode *AttributeNode) SetValue(val interface{}) {
	attrNode.SetContent(val)
}

/*
alias :value :content
alias :to_s :content
alias :content= :value=
*/
