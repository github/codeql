package astconv

import (
	"unicode"
	"unicode/utf8"
)

// TS7 SyntaxKind values for tokens (from microsoft/typescript-go internal/ast/kind.go).
const (
	KindUnknown                                    = 0
	KindEndOfFile                                  = 1
	KindSingleLineCommentTrivia                    = 2
	KindMultiLineCommentTrivia                     = 3
	KindNewLineTrivia                              = 4
	KindWhitespaceTrivia                           = 5
	KindConflictMarkerTrivia                       = 6
	KindNumericLiteral                             = 8
	KindBigIntLiteral                              = 9
	KindStringLiteral                              = 10
	KindRegularExpressionLiteral                   = 13
	KindNoSubstitutionTemplateLiteral              = 14
	KindTemplateHead                               = 15
	KindTemplateMiddle                             = 16
	KindTemplateTail                               = 17
	KindOpenBraceToken                             = 18
	KindCloseBraceToken                            = 19
	KindOpenParenToken                             = 20
	KindCloseParenToken                            = 21
	KindOpenBracketToken                           = 22
	KindCloseBracketToken                          = 23
	KindDotToken                                   = 24
	KindDotDotDotToken                             = 25
	KindSemicolonToken                             = 26
	KindCommaToken                                 = 27
	KindQuestionDotToken                           = 28
	KindLessThanToken                              = 29
	KindLessThanSlashToken                         = 30
	KindGreaterThanToken                           = 31
	KindLessThanEqualsToken                        = 32
	KindGreaterThanEqualsToken                     = 33
	KindEqualsEqualsToken                          = 34
	KindExclamationEqualsToken                     = 35
	KindEqualsEqualsEqualsToken                    = 36
	KindExclamationEqualsEqualsToken               = 37
	KindEqualsGreaterThanToken                     = 38
	KindPlusToken                                  = 39
	KindMinusToken                                 = 40
	KindAsteriskToken                              = 41
	KindAsteriskAsteriskToken                      = 42
	KindSlashToken                                 = 43
	KindPercentToken                               = 44
	KindPlusPlusToken                              = 45
	KindMinusMinusToken                            = 46
	KindLessThanLessThanToken                      = 47
	KindGreaterThanGreaterThanToken                = 48
	KindGreaterThanGreaterThanGreaterThanToken     = 49
	KindAmpersandToken                             = 50
	KindBarToken                                   = 51
	KindCaretToken                                 = 52
	KindExclamationToken                           = 53
	KindTildeToken                                 = 54
	KindAmpersandAmpersandToken                    = 55
	KindBarBarToken                                = 56
	KindQuestionToken                              = 57
	KindColonToken                                 = 58
	KindAtToken                                    = 59
	KindQuestionQuestionToken                      = 60
	KindHashToken                                  = 62
	KindEqualsToken                                = 63
	KindPlusEqualsToken                            = 64
	KindMinusEqualsToken                           = 65
	KindAsteriskEqualsToken                        = 66
	KindAsteriskAsteriskEqualsToken                = 67
	KindSlashEqualsToken                           = 68
	KindPercentEqualsToken                         = 69
	KindLessThanLessThanEqualsToken                = 70
	KindGreaterThanGreaterThanEqualsToken          = 71
	KindGreaterThanGreaterThanGreaterThanEqualsToken = 72
	KindAmpersandEqualsToken                       = 73
	KindBarEqualsToken                             = 74
	KindBarBarEqualsToken                          = 75
	KindAmpersandAmpersandEqualsToken              = 76
	KindQuestionQuestionEqualsToken                = 77
	KindCaretEqualsToken                           = 78
	KindIdentifier                                 = 79
	KindPrivateIdentifier                          = 80
)

// Token represents a single token from the scanner.
type Token struct {
	Kind     int    `json:"kind"`
	TokenPos int    `json:"tokenPos"`
	Text     string `json:"text"`
}

// RescanEvent tells the scanner to rescan at a given position.
type RescanEvent struct {
	Pos  int
	Kind string // "regex", "template", "greater"
}

