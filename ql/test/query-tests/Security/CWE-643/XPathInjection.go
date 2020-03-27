package main

import (
	"fmt"
	"net/http"

	"github.com/ChrisTrenkamp/goxpath"
	"github.com/ChrisTrenkamp/goxpath/tree"
)

func main() {}

func processRequest(r *http.Request, doc tree.Node) {
	r.ParseForm()
	username := r.Form.Get("username")
	password := r.Form.Get("password")

	// BAD: User input used directly in an XPath expression
	xPath := goxpath.MustParse("//users/user[login/text()='" + username + "' and password/text() = '" + password + "']/home_dir/text()")
	unsafeRes, _ := xPath.ExecBool(doc)
	fmt.Println(unsafeRes)

	// GOOD: Value of parameters is defined here instead of directly in the query
	opt := func(o *goxpath.Opts) {
		o.Vars["username"] = tree.String(username)
		o.Vars["password"] = tree.String(password)
	}
	// GOOD: Uses parameters to avoid including user input directly in XPath expression
	xPath = goxpath.MustParse("//users/user[login/text()=$username and password/text() = $password]/home_dir/text()")
	safeRes, _ := xPath.ExecBool(doc, opt)
	fmt.Println(safeRes)
}
