package main

//go:generate depstubber -vendor -use_ext_types github.com/ChrisTrenkamp/goxpath Opts,FuncOpts,XPathExec Parse,MustParse,ParseExec
//go:generate depstubber -vendor github.com/ChrisTrenkamp/goxpath/tree Node,String
//go:generate depstubber -vendor github.com/antchfx/htmlquery "" Find,FindOne,QueryAll,Query
//go:generate depstubber -vendor github.com/antchfx/jsonquery Node Find,FindOne,QueryAll,Query
//go:generate depstubber -vendor github.com/antchfx/xmlquery Node Find,FindOne,FindEach,FindEachWithBreak,QueryAll,Query
//go:generate depstubber -vendor github.com/antchfx/xpath "" Compile,MustCompile,Select
//go:generate depstubber -vendor github.com/go-xmlpath/xmlpath "" Compile,MustCompile
//go:generate depstubber -vendor github.com/jbowtie/gokogiri/xml Node
//go:generate depstubber -vendor github.com/jbowtie/gokogiri/xpath "" Compile
//go:generate depstubber -vendor github.com/santhosh-tekuri/xpathparser "" Parse,MustParse

import (
	"net/http"

	"github.com/ChrisTrenkamp/goxpath"
	"github.com/antchfx/htmlquery"
	"github.com/antchfx/jsonquery"
	"github.com/antchfx/xmlquery"
	"github.com/antchfx/xpath"
	"github.com/go-xmlpath/xmlpath"
	gokogiriXml "github.com/jbowtie/gokogiri/xml"
	gokogiriXpath "github.com/jbowtie/gokogiri/xpath"
	"github.com/santhosh-tekuri/xpathparser"
)

func main() {}

func testAntchfxXpath(r *http.Request) {
	r.ParseForm()
	username := r.Form.Get("username")

	// BAD: User input used directly in an XPath expression
	_, _ = xpath.Compile("//users/user[login/text()='" + username + "']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = xpath.MustCompile("//users/user[login/text()='" + username + "']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = xpath.Select(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")
}

func testAntchfxHtmlquery(r *http.Request) {
	r.ParseForm()
	username := r.Form.Get("username")

	// BAD: User input used directly in an XPath expression
	_ = htmlquery.Find(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = htmlquery.FindOne(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_, _ = htmlquery.QueryAll(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_, _ = htmlquery.Query(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")
}

func testAntchfxXmlquery(r *http.Request, n *xmlquery.Node) {
	r.ParseForm()
	username := r.Form.Get("username")

	// BAD: User input used directly in an XPath expression
	_ = xmlquery.Find(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = xmlquery.FindOne(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	xmlquery.FindEach(nil, "//users/user[login/text()='"+username+"']/home_dir/text()", nil)

	// BAD: User input used directly in an XPath expression
	xmlquery.FindEachWithBreak(nil, "//users/user[login/text()='"+username+"']/home_dir/text()", nil)

	// BAD: User input used directly in an XPath expression
	_, _ = xmlquery.QueryAll(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_, _ = xmlquery.Query(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = n.SelectElements("//users/user[login/text()='" + username + "']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = n.SelectElement("//users/user[login/text()='" + username + "']/home_dir/text()")
}

func testAntchfxJsonquery(r *http.Request) {
	r.ParseForm()
	username := r.Form.Get("username")

	// BAD: User input used directly in an XPath expression
	_ = jsonquery.Find(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = jsonquery.FindOne(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_, _ = jsonquery.QueryAll(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_, _ = jsonquery.Query(nil, "//users/user[login/text()='"+username+"']/home_dir/text()")
}

func testGoXmlpathXmlpath(r *http.Request) {
	r.ParseForm()
	username := r.Form.Get("username")

	// BAD: User input used directly in an XPath expression
	_, _ = xmlpath.Compile("//users/user[login/text()='" + username + "']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = xmlpath.MustCompile("//users/user[login/text()='" + username + "']/home_dir/text()")
}

func testChrisTrenkampGoxpath(r *http.Request) {
	r.ParseForm()
	username := r.Form.Get("username")
	password := r.Form.Get("password")

	// BAD: User input used directly in an XPath expression
	_, _ = goxpath.Parse("//users/user[login/text()='" + username + "' and password/text() = '" + password + "']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = goxpath.MustParse("//users/user[login/text()='" + username + "' and password/text() = '" + password + "']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_, _ = goxpath.ParseExec("//users/user[login/text()='"+username+"' and password/text() = '"+password+"']/home_dir/text()", nil)

	// GOOD: Uses parameters to avoid including user input directly in XPath expression
	_ = goxpath.MustParse("//users/user[login/text()=$username and password/text() = $password]/home_dir/text()")
}

func testSanthoshTekuriXpathparser(r *http.Request) {
	r.ParseForm()
	username := r.Form.Get("username")

	// BAD: User input used directly in an XPath expression
	_, _ = xpathparser.Parse("//users/user[login/text()='" + username + "']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_ = xpathparser.MustParse("//users/user[login/text()='" + username + "']/home_dir/text()")
}

func testJbowtieGokogiri(r *http.Request, n gokogiriXml.Node) {
	r.ParseForm()
	username := r.Form.Get("username")
	password := r.Form.Get("password")

	// BAD: User input used directly in an XPath expression
	xpath := gokogiriXpath.Compile("//users/user[login/text()='" + username + "' and password/text() = '" + password + "']/home_dir/text()")

	// BAD: User input used directly in an XPath expression
	_, _ = n.Search("//users/user[login/text()='" + username + "' and password/text() = '" + password + "']/home_dir/text()")

	// OK: This is not flagged, since the creation of `xpath` is already flagged.
	_, _ = n.Search(xpath)

	// BAD: User input used directly in an XPath expression
	_, _ = n.SearchWithVariables("//users/user[login/text()='"+username+"' and password/text() = '"+password+"']/home_dir/text()", nil)

	// GOOD: Uses parameters to avoid including user input directly in XPath expression
	_, _ = n.SearchWithVariables("//users/user[login/text()=$username and password/text() = $password]/home_dir/text()", nil)

	// OK: This is not flagged, since the creation of `xpath` is already flagged.
	_, _ = n.SearchWithVariables(xpath, nil)

	// BAD: User input used directly in an XPath expression
	_, _ = n.EvalXPath("//users/user[login/text()='"+username+"' and password/text() = '"+password+"']/home_dir/text()", nil)

	// GOOD: Uses parameters to avoid including user input directly in XPath expression
	_, _ = n.EvalXPath("//users/user[login/text()=$username and password/text() = $password]/home_dir/text()", nil)

	// OK: This is not flagged, since the creation of `xpath` is already flagged.
	_, _ = n.EvalXPath(xpath, nil)

	// BAD: User input used directly in an XPath expression
	_ = n.EvalXPathAsBoolean("//users/user[login/text()='"+username+"' and password/text() = '"+password+"']/home_dir/text()", nil)

	// GOOD: Uses parameters to avoid including user input directly in XPath expression
	_ = n.EvalXPathAsBoolean("//users/user[login/text()=$username and password/text() = $password]/home_dir/text()", nil)

	// OK: This is not flagged, since the creation of `xpath` is already flagged.
	_ = n.EvalXPathAsBoolean(xpath, nil)
}
