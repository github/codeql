package util

import "os"

// Getenv retrieves the value of the environment variable named by the key.
// If that variable is not present, it iterates over the given aliases until
// it finds one that is. If none are present, the empty string is returned.
func Getenv(key string, aliases ...string) string {
	val := os.Getenv(key)
	if val != "" {
		return val
	}
	for _, alias := range aliases {
		val = os.Getenv(alias)
		if val != "" {
			return val
		}
	}
	return ""
}