// Scanner tokenizes TypeScript source text.
type Scanner struct {
	text   string
	pos    int
	events []RescanEvent
	evIdx  int
}

// NewScanner creates a scanner for the given source text.
// rescanEvents should be sorted by position. They inform the scanner
// about positions where regex literals, template tokens, or greater-than
// rescanning is needed (matching the Node.js wrapper behavior).
func NewScanner(text string, rescanEvents []RescanEvent) *Scanner {
	return &Scanner{
		text:   text,
		pos:    0,
		events: rescanEvents,
		evIdx:  0,
	}
}

// ScanAll produces all tokens from the source text.
func (s *Scanner) ScanAll() []Token {
	var tokens []Token
	for {
		tok := s.scan()
		tokens = append(tokens, tok)
		if tok.Kind == KindEndOfFile {
			break
		}
	}
	return tokens
}

func (s *Scanner) peek() byte {
	if s.pos >= len(s.text) {
		return 0
	}
	return s.text[s.pos]
}

func (s *Scanner) peekAt(offset int) byte {
	p := s.pos + offset
	if p >= len(s.text) {
		return 0
	}
	return s.text[p]
}

func (s *Scanner) advance() {
	s.pos++
}

func (s *Scanner) nextRescanPos() int {
	if s.evIdx < len(s.events) {
		return s.events[s.evIdx].Pos
	}
	return int(^uint(0) >> 1) // MaxInt
}

func (s *Scanner) nextRescanKind() string {
	if s.evIdx < len(s.events) {
		return s.events[s.evIdx].Kind
	}
	return ""
}

func (s *Scanner) consumeRescan() {
	if s.evIdx < len(s.events) {
		s.evIdx++
	}
}

