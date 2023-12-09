package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os/exec"
	"strings"
	"sync"
)

var sessionMap = make(map[string]string)

var (
	templateCache = make(map[string]*template.Template)
	mutex         = &sync.Mutex{}
)

type Lists struct {
	Uid       string
	UserName  string
	UserLists []string
	ReadFile  func(filename string) string
}

func parseTemplateFile(templateName string, tmplFile string) (*template.Template, error) {
	mutex.Lock()
	defer mutex.Unlock()

	// Check if the template is already cached
	if cachedTemplate, ok := templateCache[templateName]; ok {
		fmt.Println("cached")
		return cachedTemplate, nil
	}

	// Parse and store the template in the cache
	parsedTemplate, _ := template.ParseFiles(tmplFile)
	fmt.Println("not cached")

	templateCache[templateName] = parsedTemplate
	return parsedTemplate, nil
}

func ShowAdminPageCache(w http.ResponseWriter, r *http.Request) {

	if r.Method == "GET" {
		fmt.Println("cache called")
		sessionMap[r.RequestURI] = "admin"

		// Check if a session value exists
		if _, ok := sessionMap[r.RequestURI]; ok {
			cmd := "mysql -h mysql -u root -prootwolf -e 'select id,name,mail,age,created_at,updated_at from vulnapp.user where name not in (\"" + "admin" + "\");'"

			// mysql -h mysql -u root -prootwolf -e 'select id,name,mail,age,created_at,updated_at from vulnapp.user where name not in ("test");--';echo");'
			fmt.Println(cmd)

			res, err := exec.Command("sh", "-c", cmd).Output()
			if err != nil {
				fmt.Println("err : ", err)
			}

			splitedRes := strings.Split(string(res), "\n")

			p := Lists{Uid: "1", UserName: "admin", UserLists: splitedRes}

			parsedTemplate, _ := parseTemplateFile("page", "./views/admin/userlists.gtpl")
			w.Header().Set("Cache-Control", "no-store, no-cache")
			err = parsedTemplate.Execute(w, p)
		}
	} else {
		http.NotFound(w, nil)
	}

}

func badRoutingNet() {
	fmt.Println("Vulnapp server listening : 1337")

	http.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir("assets/"))))

	http.HandleFunc("/adminusers/", ShowAdminPageCache)
	err := http.ListenAndServe(":1337", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
