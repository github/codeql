//go:build !appengine
// +build !appengine

package terminal

import "syscall"

const ioctlReadTermios = syscall.TCGETS

type Termios syscall.Termios