func (s *Scanner) scan() Token {
	if s.pos >= len(s.text) {
		return Token{Kind: KindEndOfFile, TokenPos: s.pos, Text: ""}
	}

	tokenPos := s.pos
	ch := s.peek()

	// Whitespace (not newlines)
	if ch == ' ' || ch == '\t' || ch == '\f' || ch == '\v' {
		for s.pos < len(s.text) {
			c := s.text[s.pos]
			if c == ' ' || c == '\t' || c == '\f' || c == '\v' {
				s.pos++
			} else {
				break
			}
		}
		return Token{Kind: KindWhitespaceTrivia, TokenPos: tokenPos, Text: s.text[tokenPos:s.pos]}
	}

	// Newlines
	if ch == '\n' {
		s.advance()
		return Token{Kind: KindNewLineTrivia, TokenPos: tokenPos, Text: "\n"}
	}
	if ch == '\r' {
		s.advance()
		if s.peek() == '\n' {
			s.advance()
		}
		return Token{Kind: KindNewLineTrivia, TokenPos: tokenPos, Text: s.text[tokenPos:s.pos]}
	}

	// Check for rescan event at this position
	if tokenPos == s.nextRescanPos() {
		kind := s.nextRescanKind()
		s.consumeRescan()
		switch kind {
		case "regex":
			return s.scanRegExp(tokenPos)
		case "template":
			return s.scanTemplatePart(tokenPos, true)
		case "greater":
			return s.scanGreater(tokenPos)
		}
	}

	switch ch {
	case '/':
		next := s.peekAt(1)
		if next == '/' {
			return s.scanSingleLineComment(tokenPos)
		}
		if next == '*' {
			return s.scanMultiLineComment(tokenPos)
		}
		if next == '=' {
			s.pos += 2
			return Token{Kind: KindSlashEqualsToken, TokenPos: tokenPos, Text: "/="}
		}
		s.advance()
		return Token{Kind: KindSlashToken, TokenPos: tokenPos, Text: "/"}

	case '\'', '"':
		return s.scanString(tokenPos, ch)

	case '`':
		return s.scanTemplatePart(tokenPos, false)

	case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
		return s.scanNumber(tokenPos)

	case '{':
		s.advance()
		return Token{Kind: KindOpenBraceToken, TokenPos: tokenPos, Text: "{"}
	case '}':
		s.advance()
		return Token{Kind: KindCloseBraceToken, TokenPos: tokenPos, Text: "}"}
	case '(':
		s.advance()
		return Token{Kind: KindOpenParenToken, TokenPos: tokenPos, Text: "("}
	case ')':
		s.advance()
		return Token{Kind: KindCloseParenToken, TokenPos: tokenPos, Text: ")"}
	case '[':
		s.advance()
		return Token{Kind: KindOpenBracketToken, TokenPos: tokenPos, Text: "["}
	case ']':
		s.advance()
		return Token{Kind: KindCloseBracketToken, TokenPos: tokenPos, Text: "]"}
	case ';':
		s.advance()
		return Token{Kind: KindSemicolonToken, TokenPos: tokenPos, Text: ";"}
	case ',':
		s.advance()
		return Token{Kind: KindCommaToken, TokenPos: tokenPos, Text: ","}
	case '~':
		s.advance()
		return Token{Kind: KindTildeToken, TokenPos: tokenPos, Text: "~"}
	case '@':
		s.advance()
		return Token{Kind: KindAtToken, TokenPos: tokenPos, Text: "@"}

	case '.':
		if s.peekAt(1) == '.' && s.peekAt(2) == '.' {
			s.pos += 3
			return Token{Kind: KindDotDotDotToken, TokenPos: tokenPos, Text: "..."}
		}
		// .123 numeric literal
		if s.peekAt(1) >= '0' && s.peekAt(1) <= '9' {
			return s.scanNumber(tokenPos)
		}
		s.advance()
		return Token{Kind: KindDotToken, TokenPos: tokenPos, Text: "."}

	case ':':
		s.advance()
		return Token{Kind: KindColonToken, TokenPos: tokenPos, Text: ":"}

	case '?':
		if s.peekAt(1) == '.' && !(s.peekAt(2) >= '0' && s.peekAt(2) <= '9') {
			s.pos += 2
			return Token{Kind: KindQuestionDotToken, TokenPos: tokenPos, Text: "?."}
		}
		if s.peekAt(1) == '?' {
			if s.peekAt(2) == '=' {
				s.pos += 3
				return Token{Kind: KindQuestionQuestionEqualsToken, TokenPos: tokenPos, Text: "??="}
			}
			s.pos += 2
			return Token{Kind: KindQuestionQuestionToken, TokenPos: tokenPos, Text: "??"}
		}
		s.advance()
		return Token{Kind: KindQuestionToken, TokenPos: tokenPos, Text: "?"}

	case '!':
		if s.peekAt(1) == '=' {
			if s.peekAt(2) == '=' {
				s.pos += 3
				return Token{Kind: KindExclamationEqualsEqualsToken, TokenPos: tokenPos, Text: "!=="}
			}
			s.pos += 2
			return Token{Kind: KindExclamationEqualsToken, TokenPos: tokenPos, Text: "!="}
		}
		s.advance()
		return Token{Kind: KindExclamationToken, TokenPos: tokenPos, Text: "!"}

	case '=':
		if s.peekAt(1) == '=' {
			if s.peekAt(2) == '=' {
				s.pos += 3
				return Token{Kind: KindEqualsEqualsEqualsToken, TokenPos: tokenPos, Text: "==="}
			}
			s.pos += 2
			return Token{Kind: KindEqualsEqualsToken, TokenPos: tokenPos, Text: "=="}
		}
		if s.peekAt(1) == '>' {
			s.pos += 2
			return Token{Kind: KindEqualsGreaterThanToken, TokenPos: tokenPos, Text: "=>"}
		}
		s.advance()
		return Token{Kind: KindEqualsToken, TokenPos: tokenPos, Text: "="}

	case '+':
		if s.peekAt(1) == '+' {
			s.pos += 2
			return Token{Kind: KindPlusPlusToken, TokenPos: tokenPos, Text: "++"}
		}
		if s.peekAt(1) == '=' {
			s.pos += 2
			return Token{Kind: KindPlusEqualsToken, TokenPos: tokenPos, Text: "+="}
		}
		s.advance()
		return Token{Kind: KindPlusToken, TokenPos: tokenPos, Text: "+"}

	case '-':
		if s.peekAt(1) == '-' {
			s.pos += 2
			return Token{Kind: KindMinusMinusToken, TokenPos: tokenPos, Text: "--"}
		}
		if s.peekAt(1) == '=' {
			s.pos += 2
			return Token{Kind: KindMinusEqualsToken, TokenPos: tokenPos, Text: "-="}
		}
		s.advance()
		return Token{Kind: KindMinusToken, TokenPos: tokenPos, Text: "-"}

	case '*':
		if s.peekAt(1) == '*' {
			if s.peekAt(2) == '=' {
				s.pos += 3
				return Token{Kind: KindAsteriskAsteriskEqualsToken, TokenPos: tokenPos, Text: "**="}
			}
			s.pos += 2
			return Token{Kind: KindAsteriskAsteriskToken, TokenPos: tokenPos, Text: "**"}
		}
		if s.peekAt(1) == '=' {
			s.pos += 2
			return Token{Kind: KindAsteriskEqualsToken, TokenPos: tokenPos, Text: "*="}
		}
		s.advance()
		return Token{Kind: KindAsteriskToken, TokenPos: tokenPos, Text: "*"}

	case '%':
		if s.peekAt(1) == '=' {
			s.pos += 2
			return Token{Kind: KindPercentEqualsToken, TokenPos: tokenPos, Text: "%="}
		}
		s.advance()
		return Token{Kind: KindPercentToken, TokenPos: tokenPos, Text: "%"}

	case '<':
		if s.peekAt(1) == '<' {
			if s.peekAt(2) == '=' {
				s.pos += 3
				return Token{Kind: KindLessThanLessThanEqualsToken, TokenPos: tokenPos, Text: "<<="}
			}
			s.pos += 2
			return Token{Kind: KindLessThanLessThanToken, TokenPos: tokenPos, Text: "<<"}
		}
		if s.peekAt(1) == '/' {
			s.pos += 2
			return Token{Kind: KindLessThanSlashToken, TokenPos: tokenPos, Text: "</"}
		}
		if s.peekAt(1) == '=' {
			s.pos += 2
			return Token{Kind: KindLessThanEqualsToken, TokenPos: tokenPos, Text: "<="}
		}
		s.advance()
		return Token{Kind: KindLessThanToken, TokenPos: tokenPos, Text: "<"}

	case '>':
		return s.scanGreater(tokenPos)

	case '&':
		if s.peekAt(1) == '&' {
			if s.peekAt(2) == '=' {
				s.pos += 3
				return Token{Kind: KindAmpersandAmpersandEqualsToken, TokenPos: tokenPos, Text: "&&="}
			}
			s.pos += 2
			return Token{Kind: KindAmpersandAmpersandToken, TokenPos: tokenPos, Text: "&&"}
		}
		if s.peekAt(1) == '=' {
			s.pos += 2
			return Token{Kind: KindAmpersandEqualsToken, TokenPos: tokenPos, Text: "&="}
		}
		s.advance()
		return Token{Kind: KindAmpersandToken, TokenPos: tokenPos, Text: "&"}

	case '|':
		if s.peekAt(1) == '|' {
			if s.peekAt(2) == '=' {
				s.pos += 3
				return Token{Kind: KindBarBarEqualsToken, TokenPos: tokenPos, Text: "||="}
			}
			s.pos += 2
			return Token{Kind: KindBarBarToken, TokenPos: tokenPos, Text: "||"}
		}
		if s.peekAt(1) == '=' {
			s.pos += 2
			return Token{Kind: KindBarEqualsToken, TokenPos: tokenPos, Text: "|="}
		}
		s.advance()
		return Token{Kind: KindBarToken, TokenPos: tokenPos, Text: "|"}

	case '^':
		if s.peekAt(1) == '=' {
			s.pos += 2
			return Token{Kind: KindCaretEqualsToken, TokenPos: tokenPos, Text: "^="}
		}
		s.advance()
		return Token{Kind: KindCaretToken, TokenPos: tokenPos, Text: "^"}

	case '#':
		// Could be private identifier
		if s.peekAt(1) == '!' && tokenPos == 0 {
			// Shebang — scan to end of line
			return s.scanSingleLineComment(tokenPos)
		}
		if isIdentStart(s.peekAt(1)) {
			return s.scanPrivateIdentifier(tokenPos)
		}
		s.advance()
		return Token{Kind: KindHashToken, TokenPos: tokenPos, Text: "#"}
	}

	// Identifier or keyword
	if isIdentStartByte(ch) {
		return s.scanIdentifierOrKeyword(tokenPos)
	}

	// Handle multi-byte Unicode identifier starts
	r, size := utf8.DecodeRuneInString(s.text[s.pos:])
	if r != utf8.RuneError && isIdentStartRune(r) {
		return s.scanIdentifierOrKeyword(tokenPos)
	}

	// Unknown character
	s.pos += size
	return Token{Kind: KindUnknown, TokenPos: tokenPos, Text: s.text[tokenPos:s.pos]}
}

