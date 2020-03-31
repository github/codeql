package xpath

type NodeNavigator interface {
}

type NodeIterator struct {
}

func Select(root NodeNavigator, expr string) *NodeIterator

type Expr struct {
}

func Compile(expr string) (*Expr, error)

func MustCompile(expr string) *Expr
