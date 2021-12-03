package trap

import (
	"strings"
	"testing"
)

const (
	asciiChar  = "*"
	bmpChar    = "\u2028"
	nonBmpChar = "\U000101d0"
)

func TestCapStringLength(t *testing.T) {
	// test simple cases only involving ASCII characters
	short := strings.Repeat(asciiChar, max_strlen-1)
	if capStringLength(short) != short {
		t.Errorf("Strings shorter than maximum length should not be truncated")
	}

	short = strings.Repeat(asciiChar, max_strlen)
	if capStringLength(short) != short {
		t.Errorf("Strings no longer than maximum length should not be truncated")
	}

	long := strings.Repeat(asciiChar, max_strlen+1)
	if capStringLength(long) != long[0:max_strlen] {
		t.Errorf("Strings longer than maximum length should be truncated")
	}

	// test chopping off non-ASCII characters
	prefix := strings.Repeat(asciiChar, max_strlen)
	long = prefix + bmpChar
	if capStringLength(long) != prefix {
		t.Errorf("BMP character after max_strlen should be correctly chopped off")
	}

	prefix = strings.Repeat(asciiChar, max_strlen)
	long = prefix + nonBmpChar
	if capStringLength(long) != prefix {
		t.Errorf("Non-BMP character after max_strlen should be correctly chopped off")
	}

	prefix = strings.Repeat(asciiChar, max_strlen-(len(bmpChar)-1))
	long = prefix + bmpChar
	if capStringLength(long) != prefix {
		t.Errorf("BMP character straddling max_strlen should be correctly chopped off")
	}

	prefix = strings.Repeat(asciiChar, max_strlen-(len(nonBmpChar)-1))
	long = prefix + nonBmpChar
	if capStringLength(long) != prefix {
		t.Errorf("Non-BMP character straddling max_strlen should be correctly chopped off")
	}

	// test preserving non-ASCII characters that just about fit
	prefix = strings.Repeat(asciiChar, max_strlen-len(bmpChar))
	short = prefix + bmpChar
	if capStringLength(short) != short {
		t.Errorf("BMP character before max_strlen should be correctly preserved")
	}

	prefix = strings.Repeat(asciiChar, max_strlen-len(nonBmpChar))
	short = prefix + nonBmpChar
	if capStringLength(short) != short {
		t.Errorf("Non-BMP character before max_strlen should be correctly preserved")
	}
}
