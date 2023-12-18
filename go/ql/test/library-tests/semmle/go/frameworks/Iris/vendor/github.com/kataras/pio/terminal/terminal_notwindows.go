//go:build (linux || darwin || freebsd || openbsd || netbsd || dragonfly) && !appengine
// +build linux darwin freebsd openbsd netbsd dragonfly
// +build !appengine

package terminal

import (
	"io"
	"os"
	"syscall"
	"unsafe"
)

// IsTerminal returns true if stderr's file descriptor is a terminal.
func IsTerminal(f io.Writer) bool {
	var termios Termios
	switch v := f.(type) {
	case *os.File:
		_, _, err := syscall.Syscall6(syscall.SYS_IOCTL, uintptr(v.Fd()), ioctlReadTermios, uintptr(unsafe.Pointer(&termios)), 0, 0, 0)
		return err == 0
	default:
		return false
	}
}
