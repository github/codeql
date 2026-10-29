function expandSelfClosingTags(html) {
	var rxhtmlTag = /<(?!img|area)(([a-z][^\w\/>]*)[^>]*)\/>/gi;
	return html.replace(rxhtmlTag, "<$1></$2>"); // BAD
}
