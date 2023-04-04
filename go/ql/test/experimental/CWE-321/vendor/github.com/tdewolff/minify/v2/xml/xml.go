// Package xml minifies XML1.0 following the specifications at http://www.w3.org/TR/xml/.
package xml

import (
	"io"

	"github.com/tdewolff/minify/v2"
	"github.com/tdewolff/parse/v2"
	"github.com/tdewolff/parse/v2/xml"
)

var (
	isBytes    = []byte("=")
	spaceBytes = []byte(" ")
	voidBytes  = []byte("/>")
)

////////////////////////////////////////////////////////////////

// Minifier is an XML minifier.
type Minifier struct {
	KeepWhitespace bool
}

// Minify minifies XML data, it reads from r and writes to w.
func Minify(m *minify.M, w io.Writer, r io.Reader, params map[string]string) error {
	return (&Minifier{}).Minify(m, w, r, params)
}

// Minify minifies XML data, it reads from r and writes to w.
func (o *Minifier) Minify(m *minify.M, w io.Writer, r io.Reader, _ map[string]string) error {
	omitSpace := true // on true the next text token must not start with a space

	attrByteBuffer := make([]byte, 0, 64)

	z := parse.NewInput(r)
	defer z.Restore()

	l := xml.NewLexer(z)
	tb := NewTokenBuffer(l)
	for {
		t := *tb.Shift()
		if t.TokenType == xml.CDATAToken {
			if len(t.Text) == 0 {
				continue
			}
			if text, useText := xml.EscapeCDATAVal(&attrByteBuffer, t.Text); useText {
				t.TokenType = xml.TextToken
				t.Data = text
			}
		}
		switch t.TokenType {
		case xml.ErrorToken:
			if _, err := w.Write(nil); err != nil {
				return err
			}
			if l.Err() == io.EOF {
				return nil
			}
			return l.Err()
		case xml.DOCTYPEToken:
			w.Write(t.Data)
		case xml.CDATAToken:
			w.Write(t.Data)
			if len(t.Text) > 0 && parse.IsWhitespace(t.Text[len(t.Text)-1]) {
				omitSpace = true
			}
		case xml.TextToken:
			t.Data = parse.ReplaceMultipleWhitespaceAndEntities(t.Data, EntitiesMap, TextRevEntitiesMap)

			// whitespace removal; trim left
			if omitSpace && parse.IsWhitespace(t.Data[0]) {
				t.Data = t.Data[1:]
			}

			// whitespace removal; trim right
			omitSpace = false
			if len(t.Data) == 0 {
				omitSpace = true
			} else if parse.IsWhitespace(t.Data[len(t.Data)-1]) {
				omitSpace = true
				i := 0
				for {
					next := tb.Peek(i)
					// trim if EOF, text token with whitespace begin or block token
					if next.TokenType == xml.ErrorToken {
						t.Data = t.Data[:len(t.Data)-1]
						omitSpace = false
						break
					} else if next.TokenType == xml.TextToken {
						// this only happens when a comment, doctype, cdata startpi tag was in between
						// remove if the text token starts with a whitespace
						if len(next.Data) > 0 && parse.IsWhitespace(next.Data[0]) {
							t.Data = t.Data[:len(t.Data)-1]
							omitSpace = false
						}
						break
					} else if next.TokenType == xml.CDATAToken {
						if len(next.Text) > 0 && parse.IsWhitespace(next.Text[0]) {
							t.Data = t.Data[:len(t.Data)-1]
							omitSpace = false
						}
						break
					} else if next.TokenType == xml.StartTagToken || next.TokenType == xml.EndTagToken {
						if !o.KeepWhitespace {
							t.Data = t.Data[:len(t.Data)-1]
							omitSpace = false
						}
						break
					}
					i++
				}
			}
			w.Write(t.Data)
		case xml.StartTagToken:
			if o.KeepWhitespace {
				omitSpace = false
			}
			w.Write(t.Data)
		case xml.StartTagPIToken:
			w.Write(t.Data)
		case xml.AttributeToken:
			w.Write(spaceBytes)
			w.Write(t.Text)
			w.Write(isBytes)

			if len(t.AttrVal) < 2 {
				w.Write(t.AttrVal)
			} else {
				val := t.AttrVal[1 : len(t.AttrVal)-1]
				val = parse.ReplaceEntities(val, EntitiesMap, nil)
				val = xml.EscapeAttrVal(&attrByteBuffer, val) // prefer single or double quotes depending on what occurs more often in value
				w.Write(val)
			}
		case xml.StartTagCloseToken:
			next := tb.Peek(0)
			skipExtra := false
			if next.TokenType == xml.TextToken && parse.IsAllWhitespace(next.Data) {
				next = tb.Peek(1)
				skipExtra = true
			}
			if next.TokenType == xml.EndTagToken {
				// collapse empty tags to single void tag
				tb.Shift()
				if skipExtra {
					tb.Shift()
				}
				w.Write(voidBytes)
			} else {
				w.Write(t.Data)
			}
		case xml.StartTagCloseVoidToken:
			w.Write(t.Data)
		case xml.StartTagClosePIToken:
			w.Write(t.Data)
		case xml.EndTagToken:
			if o.KeepWhitespace {
				omitSpace = false
			}
			if len(t.Data) > 3+len(t.Text) {
				t.Data[2+len(t.Text)] = '>'
				t.Data = t.Data[:3+len(t.Text)]
			}
			w.Write(t.Data)
		}
	}
}
