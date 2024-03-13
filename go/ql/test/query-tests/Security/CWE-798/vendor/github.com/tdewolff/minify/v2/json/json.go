// Package json minifies JSON following the specifications at http://json.org/.
package json

import (
	"io"

	"github.com/tdewolff/minify/v2"
	"github.com/tdewolff/parse/v2"
	"github.com/tdewolff/parse/v2/json"
)

var (
	commaBytes     = []byte(",")
	colonBytes     = []byte(":")
	zeroBytes      = []byte("0")
	minusZeroBytes = []byte("-0")
)

////////////////////////////////////////////////////////////////

// Minifier is a JSON minifier.
type Minifier struct {
	Precision   int  // number of significant digits
	KeepNumbers bool // prevent numbers from being minified
}

// Minify minifies JSON data, it reads from r and writes to w.
func Minify(m *minify.M, w io.Writer, r io.Reader, params map[string]string) error {
	return (&Minifier{}).Minify(m, w, r, params)
}

// Minify minifies JSON data, it reads from r and writes to w.
func (o *Minifier) Minify(_ *minify.M, w io.Writer, r io.Reader, _ map[string]string) error {
	skipComma := true

	z := parse.NewInput(r)
	defer z.Restore()

	p := json.NewParser(z)
	for {
		state := p.State()
		gt, text := p.Next()
		if gt == json.ErrorGrammar {
			if _, err := w.Write(nil); err != nil {
				return err
			}
			if p.Err() != io.EOF {
				return p.Err()
			}
			return nil
		}

		if !skipComma && gt != json.EndObjectGrammar && gt != json.EndArrayGrammar {
			if state == json.ObjectKeyState || state == json.ArrayState {
				w.Write(commaBytes)
			} else if state == json.ObjectValueState {
				w.Write(colonBytes)
			}
		}
		skipComma = gt == json.StartObjectGrammar || gt == json.StartArrayGrammar

		if !o.KeepNumbers && 0 < len(text) && ('0' <= text[0] && text[0] <= '9' || text[0] == '-') {
			text = minify.Number(text, o.Precision)
			if text[0] == '.' {
				w.Write(zeroBytes)
			} else if 1 < len(text) && text[0] == '-' && text[1] == '.' {
				text = text[1:]
				w.Write(minusZeroBytes)
			}
		}
		w.Write(text)
	}
}
