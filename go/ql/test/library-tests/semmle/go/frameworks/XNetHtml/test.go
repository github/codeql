package test

import (
	"database/sql"
	"net/http"

	"golang.org/x/net/html"
)

func test(request *http.Request, writer http.ResponseWriter) {

	param1 := request.URL.Query().Get("param1")
	writer.Write([]byte(html.EscapeString(param1))) // GOOD: escaped.

	writer.Write([]byte(html.UnescapeString(param1))) // BAD: unescaped.

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

	tokenizerFragment := html.NewTokenizerFragment(request.Body, "some context")
	writer.Write(tokenizerFragment.Buffered()) // BAD: writing unescaped HTML data

	var cleanNode html.Node
	taintedNode, _ := html.Parse(request.Body)
	cleanNode.AppendChild(taintedNode)
	html.Render(writer, &cleanNode) // BAD: writing unescaped HTML data

	var cleanNode2 html.Node
	taintedNode2, _ := html.Parse(request.Body)
	cleanNode2.InsertBefore(taintedNode2, &cleanNode2)
	html.Render(writer, &cleanNode2) // BAD: writing unescaped HTML data

}

func sqlTest(request *http.Request, db *sql.DB) {
	// Ensure EscapeString is a taint propagator for non-XSS queries, e.g. SQL injection:
	cookie, _ := request.Cookie("SomeCookie")
	db.Query(html.EscapeString(cookie.Value))
}
