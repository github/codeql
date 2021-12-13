all: add-user

init: go-sqlite3 add-user 
	./admin -r
	./admin -c
	rm -f users.log
show:
	./admin -s

go-sqlite3: 
	go get github.com/mattn/go-sqlite3

add-user: add-user.go
	go build $<

run: add-user
	./add-user 2>> users.log

clean:
	rm -f README.html add-user users.log
	rm -f users.sqlite *.bak *~ go-sqli.sarif go-sqli.txt

%.html: %.org
	emacs $< --batch -l init.el -f org-html-export-to-html --kill


ZIPLIST :=					\
codeql-go-sqli/Makefile				\
codeql-go-sqli/README.org			\
codeql-go-sqli/README.html			\
codeql-go-sqli/SqlInjection.ql			\
codeql-go-sqli/add-user.go			\
codeql-go-sqli/add-user.sh			\
codeql-go-sqli/admin				\
codeql-go-sqli/build.sh				\
codeql-go-sqli/go-sqli-ba5819d.db.zip		\
codeql-go-sqli/go-sqli.code-workspace		\
codeql-go-sqli/go.mod				\
codeql-go-sqli/go.sum				\
codeql-go-sqli/qlpack.yml			\
codeql-go-sqli/sarif-summary.jq

demo-zip: README.html
	rm -f codeql-go-sqli.zip && cd ../ && zip codeql-go-sqli/codeql-go-sqli.zip $(ZIPLIST)
