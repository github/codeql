package htmlquery

func Find(top *html.Node, expr string) []*html.Node
func FindOne(top *html.Node, expr string) *html.Node
func QueryAll(top *html.Node, expr string) ([]*html.Node, error)
func Query(top *html.Node, expr string) (*html.Node, error)
