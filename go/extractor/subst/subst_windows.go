//go:build windows

package subst

import (
	"os"
	"path/filepath"
	"syscall"
	"unsafe"
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
	p, err := d.FindProc("resolve_subst_u8")
	if err != nil {
		return
	}
	f, _ := d.FindProc("resolve_subst_free_u8")
	dll = d
	procResolve = p
	procFree = f
	available = true
}

// ResolveDrive resolves a subst'd drive root (e.g. "X:\") to its backing path.
// Returns "" if the drive is not subst'd or on error.
func ResolveDrive(driveRoot string) string {
	if !available {
		return ""
	}
	driveBytes := append([]byte(driveRoot), 0)
	ret, _, _ := procResolve.Call(uintptr(unsafe.Pointer(&driveBytes[0])))
	if ret == 0 {
		return ""
	}
	result := goString((*byte)(unsafe.Pointer(ret)))
	if procFree != nil {
		procFree.Call(ret)
	}
	return result
}

func goString(p *byte) string {
	if p == nil {
		return ""
	}
	var n int
	for ptr := unsafe.Pointer(p); *(*byte)(ptr) != 0; n++ {
		ptr = unsafe.Add(ptr, 1)
	}
	return string(unsafe.Slice(p, n))
}
