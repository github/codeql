//go:build !windows

package subst

// ResolveDrive is a no-op on non-Windows platforms.
func ResolveDrive(driveRoot string) string { return "" }
