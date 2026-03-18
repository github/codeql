// Copyright 2016 José Santos <henrique_1609@me.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package jet

import (
	"fmt"
	"strings"
	"unicode"
	"unicode/utf8"
)

// item represents a token or text string returned from the scanner.
type item struct {
	typ itemType // The type of this item.
	pos Pos      // The starting position, in bytes, of this item in the input string.
	val string   // The value of this item.
}

func (i item) String() string {
	switch {
	case i.typ == itemEOF:
		return "EOF"
	case i.typ == itemError:
		return i.val
	case i.typ > itemKeyword:
		return fmt.Sprintf("<%s>", i.val)
	case len(i.val) > 10:
		return fmt.Sprintf("%.10q...", i.val)
	}
	return fmt.Sprintf("%q", i.val)
}

// itemType identifies the type of lex items.
type itemType int

const (
	itemError        itemType = iota // error occurred; value is text of error
	itemBool                         // boolean constant
	itemChar                         // printable ASCII character; grab bag for comma etc.
	itemCharConstant                 // character constant
	itemComplex                      // complex constant (1+2i); imaginary is just a number
	itemEOF
	itemField      // alphanumeric identifier starting with '.'
	itemIdentifier // alphanumeric identifier not starting with '.'
	itemLeftDelim  // left action delimiter
	itemLeftParen  // '(' inside action
	itemNumber     // simple number, including imaginary
	itemPipe       // pipe symbol
	itemRawString  // raw quoted string (includes quotes)
	itemRightDelim // right action delimiter
	itemRightParen // ')' inside action
	itemSpace      // run of spaces separating arguments
	itemString     // quoted string (includes quotes)
	itemText       // plain text
	itemAssign
	itemEquals
	itemNotEquals
	itemGreat
	itemGreatEquals
	itemLess
	itemLessEquals
	itemComma
	itemSemicolon
	itemAdd
	itemMinus
	itemMul
	itemDiv
	itemMod
	itemColon
	itemTernary
	itemLeftBrackets
	itemRightBrackets
	itemUnderscore
	// Keywords appear after all the rest.
	itemKeyword // used only to delimit the keywords
	itemExtends
	itemImport
	itemInclude
	itemBlock
	itemEnd
	itemYield
	itemContent
	itemIf
	itemElse
	itemRange
	itemTry
	itemCatch
	itemReturn
	itemAnd
	itemOr
	itemNot
	itemNil
	itemMSG
	itemTrans
)

var key = map[string]itemType{
	"extends": itemExtends,
	"import":  itemImport,

	"include": itemInclude,
	"block":   itemBlock,
	"end":     itemEnd,
	"yield":   itemYield,
	"content": itemContent,

	"if":   itemIf,
	"else": itemElse,

	"range": itemRange,

	"try":   itemTry,
	"catch": itemCatch,

	"return": itemReturn,

	"and": itemAnd,
	"or":  itemOr,
	"not": itemNot,

	"nil": itemNil,

	"msg":   itemMSG,
	"trans": itemTrans,
}

const eof = -1

const (
	defaultLeftDelim  = "{{"
	defaultRightDelim = "}}"
	leftComment       = "{*"
	rightComment      = "*}"
	leftTrimMarker    = "- "
	rightTrimMarker   = " -"
	trimMarkerLen     = Pos(len(leftTrimMarker))
)

// stateFn represents the state of the scanner as a function that returns the next state.
type stateFn func(*lexer) stateFn

// lexer holds the state of the scanner.
type lexer struct {
	name           string    // the name of the input; used only for error reports
	input          string    // the string being scanned
	state          stateFn   // the next lexing function to enter
	pos            Pos       // current position in the input
	start          Pos       // start position of this item
	width          Pos       // width of last rune read from input
	lastPos        Pos       // position of most recent item returned by nextItem
	items          chan item // channel of scanned items
	parenDepth     int       // nesting depth of ( ) exprs
	lastType       itemType
	leftDelim      string
	rightDelim     string
	trimRightDelim string
}

