package test

import (
	"golang.org/x/net/html"
	"net/http"
)

func test(request *http.Request, writer http.ResponseWriter) {

	cookie, _ := request.Cookie("SomeCookie")

	writer.Write([]byte(html.EscapeString(cookie.Value))) // GOOD: escaped.

	writer.Write([]byte(html.UnescapeString(cookie.Value))) // BAD: unescaped.

	node, _ := html.Parse(request.Body)
	writer.Write([]byte(node.Data)) // BAD: writing unescaped HTML data

	node2, _ := html.ParseWithOptions(request.Body)
	writer.Write([]byte(node2.Data)) // BAD: writing unescaped HTML data

	nodes, _ := html.ParseFragment(request.Body, nil)
	writer.Write([]byte(nodes[0].Data)) // BAD: writing unescaped HTML data

	nodes2, _ := html.ParseFragmentWithOptions(request.Body, nil)
	writer.Write([]byte(nodes2[0].Data)) // BAD: writing unescaped HTML data

	html.Render(writer, node) // BAD: rendering untrusted HTML to `writer`

	tokenizer := html.NewTokenizer(request.Body)
	writer.Write(tokenizer.Buffered()) // BAD: writing unescaped HTML data
	writer.Write(tokenizer.Raw())      // BAD: writing unescaped HTML data
	_, value, _ := tokenizer.TagAttr()
	writer.Write(value)                          // BAD: writing unescaped HTML data
	writer.Write(tokenizer.Text())               // BAD: writing unescaped HTML data
	writer.Write([]byte(tokenizer.Token().Data)) // BAD: writing unescaped HTML data

}
