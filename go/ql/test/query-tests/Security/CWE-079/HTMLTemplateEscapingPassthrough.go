package main

import (
	"html/template"
	"net/http"
	"os"
	"strconv"
)

func main() {}

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

type HTMLAlias = template.HTML

// bad is an example of a bad implementation
func bad(req *http.Request) {
	tmpl, _ := template.New("test").Parse(`Hi {{.}}\n`)
	tmplTag, _ := template.New("test").Parse(`Hi <b {{.}}></b>\n`)
	tmplScript, _ := template.New("test").Parse(`<script> eval({{.}}) </script>`)
	tmplSrcset, _ := template.New("test").Parse(`<img srcset="{{.}}"/>`)

	{
		{
			var a = template.HTML(req.UserAgent()) // $ Source[go/html-template-escaping-bypass-xss]
			checkError(tmpl.Execute(os.Stdout, a)) // $ Alert[go/html-template-escaping-bypass-xss]
		}
		{
			{
				var a template.HTML
				a = template.HTML(req.UserAgent())     // $ Source[go/html-template-escaping-bypass-xss]
				checkError(tmpl.Execute(os.Stdout, a)) // $ Alert[go/html-template-escaping-bypass-xss]
			}
			{
				var a HTMLAlias
				a = HTMLAlias(req.UserAgent())         // $ Source[go/html-template-escaping-bypass-xss]
				checkError(tmpl.Execute(os.Stdout, a)) // $ Alert[go/html-template-escaping-bypass-xss]
			}
		}
	}
	{
		var c = template.HTMLAttr(req.UserAgent()) // $ Source[go/html-template-escaping-bypass-xss]
		checkError(tmplTag.Execute(os.Stdout, c))  // $ Alert[go/html-template-escaping-bypass-xss]
	}
	{
		var d = template.JS(req.UserAgent())         // $ Source[go/html-template-escaping-bypass-xss]
		checkError(tmplScript.Execute(os.Stdout, d)) // $ Alert[go/html-template-escaping-bypass-xss]
	}
	{
		var e = template.JSStr(req.UserAgent())      // $ Source[go/html-template-escaping-bypass-xss]
		checkError(tmplScript.Execute(os.Stdout, e)) // $ Alert[go/html-template-escaping-bypass-xss]
	}
	{
		var b = template.CSS(req.UserAgent())  // $ Source[go/html-template-escaping-bypass-xss]
		checkError(tmpl.Execute(os.Stdout, b)) // $ Alert[go/html-template-escaping-bypass-xss]
	}
	{
		var f = template.Srcset(req.UserAgent())     // $ Source[go/html-template-escaping-bypass-xss]
		checkError(tmplSrcset.Execute(os.Stdout, f)) // $ Alert[go/html-template-escaping-bypass-xss]
	}
	{
		var g = template.URL(req.UserAgent())  // $ Source[go/html-template-escaping-bypass-xss]
		checkError(tmpl.Execute(os.Stdout, g)) // $ Alert[go/html-template-escaping-bypass-xss]
	}
}

// good is an example of a good implementation
func good(req *http.Request) {
	tmpl, _ := template.New("test").Parse(`Hello, {{.}}\n`)
	{ // This will be escaped, so it shoud NOT be caught:
		var escaped = req.UserAgent()
		checkError(tmpl.Execute(os.Stdout, escaped))
	}
	{
		// The converted source value does NOT flow to tmpl.Exec,
		// so this should NOT be caught.
		src := req.UserAgent()
		converted := template.HTML(src)
		_ = converted
		checkError(tmpl.Execute(os.Stdout, src))
	}
	{
		// The untrusted input is sanitized before use.
		tmpl, _ := template.New("test").Parse(`<div>Your user agent is {{.}}</div>`)
		src := req.UserAgent()

		converted := template.HTML("<b>" + template.HTMLEscapeString(src) + "</b>")
		checkError(tmpl.Execute(os.Stdout, converted))
	}
}

// good: the following example demonstrates data flow from untrusted input
// to a passthrough type and data flow from a passthrough type to
// a template, but crucially no data flow from the untrusted input to the
// template without a sanitizer.
func getId(r *http.Request) string {
	return r.Form.Get("id") // untrusted
}

func passthrough(x string) template.HTML {
	return template.HTML(x) // passthrough type
}

func sink(wr http.ResponseWriter, x any) {
	tmpl, _ := template.New("test").Parse(`Hello, {{.}}\n`)
	tmpl.Execute(wr, x) // template sink
}

func source2waypoint() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		x := getId(r)
		passthrough(x) // untrusted input goes to the passthrough type
	})
}

func waypoint2sink() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		// passthrough type with trusted input goes to the sink
		sink(w, passthrough("not tainted"))
	})
}

func source2sinkSanitized() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		x := getId(r) // untrusted input
		// TODO: We expected this test to fail with the current implementation, since the A->C
		// taint tracking configuration does not actually check for sanitizers. However, the
		// sink in `sink` only gets flagged if we remove the line with the sanitizer here.
		// While this behaviour is desired, it's unclear why it works right now.
		// Once we rewrite the query using the new data flow implementation, we should
		// probably use flow states for this query, which will then also address this issue.
		y, _ := strconv.Atoi(x) // sanitizer
		sink(w, y)              // sink
	})
}