func (s *Scanner) scanSingleLineComment(start int) Token {
	s.pos += 2 // skip //
	for s.pos < len(s.text) && s.text[s.pos] != '\n' && s.text[s.pos] != '\r' {
		s.pos++
	}
	return Token{Kind: KindSingleLineCommentTrivia, TokenPos: start, Text: s.text[start:s.pos]}
}

func (s *Scanner) scanMultiLineComment(start int) Token {
	s.pos += 2 // skip /*
	for s.pos < len(s.text)-1 {
		if s.text[s.pos] == '*' && s.text[s.pos+1] == '/' {
			s.pos += 2
			return Token{Kind: KindMultiLineCommentTrivia, TokenPos: start, Text: s.text[start:s.pos]}
		}
		s.pos++
	}
	// Unterminated
	s.pos = len(s.text)
	return Token{Kind: KindMultiLineCommentTrivia, TokenPos: start, Text: s.text[start:s.pos]}
}

func (s *Scanner) scanString(start int, quote byte) Token {
	s.advance() // skip opening quote
	for s.pos < len(s.text) {
		ch := s.text[s.pos]
		if ch == '\\' {
			s.pos += 2
			continue
		}
		if ch == quote {
			s.advance()
			return Token{Kind: KindStringLiteral, TokenPos: start, Text: s.text[start:s.pos]}
		}
		if ch == '\n' || ch == '\r' {
			// Unterminated string
			break
		}
		s.pos++
	}
	return Token{Kind: KindStringLiteral, TokenPos: start, Text: s.text[start:s.pos]}
}

