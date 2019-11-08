package squirrel

type SelectBuilder struct{}

func Expr(e string) string {
	return Expr(e)
}

func Select(s string) *SelectBuilder {
	return &SelectBuilder{}
}

func (b *SelectBuilder) From(f string) *SelectBuilder {
	return b
}

func (b *SelectBuilder) Where(e string) *SelectBuilder {
	return b
}

func (b *SelectBuilder) Suffix(s string) *SelectBuilder {
	return b
}
