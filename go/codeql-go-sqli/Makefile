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

ZIPLIST :=					\
Makefile					\
README.org					\
SqlInjection.ql					\
add-user.go					\
add-user.sh					\
admin						\
build.sh					\
go-sqli-ba5819d.db.zip				\
go-sqli.code-workspace				\
go.mod						\
go.sum						\
qlpack.yml					\
sarif-summary.jq

demo-zip: 
	rm -f go-sqli-demo.zip
	zip go-sqli-demo.zip $(ZIPLIST)
