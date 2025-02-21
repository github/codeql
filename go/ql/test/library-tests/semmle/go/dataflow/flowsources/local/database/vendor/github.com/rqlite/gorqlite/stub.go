package gorqlite

import "context"

type Connection struct{}

type QueryResult struct{}

type ParameterizedStatement interface{}

func (conn *Connection) Query(sqlStatements []string) (results []QueryResult, err error) {
	return make([]QueryResult, 0), nil
}

func (conn *Connection) QueryContext(ctx context.Context, sqlStatements []string) (results []QueryResult, err error) {
	return make([]QueryResult, 0), nil
}

func (conn *Connection) QueryOne(sqlStatement string) (qr QueryResult, err error) {
	return QueryResult{}, nil
}

func (conn *Connection) QueryOneContext(ctx context.Context, sqlStatement string) (qr QueryResult, err error) {
	return QueryResult{}, nil
}

func (conn *Connection) QueryOneParameterized(statement ParameterizedStatement) (qr QueryResult, err error) {
	return QueryResult{}, nil
}

func (conn *Connection) QueryOneParameterizedContext(ctx context.Context, statement ParameterizedStatement) (qr QueryResult, err error) {
	return QueryResult{}, nil
}

func (conn *Connection) QueryParameterized(sqlStatements []ParameterizedStatement) (results []QueryResult, err error) {
	return make([]QueryResult, 0), nil
}

func (conn *Connection) QueryParameterizedContext(ctx context.Context, sqlStatements []ParameterizedStatement) (results []QueryResult, err error) {
	return make([]QueryResult, 0), nil
}

func (qr *QueryResult) Columns() []string {
	return make([]string, 0)
}

func (qr *QueryResult) Next() bool {
	return false
}

func (qr *QueryResult) Scan(dest ...interface{}) error {
	return nil
}
