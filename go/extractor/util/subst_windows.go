//go:build windows

package util

import (
	"os"
	"path/filepath"
	"syscall"
	"unsafe"

	"golang.org/x/sys/windows"
)

var (
	dll         *syscall.DLL
	procResolve *syscall.Proc
	procFree    *syscall.Proc
	available   bool
)

func init() {
	dist := os.Getenv("CODEQL_DIST")
	if dist == "" {
		return
	}
	dllPath := filepath.Join(dist, "tools", "win64", "canonicalize.dll")
	d, err := syscall.LoadDLL(dllPath)
	if err != nil {
		return
	}
	p, err := d.FindProc("resolve_subst")
	if err != nil {
		d.Release()
		return
	}
	f, err := d.FindProc("resolve_subst_free")
	if err != nil {
		d.Release()
		return
	}
	dll = d
	procResolve = p
	procFree = f
	available = true
}

// If "path" is an absolute path starting with a "subst"ed drive letter, return an
// equivalent path with the drive letter replaced by its target. Otherwise return
// "path" unchanged.
func ResolvePath(path string) string {
	if len(path) < 3 {
		return path
	}
	if path[1] != ':' {
		return path
	}
	if path[2] != '\\' && path[2] != '/' {
		return path
	}
	c := path[0]
	if !((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
		return path
	}

	resolved, ok := resolveDrive(path[:3])
	if !ok {
		return path
	}
	return resolved + path[2:]
}

// Given a drive root like "X:\" (or "X:/"), returns the path that drive is
// "subst"ed to. Returns false if the drive is not "subst"ed or an error occurred.
func resolveDrive(driveRoot string) (string, bool) {
	if !available {
		return "", false
	}
	driveBytes, err := windows.ByteSliceFromString(driveRoot)
	if err != nil {
		return "", false
	}
	ret, _, _ := procResolve.Call(uintptr(unsafe.Pointer(&driveBytes[0])))
	if ret == 0 {
		return "", false
	}
	result := windows.BytePtrToString((*byte)(unsafe.Pointer(ret)))
	if procFree != nil {
		procFree.Call(ret)
	}
	return result, true
}
