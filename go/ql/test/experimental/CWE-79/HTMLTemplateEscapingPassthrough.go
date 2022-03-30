package main

import (
	"html/template"
	"net/http"
	"os"
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
			var a = template.HTML(req.UserAgent())
			checkError(tmpl.Execute(os.Stdout, a))
		}
		{
			{
				var a template.HTML
				a = template.HTML(req.UserAgent())
				checkError(tmpl.Execute(os.Stdout, a))
			}
			{
				var a HTMLAlias
				a = HTMLAlias(req.UserAgent())
				checkError(tmpl.Execute(os.Stdout, a))
			}
		}
	}
	{
		var c = template.HTMLAttr(req.UserAgent())
		checkError(tmplTag.Execute(os.Stdout, c))
	}
	{
		var d = template.JS(req.UserAgent())
		checkError(tmplScript.Execute(os.Stdout, d))
	}
	{
		var e = template.JSStr(req.UserAgent())
		checkError(tmplScript.Execute(os.Stdout, e))
	}
	{
		var b = template.CSS(req.UserAgent())
		checkError(tmpl.Execute(os.Stdout, b))
	}
	{
		var f = template.Srcset(req.UserAgent())
		checkError(tmplSrcset.Execute(os.Stdout, f))
	}
	{
		var g = template.URL(req.UserAgent())
		checkError(tmpl.Execute(os.Stdout, g))
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