func (l *lexer) setDelimiters(leftDelim, rightDelim string) {
	if leftDelim != "" {
		l.leftDelim = leftDelim
	}
	if rightDelim != "" {
		l.rightDelim = rightDelim
	}
}

// next returns the next rune in the input.
func (l *lexer) next() rune {
	if int(l.pos) >= len(l.input) {
		l.width = 0
		return eof
	}
	r, w := utf8.DecodeRuneInString(l.input[l.pos:])
	l.width = Pos(w)
	l.pos += l.width
	return r
}

// peek returns but does not consume the next rune in the input.
func (l *lexer) peek() rune {
	r := l.next()
	l.backup()
	return r
}

// backup steps back one rune. Can only be called once per call of next.
func (l *lexer) backup() {
	l.pos -= l.width
}

// emit passes an item back to the client.
func (l *lexer) emit(t itemType) {
	l.lastType = t
	l.items <- item{t, l.start, l.input[l.start:l.pos]}
	l.start = l.pos
}

// ignore skips over the pending input before this point.
func (l *lexer) ignore() {
	l.start = l.pos
}

// accept consumes the next rune if it's from the valid set.
func (l *lexer) accept(valid string) bool {
	if strings.IndexRune(valid, l.next()) >= 0 {
		return true
	}
	l.backup()
	return false
}

// acceptRun consumes a run of runes from the valid set.
func (l *lexer) acceptRun(valid string) {
	for strings.IndexRune(valid, l.next()) >= 0 {
	}
	l.backup()
}

// lineNumber reports which line we're on, based on the position of
// the previous item returned by nextItem. Doing it this way
// means we don't have to worry about peek double counting.
func (l *lexer) lineNumber() int {
	return 1 + strings.Count(l.input[:l.lastPos], "\n")
}

// errorf returns an error token and terminates the scan by passing
// back a nil pointer that will be the next state, terminating l.nextItem.
func (l *lexer) errorf(format string, args ...interface{}) stateFn {
	l.items <- item{itemError, l.start, fmt.Sprintf(format, args...)}
	return nil
}

// nextItem returns the next item from the input.
// Called by the parser, not in the lexing goroutine.
func (l *lexer) nextItem() item {
	item := <-l.items
	l.lastPos = item.pos
	return item
}

// drain drains the output so the lexing goroutine will exit.
// Called by the parser, not in the lexing goroutine.
func (l *lexer) drain() {
	for range l.items {
	}
}

// lex creates a new scanner for the input string.
func lex(name, input string, run bool) *lexer {
	l := &lexer{
		name:           name,
		input:          input,
		items:          make(chan item),
		leftDelim:      defaultLeftDelim,
		rightDelim:     defaultRightDelim,
		trimRightDelim: rightTrimMarker + defaultRightDelim,
	}
	if run {
		l.run()
	}
	return l
}

// run runs the state machine for the lexer.
func (l *lexer) run() {
	go func() {
		for l.state = lexText; l.state != nil; {
			l.state = l.state(l)
		}
		close(l.items)
	}()
}

// state functions
func lexText(l *lexer) stateFn {
	for {
		// without breaking the API, this seems like a reasonable workaround to correctly parse comments
		i := strings.IndexByte(l.input[l.pos:], l.leftDelim[0])  // index of suspected left delimiter
		ic := strings.IndexByte(l.input[l.pos:], leftComment[0]) // index of suspected left comment marker
		if ic > -1 && ic < i {                                   // use whichever is lower for future lexing
			i = ic
		}
		// if no token is found, skip till the end of template
		if i == -1 {
			l.pos = Pos(len(l.input))
			break
		} else {
			l.pos += Pos(i)
			if strings.HasPrefix(l.input[l.pos:], l.leftDelim) {
				ld := Pos(len(l.leftDelim))
				trimLength := Pos(0)
				if strings.HasPrefix(l.input[l.pos+ld:], leftTrimMarker) {
					trimLength = rightTrimLength(l.input[l.start:l.pos])
				}
				l.pos -= trimLength
				if l.pos > l.start {
					l.emit(itemText)
				}
				l.pos += trimLength
				l.ignore()
				return lexLeftDelim
			}
			if strings.HasPrefix(l.input[l.pos:], leftComment) {
				if l.pos > l.start {
					l.emit(itemText)
				}
				return lexComment
			}
		}
		if l.next() == eof {
			break
		}
	}
	// Correctly reached EOF.
	if l.pos > l.start {
		l.emit(itemText)
	}
	l.emit(itemEOF)
	return nil
}

