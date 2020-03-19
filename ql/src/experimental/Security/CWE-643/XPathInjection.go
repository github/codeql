package main

import (
  "net/http"
  "github.com/moovweb/gokogiri"
)

func processRequest(r *http.Request, doc *XmlDocument) {
  r.parseForm()
  username := r.Form.Get("username")
  password := r.Form.Get("password")
  
  root := doc.Root()
  // BAD: User input used directly in an XPath expression
  doc, _ := root.SearchWithVariables("//users/user[login/text()='" + username + "' and password/text() = '" + password + "']/home_dir/text()")

  // GOOD: Uses parameters to avoid including user input directly in XPath expression
  doc, _ := root.SearchWithVariables("//users/user[login/text()=$username and password/text() = $password]/home_dir/text()")
}
