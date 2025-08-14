package main

import (
	"html/template"
	"log"
	"net/http"
)

type Person struct {
	Name string
}

func (p Person) Greet() string {
	return "Hello, " + p.Name
}

func handler(w http.ResponseWriter, r *http.Request) {
	person := Person{Name: "User"}
	tmpl := r.URL.Query().Get("template")
	if tmpl == "" {
		tmpl = "{{.Greet}}"
	}
	t, err := template.New("webpage").Parse(tmpl)
	if err != nil {
		http.Error(w, "Error parsing template", http.StatusInternalServerError)
		return
	}
	err = t.Execute(w, person)
	if err != nil {
		http.Error(w, "Error executing template", http.StatusInternalServerError)
	}
}

func main() {
	http.HandleFunc("/", handler)
	log.Println("Starting server on :8081")
	log.Fatal(http.ListenAndServe(":8081", nil))
}
