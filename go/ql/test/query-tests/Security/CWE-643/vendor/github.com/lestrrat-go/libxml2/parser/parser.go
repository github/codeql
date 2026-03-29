package parser

import (
	"bytes"
	"io"

	"github.com/lestrrat-go/libxml2/clib"
	"github.com/lestrrat-go/libxml2/dom"
	"github.com/lestrrat-go/libxml2/types"
	"github.com/pkg/errors"
)

const _OptionName = "RecoverNoEntDTDLoadDTDAttrDTDValidNoErrorNoWarningPedanticNoBlanksSAX1XIncludeNoNetNoDictNscleanNoCDATANoXIncNodeCompactOld10NoBaseFixHugeOldSAXIgnoreEncBigLines"

var _OptionMap = map[int]string{
	1:       _OptionName[0:7],
	2:       _OptionName[7:12],
	4:       _OptionName[12:19],
	8:       _OptionName[19:26],
	16:      _OptionName[26:34],
	32:      _OptionName[34:41],
	64:      _OptionName[41:50],
	128:     _OptionName[50:58],
	256:     _OptionName[58:66],
	512:     _OptionName[66:70],
	1024:    _OptionName[70:78],
	2048:    _OptionName[78:83],
	4096:    _OptionName[83:89],
	8192:    _OptionName[89:96],
	16384:   _OptionName[96:103],
	32768:   _OptionName[103:113],
	65536:   _OptionName[113:120],
	131072:  _OptionName[120:125],
	262144:  _OptionName[125:134],
	524288:  _OptionName[134:138],
	1048576: _OptionName[138:144],
	2097152: _OptionName[144:153],
	4194304: _OptionName[153:161],
}

// Set flips the option bit in the given Option
func (o *Option) Set(options ...Option) {
	v := int(*o) // current value
	for _, i := range options {
		v = v | int(i)
	}
	*o = Option(v)
}

// String creates a string representation of the Option
func (o Option) String() string {
	if o == XMLParseEmptyOption {
		return "[]"
	}

	i := int(o)
	b := bytes.Buffer{}
	b.Write([]byte{'['})
	for x := 1; x < int(XMLParseMax); x = x << 1 {
		if (i & x) == x {
			v, ok := _OptionMap[x]
			if !ok {
				v = "Option(Unknown)"
			}
			b.WriteString(v)
			b.Write([]byte{'|'})
		}
	}
	x := b.Bytes()
	if x[len(x)-1] == '|' {
		x[len(x)-1] = ']'
	} else {
		x = append(x, ']')
	}
	return string(x)
}

// New creates a new Parser with the given options.
func New(opts ...Option) *Parser {
	var o Option

	for _, opt := range opts {
		o = o | opt
	}

	return &Parser{
		Options: o,
	}
}

// Parse parses XML from the given byte buffer
func (p *Parser) Parse(buf []byte) (types.Document, error) {
	return p.ParseString(string(buf))
}

// ParseString parses XML from the given string
func (p *Parser) ParseString(s string) (types.Document, error) {
	ctx, err := NewCtxt(s, p.Options)
	if err != nil {
		return nil, errors.Wrap(err, "failed to create parse context")
	}
	defer func() { _ = ctx.Free() }()

	docptr, err := clib.XMLCtxtReadMemory(ctx, s, "", "", int(p.Options))
	if err != nil {
		return nil, errors.Wrap(err, "failed to create parse input")
	}

	if docptr != 0 {
		return dom.WrapDocument(docptr), nil
	}
	return nil, errors.New("failed to generate document pointer")
}

// ParseReader parses XML from the given io.Reader
func (p *Parser) ParseReader(in io.Reader) (types.Document, error) {
	buf := &bytes.Buffer{}
	if _, err := buf.ReadFrom(in); err != nil {
		return nil, errors.Wrap(err, "failed to read from reader")
	}

	return p.ParseString(buf.String())
}

// NewCtxt creates a new Parser context
func NewCtxt(s string, o Option) (*Ctxt, error) {
	ctxptr, err := clib.XMLCreateMemoryParserCtxt(s, int(o))
	if err != nil {
		return nil, errors.Wrap(err, "failed to execute XMLCreateMemoryParserCtxt")
	}
	return &Ctxt{ptr: ctxptr}, nil
}

// Pointer returns the underlying C struct
func (ctx Ctxt) Pointer() uintptr {
	return ctx.ptr
}

// Parse starts the parsing on the Ctxt
func (ctx Ctxt) Parse() error {
	return clib.XMLParseDocument(ctx)
}

// Free releases the underlying C struct
func (ctx *Ctxt) Free() error {
	if err := clib.XMLFreeParserCtxt(ctx); err != nil {
		return errors.Wrap(err, "failed to free parser context")
	}

	ctx.ptr = 0
	return nil
}
