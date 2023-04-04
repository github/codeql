// +build debug OR debug0

package pdebug

import (
	"bytes"
	"fmt"
	"strings"
	"time"

	"github.com/davecgh/go-spew/spew"
)

const Enabled = true

type Guard interface {
	End()
}

var emptyGuard = &guard{}

func (ctx *pdctx) Unindent() {
	ctx.mutex.Lock()
	defer ctx.mutex.Unlock()
	ctx.indentL--
}

func (ctx *pdctx) Indent() guard {
	ctx.mutex.Lock()
	ctx.indentL++
	ctx.mutex.Unlock()

	return guard{cb: ctx.Unindent}
}

func (ctx *pdctx) preamble(buf *bytes.Buffer) {
	if p := ctx.Prefix; len(p) > 0 {
		buf.WriteString(p)
	}
	if ctx.LogTime {
		fmt.Fprintf(buf, "%0.5f ", float64(time.Now().UnixNano()) / 1000000.0)
	}

	for i := 0; i < ctx.indentL; i++ {
		buf.WriteString("  ")
	}
}

func (ctx *pdctx) Printf(f string, args ...interface{}) {
	if !strings.HasSuffix(f, "\n") {
		f = f + "\n"
	}
	buf := bytes.Buffer{}
	ctx.preamble(&buf)
	fmt.Fprintf(&buf, f, args...)
	buf.WriteTo(ctx.Writer)
}

func Marker(f string, args ...interface{}) *markerg {
	return DefaultCtx.Marker(f, args...)
}

func (ctx *pdctx) Marker(f string, args ...interface{}) *markerg {
	if !Trace {
		return emptyMarkerGuard
	}

	buf := &bytes.Buffer{}
	ctx.preamble(buf)
	buf.WriteString("START ")
	fmt.Fprintf(buf, f, args...)
	if buf.Len() > 0 {
		if b := buf.Bytes(); b[buf.Len()-1] != '\n' {
			buf.WriteRune('\n')
		}
	}

	buf.WriteTo(ctx.Writer)

	g := ctx.Indent()
	return &markerg{
		indentg: g,
		ctx:     ctx,
		f:       f,
		args:    args,
		start:   time.Now(),
		errptr:  nil,
	}
}

func (g *markerg) BindError(errptr *error) *markerg {
	if g.ctx == nil {
		return g
	}
	g.ctx.mutex.Lock()
	defer g.ctx.mutex.Unlock()

	g.errptr = errptr
	return g
}

func (g *markerg) End() {
	if g.ctx == nil {
		return
	}

	g.indentg.End() // unindent
	buf := &bytes.Buffer{}
	g.ctx.preamble(buf)
	fmt.Fprint(buf, "END ")
	fmt.Fprintf(buf, g.f, g.args...)
	fmt.Fprintf(buf, " (%s)", time.Since(g.start))
	if errptr := g.errptr; errptr != nil && *errptr != nil {
		fmt.Fprintf(buf, ": ERROR: %s", *errptr)
	}

	if buf.Len() > 0 {
		if b := buf.Bytes(); b[buf.Len()-1] != '\n' {
			buf.WriteRune('\n')
		}
	}

	buf.WriteTo(g.ctx.Writer)
}

type legacyg struct {
	guard
	start time.Time
}

var emptylegacyg = legacyg{}

func (g legacyg) IRelease(f string, args ...interface{}) {
	if !Trace {
		return
	}
	g.End()
	dur := time.Since(g.start)
	Printf("%s (%s)", fmt.Sprintf(f, args...), dur)
}

// IPrintf indents and then prints debug messages. Execute the callback
// to undo the indent
func IPrintf(f string, args ...interface{}) legacyg {
	if !Trace {
		return emptylegacyg
	}

	DefaultCtx.Printf(f, args...)
	g := legacyg{
		guard: DefaultCtx.Indent(),
		start: time.Now(),
	}
	return g
}

// Printf prints debug messages. Only available if compiled with "debug" tag
func Printf(f string, args ...interface{}) {
	if !Trace {
		return
	}
	DefaultCtx.Printf(f, args...)
}

func Dump(v ...interface{}) {
	if !Trace {
		return
	}
	spew.Dump(v...)
}
