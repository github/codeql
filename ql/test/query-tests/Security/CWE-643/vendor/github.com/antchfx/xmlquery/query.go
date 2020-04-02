package xmlquery

func (n *Node) SelectElements(name string) []*Node
func (n *Node) SelectElement(name string) *Node
func Find(top *Node, expr string) []*Node
func FindOne(top *Node, expr string) *Node
func QueryAll(top *Node, expr string) ([]*Node, error)
func Query(top *Node, expr string) (*Node, error)
func FindEach(top *Node, expr string, cb func(int, *Node))
func FindEachWithBreak(top *Node, expr string, cb func(int, *Node) bool)
