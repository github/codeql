package jsonquery

func Find(top *Node, expr string) []*Node
func FindOne(top *Node, expr string) *Node
func QueryAll(top *Node, expr string) ([]*Node, error)
func Query(top *Node, expr string) (*Node, error)
