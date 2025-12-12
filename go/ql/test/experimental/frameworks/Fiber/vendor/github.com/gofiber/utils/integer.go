// ⚡️ Fiber is an Express inspired web framework written in Go with ☕️
// 🤖 Github Repository: https://github.com/gofiber/fiber
// 📌 API Documentation: https://docs.gofiber.io

package utils

// DefaultINT returns the provided fallback value if int is 0 or lower
func DefaultINT(value int, defaultValue int) int {
	if value <= 0 {
		return defaultValue
	}
	return value
}
