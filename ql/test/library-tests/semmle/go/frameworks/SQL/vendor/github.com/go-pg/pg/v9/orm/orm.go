package orm

type queryParamsAppender struct {
}

func Q(query string, params ...interface{}) *queryParamsAppender {
	return nil
}

type Query struct{}

func (q *Query) ColumnExpr(columns ...string) *Query {
	return nil
}

func (q *Query) For(s string, params ...interface{}) *Query {
	return nil
}

func (q *Query) FormatQuery(b []byte, query string, params ...interface{}) []byte {
	return nil
}

func (q *Query) Having(having string, params ...interface{}) *Query {
	return nil
}

func (q *Query) Where(condition string, params ...interface{}) *Query {
	return nil
}

func (q *Query) WhereIn(where string, slice interface{}) *Query {
	return nil
}

func (q *Query) WhereInMulti(where string, values ...interface{}) *Query {
	return nil
}

func (q *Query) WhereOr(condition string, params ...interface{}) *Query {
	return nil
}
