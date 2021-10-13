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
	rm -f users.sqlite *.bak *~ cpp-sqli-demo.zip

ZIPLIST :=					\
    Makefile					\
    README.org					\
    SqlInjection.ql				\
    add-user.c					\
    add-user.sh					\
    admin					\
    build.sh					\
    codeql-dataflow-sql-injection.md		\
    codeql-overview-for-workshop.pdf		\
    cpp-sqli.code-workspace			\
    dataflow-cropped.pdf			\
    qlpack.yml					\
    sarif-summary.jq				\
    session.ql

demo-zip: 
	rm -f cpp-sqli-demo.zip
	zip cpp-sqli-demo.zip $(ZIPLIST)
