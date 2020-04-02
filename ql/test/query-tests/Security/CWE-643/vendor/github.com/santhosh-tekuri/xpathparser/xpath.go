package xpathparser

type Expr interface{}

func MustParse(xpath string) Expr
func Parse(xpath string) (expr Expr, err error)
