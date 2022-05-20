package main

import (
	"fmt"
	"os"
	"text/template"
)

func main() {
	const site = `
<html>
<head>
  <title>My Cool Site</title>
</head>
<body>
  <h1>{{.Name}}</h1>
  <p>{{.Message}}</p>
</body>
</html>
`

	data := struct{ Name, Message string }{"Thomas", "Hello Thomas!"}

	templ := template.Must(template.New("letter").Parse(site))

	err := templ.Execute(os.Stdout, data)
	if err != nil {
		fmt.Println("Error: ", err)
	}

	templ = template.Must(template.ParseFiles("someletter", "somejs"))
	templ.ExecuteTemplate(os.Stdout, "someletter", "This is a long message")
}
