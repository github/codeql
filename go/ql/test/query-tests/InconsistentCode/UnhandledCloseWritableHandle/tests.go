package test

import (
	"io"
	"log"
	"os"
)

func closeFileDeferred(f *os.File) {
	defer f.Close() // $ Alert=w Alert=rw
}

func closeFileDeferredIndirect(f *os.File) {
	var cont = func() {
		f.Close() // $ Alert=w Alert=rw
	}

	defer cont()
}

func closeFileDeferredIndirectReturn(f *os.File) {
	var cont = func() error {
		return f.Close() // OK, because this function returns the error
	}

	// different (more general) problem: deferred error
	defer cont()
}

func deferredCalls() {
	// open file for writing
	if f, err := os.OpenFile("foo.txt", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666); err != nil { // $ Source=w
		closeFileDeferred(f)               // NOT OK
		closeFileDeferredIndirect(f)       // NOT OK
		closeFileDeferredIndirectReturn(f) // OK - the error is not discarded at the call to Close (though it is discarded later)
	}

	// open file for reading
	if f, err := os.OpenFile("foo.txt", os.O_RDONLY|os.O_CREATE, 0666); err != nil {
		closeFileDeferred(f)               // OK
		closeFileDeferredIndirect(f)       // OK
		closeFileDeferredIndirectReturn(f) // OK
	}

	// open file for reading and writing
	if f, err := os.OpenFile("foo.txt", os.O_RDWR|os.O_TRUNC|os.O_CREATE, 0666); err != nil { // $ Source=rw
		closeFileDeferred(f)               // NOT OK
		closeFileDeferredIndirect(f)       // NOT OK
		closeFileDeferredIndirectReturn(f) // OK - the error is not discarded at the call to Close (though it is discarded later)
	}
}

func notDeferred() {
	// open file for writing
	if f, err := os.OpenFile("foo.txt", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666); err != nil { // $ Source
		// the handle is write-only and we don't check if `Close` succeeds
		f.Close() // $ Alert
	}

	// open file for reading
	if f, err := os.OpenFile("foo.txt", os.O_RDONLY|os.O_CREATE, 0666); err != nil {
		// the handle is read-only, so this is ok
		f.Close() // OK
	}

	// open file for reading and writing
	if f, err := os.OpenFile("foo.txt", os.O_RDWR|os.O_TRUNC|os.O_CREATE, 0666); err != nil { // $ Source
		// the handle is read-write and we don't check if `Close` succeeds
		f.Close() // $ Alert
	}
}

func foo() error {
	// open file for writing
	if f, err := os.OpenFile("foo.txt", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666); err != nil {
		// the result of the call to `Close` is returned to the caller
		return f.Close() // OK
	}

	return nil
}

func isSyncedFirst() {
	// open file for writing
	if f, err := os.OpenFile("foo.txt", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666); err != nil {
		// we have a call to `Sync` and check whether it was successful before proceeding
		if err := f.Sync(); err != nil {
			f.Close() // OK
		}
		f.Close() // OK
	}
}

func deferredCloseWithSync() {
	// open file for writing
	if f, err := os.OpenFile("foo.txt", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666); err != nil {
		// a call to `Close` is deferred, but we have a call to `Sync` later which
		// precedes the call to `Close` during execution
		defer f.Close() // OK

		if err := f.Sync(); err != nil {
			log.Fatal(err)
		}
	}
}

func deferredCloseWithSyncEarlyReturn(n int) {
	// open file for writing
	if f, err := os.OpenFile("foo.txt", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666); err != nil { // $ Source
		// a call to `Close` is deferred
		defer f.Close() // $ Alert

		if n > 100 {
			return
		}

		// we have a call to `Sync` here, but it might not get executed if n <= 100
		if err := f.Sync(); err != nil {
			log.Fatal(err)
		}
	}
}

func unhandledSync() {
	// open file for writing
	if f, err := os.OpenFile("foo.txt", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666); err != nil { // $ Source
		// we have a call to `Sync` which precedes the call to `Close`, but there is no check
		// to see if `Sync` may have failed
		f.Sync()
		f.Close() // $ Alert
	}
}

func returnedSync() error {
	// open file for writing
	f, err := os.OpenFile("foo.txt", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666)
	if err != nil {
		// we have a call to `Sync` which precedes the call to `Close`, but there is no check
		// to see if `Sync` may have failed
		return err
	}
	defer f.Close()
	return f.Sync()
}

func copyFile(destFile string, mode os.FileMode, src io.Reader) error {
	f, err := os.OpenFile(destFile, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, mode) // $ Source
	if err != nil {
		return err
	}
	defer f.Close() // $ SPURIOUS: Alert

	_, err = io.Copy(f, src)
	if err != nil {
		return err
	}
	return f.Sync()
}