func lexLeftDelim(l *lexer) stateFn {
	l.pos += Pos(len(l.leftDelim))
	l.emit(itemLeftDelim)
	trimSpace := strings.HasPrefix(l.input[l.pos:], leftTrimMarker)
	if trimSpace {
		l.pos += trimMarkerLen
		l.ignore()
	}
	l.parenDepth = 0
	return lexInsideAction
}

// lexComment scans a comment. The left comment marker is known to be present.
func lexComment(l *lexer) stateFn {
	l.pos += Pos(len(leftComment))
	i := strings.Index(l.input[l.pos:], rightComment)
	if i < 0 {
		return l.errorf("unclosed comment")
	}
	l.pos += Pos(i + len(rightComment))
	l.ignore()
	return lexText
}

// lexRightDelim scans the right delimiter, which is known to be present.
func lexRightDelim(l *lexer) stateFn {
	trimSpace := strings.HasPrefix(l.input[l.pos:], rightTrimMarker)
	if trimSpace {
		l.pos += trimMarkerLen
		l.ignore()
	}
	l.pos += Pos(len(l.rightDelim))
	l.emit(itemRightDelim)
	if trimSpace {
		l.pos += leftTrimLength(l.input[l.pos:])
		l.ignore()
	}
	return lexText
}

// lexInsideAction scans the elements inside action delimiters.
func lexInsideAction(l *lexer) stateFn {
	// Either number, quoted string, or identifier.
	// Spaces separate arguments; runs of spaces turn into itemSpace.
	// Pipe symbols separate and are emitted.
	delim, _ := l.atRightDelim()
	if delim {
		if l.parenDepth == 0 {
			return lexRightDelim
		}
		return l.errorf("unclosed left parenthesis")
	}
	switch r := l.next(); {
	case r == eof:
		return l.errorf("unclosed action")
	case isSpace(r):
		return lexSpace
	case r == ',':
		l.emit(itemComma)
	case r == ';':
		l.emit(itemSemicolon)
	case r == '*':
		l.emit(itemMul)
	case r == '/':
		l.emit(itemDiv)
	case r == '%':
		l.emit(itemMod)
	case r == '-':

		if r := l.peek(); '0' <= r && r <= '9' &&
			itemAdd != l.lastType &&
			itemMinus != l.lastType &&
			itemNumber != l.lastType &&
			itemIdentifier != l.lastType &&
			itemString != l.lastType &&
			itemRawString != l.lastType &&
			itemCharConstant != l.lastType &&
			itemBool != l.lastType &&
			itemField != l.lastType &&
			itemChar != l.lastType &&
			itemTrans != l.lastType {
			l.backup()
			return lexNumber
		}
		l.emit(itemMinus)
	case r == '+':
		if r := l.peek(); '0' <= r && r <= '9' &&
			itemAdd != l.lastType &&
			itemMinus != l.lastType &&
			itemNumber != l.lastType &&
			itemIdentifier != l.lastType &&
			itemString != l.lastType &&
			itemRawString != l.lastType &&
			itemCharConstant != l.lastType &&
			itemBool != l.lastType &&
			itemField != l.lastType &&
			itemChar != l.lastType &&
			itemTrans != l.lastType {
			l.backup()
			return lexNumber
		}
		l.emit(itemAdd)
	case r == '?':
		l.emit(itemTernary)
	case r == '&':
		if l.next() == '&' {
			l.emit(itemAnd)
		} else {
			l.backup()
		}
	case r == '<':
		if l.next() == '=' {
			l.emit(itemLessEquals)
		} else {
			l.backup()
			l.emit(itemLess)
		}
	case r == '>':
		if l.next() == '=' {
			l.emit(itemGreatEquals)
		} else {
			l.backup()
			l.emit(itemGreat)
		}
	case r == '!':
		if l.next() == '=' {
			l.emit(itemNotEquals)
		} else {
			l.backup()
			l.emit(itemNot)
		}

	case r == '=':
		if l.next() == '=' {
			l.emit(itemEquals)
		} else {
			l.backup()
			l.emit(itemAssign)
		}
	case r == ':':
		if l.next() == '=' {
			l.emit(itemAssign)
		} else {
			l.backup()
			l.emit(itemColon)
		}
	case r == '|':
		if l.next() == '|' {
			l.emit(itemOr)
		} else {
			l.backup()
			l.emit(itemPipe)
		}
	case r == '"':
		return lexQuote
	case r == '`':
		return lexRawQuote
	case r == '\'':
		return lexChar
	case r == '.':
		// special look-ahead for ".field" so we don't break l.backup().
		if l.pos < Pos(len(l.input)) {
			r := l.input[l.pos]
			if r < '0' || '9' < r {
				return lexField
			}
		}
		fallthrough // '.' can start a number.
	case '0' <= r && r <= '9':
		l.backup()
		return lexNumber
	case r == '_':
		if !isAlphaNumeric(l.peek()) {
			l.emit(itemUnderscore)
			return lexInsideAction
		}
		fallthrough // no space? must be the start of an identifier
	case isAlphaNumeric(r):
		l.backup()
		return lexIdentifier
	case r == '[':
		l.emit(itemLeftBrackets)
	case r == ']':
		l.emit(itemRightBrackets)
	case r == '(':
		l.emit(itemLeftParen)
		l.parenDepth++
	case r == ')':
		l.emit(itemRightParen)
		l.parenDepth--
		if l.parenDepth < 0 {
			return l.errorf("unexpected right paren %#U", r)
		}
	case r <= unicode.MaxASCII && unicode.IsPrint(r):
		l.emit(itemChar)
	default:
		return l.errorf("unrecognized character in action: %#U", r)
	}
	return lexInsideAction
}

