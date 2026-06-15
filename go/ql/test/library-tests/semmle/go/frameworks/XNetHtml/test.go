package test

import (
	"database/sql"
	"net/http"

	"golang.org/x/net/html"
)

func test(request *http.Request, writer http.ResponseWriter) {

	param1 := request.URL.Query().Get("param1")     // $ Source[go/reflected-xss]
	writer.Write([]byte(html.EscapeString(param1))) // GOOD: escaped.

	writer.Write([]byte(html.UnescapeString(param1))) // $ Alert[go/reflected-xss] // BAD: unescaped.

	node, _ := html.Parse(request.Body) // $ Source[go/reflected-xss]
	writer.Write([]byte(node.Data))     // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data

	node2, _ := html.ParseWithOptions(request.Body) // $ Source[go/reflected-xss]
	writer.Write([]byte(node2.Data))                // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data

	nodes, _ := html.ParseFragment(request.Body, nil) // $ Source[go/reflected-xss]
	writer.Write([]byte(nodes[0].Data))               // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data

	nodes2, _ := html.ParseFragmentWithOptions(request.Body, nil) // $ Source[go/reflected-xss]
	writer.Write([]byte(nodes2[0].Data))                          // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data

	html.Render(writer, node) // $ Alert[go/reflected-xss] // BAD: rendering untrusted HTML to `writer`

	tokenizer := html.NewTokenizer(request.Body) // $ Source[go/reflected-xss]
	writer.Write(tokenizer.Buffered())           // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data
	writer.Write(tokenizer.Raw())                // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data
	_, value, _ := tokenizer.TagAttr()
	writer.Write(value)                          // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data
	writer.Write(tokenizer.Text())               // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data
	writer.Write([]byte(tokenizer.Token().Data)) // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data

	tokenizerFragment := html.NewTokenizerFragment(request.Body, "some context") // $ Source[go/reflected-xss]
	writer.Write(tokenizerFragment.Buffered())                                   // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data

	var cleanNode html.Node
	taintedNode, _ := html.Parse(request.Body) // $ Source[go/reflected-xss]
	cleanNode.AppendChild(taintedNode)
	html.Render(writer, &cleanNode) // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data

	var cleanNode2 html.Node
	taintedNode2, _ := html.Parse(request.Body) // $ Source[go/reflected-xss]
	cleanNode2.InsertBefore(taintedNode2, &cleanNode2)
	html.Render(writer, &cleanNode2) // $ Alert[go/reflected-xss] // BAD: writing unescaped HTML data

}

func sqlTest(request *http.Request, db *sql.DB) {
	// Ensure EscapeString is a taint propagator for non-XSS queries, e.g. SQL injection:
	cookie, _ := request.Cookie("SomeCookie") // $ Source[go/sql-injection]
	db.Query(html.EscapeString(cookie.Value)) // $ Alert[go/sql-injection]
}
