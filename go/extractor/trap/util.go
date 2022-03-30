package trap

import (
	"strings"
)

func escapeString(s string) string {
	return strings.Replace(s, "\"", "\"\"", -1)
}
