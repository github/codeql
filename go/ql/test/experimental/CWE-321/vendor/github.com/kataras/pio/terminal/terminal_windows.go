//go:build windows && !appengine
// +build windows,!appengine

package terminal

import (
	"bytes"
	"errors"
	"io"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"syscall"
	"unsafe"
)

var kernel32 = syscall.NewLazyDLL("kernel32.dll")

var (
	procGetConsoleMode = kernel32.NewProc("GetConsoleMode")
	procSetConsoleMode = kernel32.NewProc("SetConsoleMode")
)

const (
	enableProcessedOutput           = 0x0001
	enableWrapAtEolOutput           = 0x0002
	enableVirtualTerminalProcessing = 0x0004
)

func getVersion() (float64, int, error) {
	stdout, stderr := &bytes.Buffer{}, &bytes.Buffer{}
	cmd := exec.Command("cmd", "ver")
	cmd.SysProcAttr = &syscall.SysProcAttr{HideWindow: true}
	cmd.Stdout = stdout
	cmd.Stderr = stderr
	err := cmd.Run()
	if err != nil {
		return -1, -1, err
	}

	errCanNotDetermineVersion := errors.New("can't determine Windows version")
	lines := stdout.String()
	start := strings.IndexByte(lines, '[')
	end := strings.IndexByte(lines, ']')
	if start == -1 || end == -1 {
		return -1, -1, errCanNotDetermineVersion
	}

	winLine := lines[start+1 : end]
	if len(winLine) < 10 {
		return -1, -1, errCanNotDetermineVersion
	}
	// Version 10.0.15063
	versionsLine := winLine[strings.IndexByte(winLine, ' ')+1:]
	// 10.0.15063
	versionSems := strings.Split(versionsLine, ".")
	// 10
	// 0
	// 15063
	if len(versionSems) < 3 {
		return -1, -1, errCanNotDetermineVersion
	}

	buildNumber, _ := strconv.Atoi(versionSems[2])
	major, err := strconv.ParseFloat(versionSems[0], 64)
	return major, buildNumber, err
}

func init() { // modifies the "SupportColors" package-level variable.
	SupportColors = false

	major, buildNumber, err := getVersion()
	if err != nil {
		return
	}

	// Activate Virtual Processing for Windows CMD
	// Info: https://msdn.microsoft.com/en-us/library/windows/desktop/ms686033(v=vs.85).aspx
	if major >= 10 {
		handle := syscall.Handle(os.Stderr.Fd())
		procSetConsoleMode.Call(uintptr(handle), enableProcessedOutput|enableWrapAtEolOutput|enableVirtualTerminalProcessing)

		// check specific for windows operating system
		// versions, after windows 10 microsoft
		// gave support for 256-color console.
		SupportColors = buildNumber >= 10586
	}
}

// IsTerminal returns true if stderr's file descriptor is a terminal.
func IsTerminal(f io.Writer) bool {
	switch v := f.(type) {
	case *os.File:
		var st uint32
		r, _, e := syscall.Syscall(procGetConsoleMode.Addr(), 2, uintptr(v.Fd()), uintptr(unsafe.Pointer(&st)), 0)
		return r != 0 && e == 0
	default:
		return false
	}
}
