package subdir

import (
	mssql "github.com/microsoft/go-mssqldb"
)

func test() {
	connString := "hello"
	connector, err := mssql.NewAccessTokenConnector(
		connString, nil)

}