// lexSpace scans a run of space characters.
// One space has already been seen.
func lexSpace(l *lexer) stateFn {
	var numSpaces int
	for isSpace(l.peek()) {
		numSpaces++
		l.next()
	}
	if strings.HasPrefix(l.input[l.pos-1:], l.trimRightDelim) {
		l.backup()
		if numSpaces == 1 {
			return lexRightDelim
		}
	}
	l.emit(itemSpace)
	return lexInsideAction
}

// lexIdentifier scans an alphanumeric.
func lexIdentifier(l *lexer) stateFn {
Loop:
	for {
		switch r := l.next(); {
		case isAlphaNumeric(r):
		// absorb.
		default:
			l.backup()
			word := l.input[l.start:l.pos]
			if !l.atTerminator() {
				return l.errorf("bad character %#U", r)
			}
			switch {
			case key[word] > itemKeyword:
				l.emit(key[word])
			case word[0] == '.':
				l.emit(itemField)
			case word == "true", word == "false":
				l.emit(itemBool)
			default:
				l.emit(itemIdentifier)
			}
			break Loop
		}
	}
	return lexInsideAction
}

// lexField scans a field: .Alphanumeric.
// The . has been scanned.
func lexField(l *lexer) stateFn {

	if l.atTerminator() {
		// Nothing interesting follows -> "." or "$".
		l.emit(itemIdentifier)
		return lexInsideAction
	}

	var r rune
	for {
		r = l.next()
		if !isAlphaNumeric(r) {
			l.backup()
			break
		}
	}
	if !l.atTerminator() {
		return l.errorf("bad character %#U", r)
	}
	l.emit(itemField)
	return lexInsideAction
}

