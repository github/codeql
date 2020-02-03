package squirrel

type StatementBuilderType struct{}

func Expr(e string) string {
	return Expr(e)
}

var StatementBuilder = &StatementBuilderType{}

func (b *StatementBuilderType) Insert(table string) *StatementBuilderType {
	return b
}

func (b *StatementBuilderType) Columns(columns ...string) *StatementBuilderType {
	return b
}

func (b *StatementBuilderType) Values(strings ...string) *StatementBuilderType {
	return b
}

func (b *StatementBuilderType) Exec() {
}
