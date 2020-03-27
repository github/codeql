package goxpath

import (
	"github.com/ChrisTrenkamp/goxpath/tree"
)

type Opts struct {
	Vars map[string]tree.Result
}

type XPathExec struct {
}

type FuncOpts func(*Opts)

func MustParse(xp string) XPathExec {
	return XPathExec{}
}

func (xp XPathExec) ExecBool(t tree.Node, opts ...FuncOpts) (bool, error) {
	return false, nil
}
