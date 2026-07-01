//go:build windows

package canonicalize

import (
	"os"
	"path/filepath"
	"syscall"
	"unsafe"
)

var (
	dll              *syscall.DLL
	procCanonicalize *syscall.Proc
	procFree         *syscall.Proc
	available        bool
)

func init() {
	dist := os.Getenv("CODEQL_DIST")
	if dist == "" {
		return
	}
	dllPath := filepath.Join(dist, "tools", "win64", "codeql_canonical_path.dll")
	d, err := syscall.LoadDLL(dllPath)
	if err != nil {
		return
	}
	p, err := d.FindProc("canonicalize_path_u8")
	if err != nil {
		return
	}
	f, _ := d.FindProc("canonicalize_free_u8")
	dll = d
	procCanonicalize = p
	procFree = f
	available = true
}

func CanonicalizePath(path string) string {
	if !available {
		return path
	}
	pathBytes := append([]byte(path), 0)
	ret, _, _ := procCanonicalize.Call(uintptr(unsafe.Pointer(&pathBytes[0])))
	if ret == 0 {
		return path
	}
	result := bytePtrToString((*byte)(unsafe.Pointer(ret)))
	if procFree != nil {
		procFree.Call(ret)
	}
	return result
}

func bytePtrToString(p *byte) string {
	if p == nil {
		return ""
	}
	var n int
	for ptr := unsafe.Pointer(p); *(*byte)(ptr) != 0; n++ {
		ptr = unsafe.Add(ptr, 1)
	}
	return string(unsafe.Slice(p, n))
}
