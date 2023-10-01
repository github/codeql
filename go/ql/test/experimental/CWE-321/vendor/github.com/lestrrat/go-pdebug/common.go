package pdebug

import (
	"io"
	"os"
	"sync"
	"time"
)

type pdctx struct {
	mutex   sync.Mutex
	indentL int
	LogTime bool
	Prefix  string
	Writer  io.Writer
}

var emptyMarkerGuard = &markerg{}

type markerg struct {
	indentg guard
	ctx     *pdctx
	f       string
	args    []interface{}
	start   time.Time
	errptr  *error
}

var DefaultCtx = &pdctx{
	LogTime: true,
	Prefix:  "|DEBUG| ",
	Writer:  os.Stdout,
}

type guard struct {
	cb func()
}

func (g *guard) End() {
	if cb := g.cb; cb != nil {
		cb()
	}
}
