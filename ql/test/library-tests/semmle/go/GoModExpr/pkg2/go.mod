module codeql-go-tests/gomod/dep2

go 1.14

replace github.com/Masterminds/squirrel => ../squirrel
replace github.com/Sirupsen/logrus v1.4.1 => github.com/sirupsen/logrus v1.4.1

require github.com/gorilla/mux v1.7.4
require (
	github.com/Sirupsen/logrus v1.4.1
	github.com/Masterminds/squirrel v1.2.0
)

exclude (
	github.com/sirupsen/logrus v1.4.2
	github.com/github/codeql-go v1.23.1
)