func (s *Scanner) scanTemplatePart(start int, isRescan bool) Token {
	if isRescan {
		// We're at a '}' that needs to be rescanned as TemplateMiddle or TemplateTail
		s.advance() // skip }
	} else {
		s.advance() // skip `
	}
	for s.pos < len(s.text) {
		ch := s.text[s.pos]
		if ch == '\\' {
			s.pos += 2
			continue
		}
		if ch == '`' {
			s.advance()
			if isRescan {
				return Token{Kind: KindTemplateTail, TokenPos: start, Text: s.text[start:s.pos]}
			}
			return Token{Kind: KindNoSubstitutionTemplateLiteral, TokenPos: start, Text: s.text[start:s.pos]}
		}
		if ch == '$' && s.peekAt(1) == '{' {
			s.pos += 2
			if isRescan {
				return Token{Kind: KindTemplateMiddle, TokenPos: start, Text: s.text[start:s.pos]}
			}
			return Token{Kind: KindTemplateHead, TokenPos: start, Text: s.text[start:s.pos]}
		}
		s.pos++
	}
	// Unterminated
	if isRescan {
		return Token{Kind: KindTemplateTail, TokenPos: start, Text: s.text[start:s.pos]}
	}
	return Token{Kind: KindNoSubstitutionTemplateLiteral, TokenPos: start, Text: s.text[start:s.pos]}
}

