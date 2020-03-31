package goxpath

type Opts struct {}
type FuncOpts func(*Opts)

type XPathExec struct {}
func Parse(xp string) (XPathExec, error)
func MustParse(xp string) XPathExec
func ParseExec(xpstr string, t tree.Node, opts ...FuncOpts) (tree.Result, error) 