// ⚡️ Fiber is an Express inspired web framework written in Go with ☕️
// 🤖 Github Repository: https://github.com/gofiber/fiber
// 📌 API Documentation: https://docs.gofiber.io

package utils

// ToLower is the equivalent of strings.ToLower
func ToLower(b string) string {
	var res = make([]byte, len(b))
	copy(res, b)
	for i := 0; i < len(res); i++ {
		res[i] = toLowerTable[res[i]]
	}

	return GetString(res)
}

// ToUpper is the equivalent of strings.ToUpper
func ToUpper(b string) string {
	var res = make([]byte, len(b))
	copy(res, b)
	for i := 0; i < len(res); i++ {
		res[i] = toUpperTable[res[i]]
	}

	return GetString(res)
}

// TrimLeft is the equivalent of strings.TrimLeft
func TrimLeft(s string, cutset byte) string {
	lenStr, start := len(s), 0
	for start < lenStr && s[start] == cutset {
		start++
	}
	return s[start:]
}

// Trim is the equivalent of strings.Trim
func Trim(s string, cutset byte) string {
	i, j := 0, len(s)-1
	for ; i < j; i++ {
		if s[i] != cutset {
			break
		}
	}
	for ; i < j; j-- {
		if s[j] != cutset {
			break
		}
	}

	return s[i : j+1]
}

// TrimRight is the equivalent of strings.TrimRight
func TrimRight(s string, cutset byte) string {
	lenStr := len(s)
	for lenStr > 0 && s[lenStr-1] == cutset {
		lenStr--
	}
	return s[:lenStr]
}

// DefaultString returns the provided fallback value if string is empty
func DefaultString(value string, defaultValue string) string {
	if len(value) <= 0 {
		return defaultValue
	}
	return value
}

// IfToLower returns an lowercase version of the input ASCII string.
//
// It first checks if the string contains any uppercase characters before converting it.
//
// For strings that are already lowercase,this function will be faster than `ToLower`.
//
// In the case of mixed-case or uppercase strings, this function will be slightly slower than `ToLower`.
func IfToLower(s string) string {
	hasUpper := false
	for i := 0; i < len(s); i++ {
		c := s[i]
		if toLowerTable[c] != c {
			hasUpper = true
			break
		}
	}

	if !hasUpper {
		return s
	}
	return ToLower(s)
}

// IfToUpper returns an uppercase version of the input ASCII string.
//
// It first checks if the string contains any lowercase characters before converting it.
//
// For strings that are already uppercase,this function will be faster than `ToUpper`.
//
// In the case of mixed-case or lowercase strings, this function will be slightly slower than `ToUpper`.
func IfToUpper(s string) string {
	hasLower := false
	for i := 0; i < len(s); i++ {
		c := s[i]
		if toUpperTable[c] != c {
			hasLower = true
			break
		}
	}

	if !hasLower {
		return s
	}
	return ToUpper(s)
}