// atTerminator reports whether the input is at valid termination character to
// appear after an identifier. Breaks .X.Y into two pieces. Also catches cases
// like "$x+2" not being acceptable without a space, in case we decide one
// day to implement arithmetic.
func (l *lexer) atTerminator() bool {
	r := l.peek()
	if isSpace(r) {
		return true
	}
	switch r {
	case eof, '.', ',', '|', ':', ')', '=', '(', ';', '?', '[', ']', '+', '-', '/', '%', '*', '&', '!', '<', '>':
		return true
	}
	// Does r start the delimiter? This can be ambiguous (with delim=="//", $x/2 will
	// succeed but should fail) but only in extremely rare cases caused by willfully
	// bad choice of delimiter.
	if rd, _ := utf8.DecodeRuneInString(l.rightDelim); rd == r {
		return true
	}
	return false
}

// lexChar scans a character constant. The initial quote is already
// scanned. Syntax checking is done by the parser.
func lexChar(l *lexer) stateFn {
Loop:
	for {
		switch l.next() {
		case '\\':
			if r := l.next(); r != eof && r != '\n' {
				break
			}
			fallthrough
		case eof, '\n':
			return l.errorf("unterminated character constant")
		case '\'':
			break Loop
		}
	}
	l.emit(itemCharConstant)
	return lexInsideAction
}

// lexNumber scans a number: decimal, octal, hex, float, or imaginary. This
// isn't a perfect number scanner - for instance it accepts "." and "0x0.2"
// and "089" - but when it's wrong the input is invalid and the parser (via
// strconv) will notice.
func lexNumber(l *lexer) stateFn {
	if !l.scanNumber() {
		return l.errorf("bad number syntax: %q", l.input[l.start:l.pos])
	}

	l.emit(itemNumber)
	return lexInsideAction
}

func (l *lexer) scanNumber() bool {
	// Optional leading sign.
	l.accept("+-")
	// Is it hex?
	digits := "0123456789"
	if l.accept("0") && l.accept("xX") {
		digits = "0123456789abcdefABCDEF"
	}
	l.acceptRun(digits)
	if l.accept(".") {
		l.acceptRun(digits)
	}
	if l.accept("eE") {
		l.accept("+-")
		l.acceptRun("0123456789")
	}
	//Is it imaginary?
	l.accept("i")
	//Next thing mustn't be alphanumeric.
	if isAlphaNumeric(l.peek()) {
		l.next()
		return false
	}
	return true
}

// lexQuote scans a quoted string.
func lexQuote(l *lexer) stateFn {
Loop:
	for {
		switch l.next() {
		case '\\':
			if r := l.next(); r != eof && r != '\n' {
				break
			}
			fallthrough
		case eof, '\n':
			return l.errorf("unterminated quoted string")
		case '"':
			break Loop
		}
	}
	l.emit(itemString)
	return lexInsideAction
}

// lexRawQuote scans a raw quoted string.
func lexRawQuote(l *lexer) stateFn {
Loop:
	for {
		switch l.next() {
		case eof:
			return l.errorf("unterminated raw quoted string")
		case '`':
			break Loop
		}
	}
	l.emit(itemRawString)
	return lexInsideAction
}

// isSpace reports whether r is a space character.
func isSpace(r rune) bool {
	return r == ' ' || r == '\t' || r == '\r' || r == '\n'
}

// isAlphaNumeric reports whether r is an alphabetic, digit, or underscore.
func isAlphaNumeric(r rune) bool {
	return r == '_' || unicode.IsLetter(r) || unicode.IsDigit(r)
}

// rightTrimLength returns the length of the spaces at the end of the string.
func rightTrimLength(s string) Pos {
	return Pos(len(s) - len(strings.TrimRightFunc(s, isSpace)))
}

// leftTrimLength returns the length of the spaces at the beginning of the string.
func leftTrimLength(s string) Pos {
	return Pos(len(s) - len(strings.TrimLeftFunc(s, isSpace)))
}

// atRightDelim reports whether the lexer is at a right delimiter, possibly preceded by a trim marker.
func (l *lexer) atRightDelim() (delim, trimSpaces bool) {
	if strings.HasPrefix(l.input[l.pos:], l.trimRightDelim) { // With trim marker.
		return true, true
	}
	if strings.HasPrefix(l.input[l.pos:], l.rightDelim) { // Without trim marker.
		return true, false
	}
	return false, false
}
