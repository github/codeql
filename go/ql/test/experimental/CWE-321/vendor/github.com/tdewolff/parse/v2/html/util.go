package html

var (
	singleQuoteEntityBytes = []byte("&#39;")
	doubleQuoteEntityBytes = []byte("&#34;")
)

// EscapeAttrVal returns the escaped attribute value bytes with quotes. Either single or double quotes are used, whichever is shorter. If there are no quotes present in the value and the value is in HTML (not XML), it will return the value without quotes.
func EscapeAttrVal(buf *[]byte, b []byte, origQuote byte, mustQuote, isXML bool) []byte {
	singles := 0
	doubles := 0
	unquoted := true
	for _, c := range b {
		if charTable[c] {
			unquoted = false
			if c == '"' {
				doubles++
			} else if c == '\'' {
				singles++
			}
		}
	}
	if unquoted && (!mustQuote || origQuote == 0) && !isXML {
		return b
	} else if singles == 0 && origQuote == '\'' && !isXML || doubles == 0 && origQuote == '"' {
		if len(b)+2 > cap(*buf) {
			*buf = make([]byte, 0, len(b)+2)
		}
		t := (*buf)[:len(b)+2]
		t[0] = origQuote
		copy(t[1:], b)
		t[1+len(b)] = origQuote
		return t
	}

	n := len(b) + 2
	var quote byte
	var escapedQuote []byte
	if singles >= doubles || isXML {
		n += doubles * 4
		quote = '"'
		escapedQuote = doubleQuoteEntityBytes
		if singles == doubles && origQuote == '\'' && !isXML {
			quote = '\''
			escapedQuote = singleQuoteEntityBytes
		}
	} else {
		n += singles * 4
		quote = '\''
		escapedQuote = singleQuoteEntityBytes
	}
	if n > cap(*buf) {
		*buf = make([]byte, 0, n) // maximum size, not actual size
	}
	t := (*buf)[:n] // maximum size, not actual size
	t[0] = quote
	j := 1
	start := 0
	for i, c := range b {
		if c == quote {
			j += copy(t[j:], b[start:i])
			j += copy(t[j:], escapedQuote)
			start = i + 1
		}
	}
	j += copy(t[j:], b[start:])
	t[j] = quote
	return t[:j+1]
}

var charTable = [256]bool{
	// ASCII
	false, false, false, false, false, false, false, false,
	false, true, true, false, true, true, false, false, // tab, line feed, form feed, carriage return
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	true, false, true, false, false, false, false, true, // space, "), '
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, true, true, true, false, // <, =, >

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	true, false, false, false, false, false, false, false, // `
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	// non-ASCII
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
}
