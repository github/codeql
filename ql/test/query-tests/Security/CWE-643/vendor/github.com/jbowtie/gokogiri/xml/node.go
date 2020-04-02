package xml

type Node interface {
	Search(interface{}) ([]Node, error)
	SearchWithVariables(interface{}, xpath.VariableScope) ([]Node, error)
	EvalXPath(interface{}, xpath.VariableScope) (interface{}, error)
	EvalXPathAsBoolean(interface{}, xpath.VariableScope) bool
}
