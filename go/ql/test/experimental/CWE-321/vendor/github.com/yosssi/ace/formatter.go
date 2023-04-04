package ace

import "bytes"
import "strings"

// File represents a file.
type outputFormatter interface {
	OpeningElement(*bytes.Buffer, element) (int, error)
	ClosingElement(*bytes.Buffer, element) (int, error)
	WritingTextValue(*bytes.Buffer, element) (int, error)
}

type Formatter struct {
	indent string
}

func newFormatter(indent string) outputFormatter {
	f := &Formatter{
		indent: indent,
	}
	return f
}

func (f *Formatter) OpeningElement(bf *bytes.Buffer, e element) (int, error) {
	if e.IsControlElement() {
		return 0, nil
	}

	base := e.Base()
	if base.parent != nil && base.parent.IsBlockElement() {
		return f.writeIndent(bf, base.ln.indent)
	}
	return 0, nil
}
func (f *Formatter) ClosingElement(bf *bytes.Buffer, e element) (int, error) {
	if e.IsBlockElement() {
		return f.writeIndent(bf, e.Base().ln.indent)
	}
	return 0, nil
}
func (f *Formatter) WritingTextValue(bf *bytes.Buffer, e element) (int, error) {
	if e.IsBlockElement() {
		return f.writeIndent(bf, e.Base().ln.indent+1)
	}
	return 0, nil
}

func (f *Formatter) writeIndent(bf *bytes.Buffer, depth int) (int, error) {
	indent := "\n" + strings.Repeat(f.indent, depth)
	return bf.WriteString(indent)
}