func (s *Scanner) scanRegExp(start int) Token {
	s.advance() // skip /
	inCharClass := false
	for s.pos < len(s.text) {
		ch := s.text[s.pos]
		if ch == '\\' {
			s.pos += 2
			continue
		}
		if ch == '[' {
			inCharClass = true
			s.pos++
			continue
		}
		if ch == ']' {
			inCharClass = false
			s.pos++
			continue
		}
		if ch == '/' && !inCharClass {
			s.advance() // skip closing /
			// Scan flags
			for s.pos < len(s.text) && isIdentChar(s.text[s.pos]) {
				s.pos++
			}
			return Token{Kind: KindRegularExpressionLiteral, TokenPos: start, Text: s.text[start:s.pos]}
		}
		if ch == '\n' || ch == '\r' {
			break
		}
		s.pos++
	}
	return Token{Kind: KindRegularExpressionLiteral, TokenPos: start, Text: s.text[start:s.pos]}
}

func (s *Scanner) scanGreater(start int) Token {
	s.advance() // skip >
	if s.peek() == '>' {
		s.advance()
		if s.peek() == '>' {
			s.advance()
			if s.peek() == '=' {
				s.advance()
				return Token{Kind: KindGreaterThanGreaterThanGreaterThanEqualsToken, TokenPos: start, Text: ">>>="}
			}
			return Token{Kind: KindGreaterThanGreaterThanGreaterThanToken, TokenPos: start, Text: ">>>"}
		}
		if s.peek() == '=' {
			s.advance()
			return Token{Kind: KindGreaterThanGreaterThanEqualsToken, TokenPos: start, Text: ">>="}
		}
		return Token{Kind: KindGreaterThanGreaterThanToken, TokenPos: start, Text: ">>"}
	}
	if s.peek() == '=' {
		s.advance()
		return Token{Kind: KindGreaterThanEqualsToken, TokenPos: start, Text: ">="}
	}
	return Token{Kind: KindGreaterThanToken, TokenPos: start, Text: ">"}
}

func (s *Scanner) scanNumber(start int) Token {
	if s.peek() == '0' {
		next := s.peekAt(1)
		if next == 'x' || next == 'X' {
			s.pos += 2
			s.scanHexDigits()
			return s.finishBigIntOrNumber(start)
		}
		if next == 'b' || next == 'B' {
			s.pos += 2
			s.scanBinaryDigits()
			return s.finishBigIntOrNumber(start)
		}
		if next == 'o' || next == 'O' {
			s.pos += 2
			s.scanOctalDigits()
			return s.finishBigIntOrNumber(start)
		}
	}

	s.scanDecimalDigits()
	if s.peek() == '.' {
		s.advance()
		s.scanDecimalDigits()
	}
	if s.peek() == 'e' || s.peek() == 'E' {
		s.advance()
		if s.peek() == '+' || s.peek() == '-' {
			s.advance()
		}
		s.scanDecimalDigits()
	}
	return s.finishBigIntOrNumber(start)
}

func (s *Scanner) finishBigIntOrNumber(start int) Token {
	if s.peek() == 'n' {
		s.advance()
		return Token{Kind: KindBigIntLiteral, TokenPos: start, Text: s.text[start:s.pos]}
	}
	return Token{Kind: KindNumericLiteral, TokenPos: start, Text: s.text[start:s.pos]}
}

func (s *Scanner) scanDecimalDigits() {
	for s.pos < len(s.text) {
		ch := s.text[s.pos]
		if (ch >= '0' && ch <= '9') || ch == '_' {
			s.pos++
		} else {
			break
		}
	}
}

func (s *Scanner) scanHexDigits() {
	for s.pos < len(s.text) {
		ch := s.text[s.pos]
		if (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f') || (ch >= 'A' && ch <= 'F') || ch == '_' {
			s.pos++
		} else {
			break
		}
	}
}

