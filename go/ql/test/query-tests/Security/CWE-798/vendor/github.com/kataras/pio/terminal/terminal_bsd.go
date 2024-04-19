//go:build (darwin || freebsd || openbsd || netbsd || dragonfly) && !appengine
// +build darwin freebsd openbsd netbsd dragonfly
// +build !appengine

package terminal

import "syscall"

const ioctlReadTermios = syscall.TIOCGETA

type Termios syscall.Termios
