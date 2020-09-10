module codeql-go-tests/gomod

go 1.14

require (
	github.com/github/codeql-go v1.23.2-0.20200302182241-5e71a04fdf30 // indirect
	golang.org/x/tools v0.0.0-20200109174759-ac4f524c1612 // indirect
)

exclude github.com/github/codeql-go v1.23.1

replace github.com/Masterminds/squirrel => ./squirrel

replace github.com/Sirupsen/logrus v1.4.1 => github.com/sirupsen/logrus v1.4.1

require github.com/gorilla/mux v1.7.4 // indirect

require (
	github.com/Masterminds/squirrel v1.2.0 // indirect
	github.com/Sirupsen/logrus v1.4.1 // indirect
)

exclude github.com/sirupsen/logrus v1.4.2
