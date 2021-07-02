add-user: add-user.c
	clang -Wall add-user.c -lsqlite3 -o add-user

clean:
	rm -f README.html add-user cpp-sqli.sarif cpp-sqli.txt users.log
	rm -f users.sqlite *.bak *~ cpp-sqli-demo.zip

ZIPLIST := Makefile				\
    README.org					\
    SqlInjection.ql				\
    add-user.c					\
    add-user.sh					\
    admin					\
    build.sh					\
    codeql-dataflow-sql-injection.md		\
    cpp-sqli.code-workspace			\
    dataflow-cropped.pdf			\
    qlpack.yml					\
    sarif-summary.jq

demo-zip: 
	rm -f cpp-sqli-demo.zip
	zip cpp-sqli-demo.zip $(ZIPLIST)