func (s *Scanner) scanBinaryDigits() {
	for s.pos < len(s.text) {
		ch := s.text[s.pos]
		if ch == '0' || ch == '1' || ch == '_' {
			s.pos++
		} else {
			break
		}
	}
}

func (s *Scanner) scanOctalDigits() {
	for s.pos < len(s.text) {
		ch := s.text[s.pos]
		if (ch >= '0' && ch <= '7') || ch == '_' {
			s.pos++
		} else {
			break
		}
	}
}

func (s *Scanner) scanIdentifierOrKeyword(start int) Token {
	for s.pos < len(s.text) {
		ch := s.text[s.pos]
		if isIdentChar(ch) {
			s.pos++
		} else if ch >= 0x80 {
			r, size := utf8.DecodeRuneInString(s.text[s.pos:])
			if r != utf8.RuneError && (unicode.IsLetter(r) || unicode.IsDigit(r) || r == '\u200C' || r == '\u200D') {
				s.pos += size
			} else {
				break
			}
		} else {
			break
		}
	}
	text := s.text[start:s.pos]
	if kind, ok := keywordKinds[text]; ok {
		return Token{Kind: kind, TokenPos: start, Text: text}
	}
	return Token{Kind: KindIdentifier, TokenPos: start, Text: text}
}

func (s *Scanner) scanPrivateIdentifier(start int) Token {
	s.advance() // skip #
	for s.pos < len(s.text) && isIdentChar(s.text[s.pos]) {
		s.pos++
	}
	return Token{Kind: KindPrivateIdentifier, TokenPos: start, Text: s.text[start:s.pos]}
}

func isIdentStartByte(ch byte) bool {
	return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_' || ch == '$'
}

func isIdentStart(ch byte) bool {
	return isIdentStartByte(ch)
}

func isIdentStartRune(r rune) bool {
	return unicode.IsLetter(r) || r == '_' || r == '$'
}

func isIdentChar(ch byte) bool {
	return isIdentStartByte(ch) || (ch >= '0' && ch <= '9')
}

// keywordKinds maps keyword text to TS7 SyntaxKind values.
// These start at KindBreakKeyword = 82.
var keywordKinds = map[string]int{
	"break":       82,
	"case":        83,
	"catch":       84,
	"class":       85,
	"const":       86,
	"continue":    87,
	"debugger":    88,
	"default":     89,
	"delete":      90,
	"do":          91,
	"else":        92,
	"enum":        93,
	"export":      94,
	"extends":     95,
	"false":       96,
	"finally":     97,
	"for":         98,
	"function":    99,
	"if":          100,
	"import":      101,
	"in":          102,
	"instanceof":  103,
	"new":         104,
	"null":        105,
	"return":      106,
	"super":       107,
	"switch":      108,
	"this":        109,
	"throw":       110,
	"true":        111,
	"try":         112,
	"typeof":      113,
	"var":         114,
	"void":        115,
	"while":       116,
	"with":        117,
	// Strict mode reserved words
	"implements":  118,
	"interface":   119,
	"let":         120,
	"package":     121,
	"private":     122,
	"protected":   123,
	"public":      124,
	"static":      125,
	"yield":       126,
	// Contextual keywords
	"abstract":    127,
	"accessor":    128,
	"as":          129,
	"asserts":     130,
	"assert":      131,
	"any":         132,
	"async":       133,
	"await":       134,
	"boolean":     135,
	"constructor": 136,
	"declare":     137,
	"get":         138,
	"immediate":   139,
	"infer":       140,
	"intrinsic":   141,
	"is":          142,
	"keyof":       143,
	"module":      144,
	"namespace":   145,
	"never":       146,
	"out":         147,
	"readonly":    148,
	"require":     149,
	"number":      150,
	"object":      151,
	"satisfies":   152,
	"set":         153,
	"string":      154,
	"symbol":      155,
	"type":        156,
	"undefined":   157,
	"unique":      158,
	"unknown":     159,
	"using":       160,
	"from":        161,
	"global":      162,
	"bigint":      163,
	"override":    164,
	"of":          165,
	"defer":       166,
}
