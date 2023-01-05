package test

import (
	"log"
	"os"
)

func openFileWrite(filename string) (*os.File, error) {
	f, err := os.OpenFile(filename, os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666)
	return f, err
}

func openFileRead(filename string) (*os.File, error) {
	return os.OpenFile(filename, os.O_RDONLY|os.O_CREATE, 0666)
}

func openFileReadWrite(filename string) (*os.File, error) {
	return os.OpenFile(filename, os.O_RDWR|os.O_TRUNC|os.O_CREATE, 0666)
}

func closeFileDeferred(f *os.File) {
	defer f.Close() // NOT OK, if `f` is writable
}

func closeFileDeferredIndirect(f *os.File) {
	var cont = func() {
		f.Close() // NOT OK, if `f` is writable
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
	if f, err := openFileWrite("foo.txt"); err != nil {
		closeFileDeferred(f)         // NOT OK
		closeFileDeferredIndirect(f) // NOT OK
	}

	if f, err := openFileRead("foo.txt"); err != nil {
		closeFileDeferred(f)         // OK
		closeFileDeferredIndirect(f) // OK
	}

	if f, err := openFileReadWrite("foo.txt"); err != nil {
		closeFileDeferred(f)         // NOT OK
		closeFileDeferredIndirect(f) // NOT OK
	}
}

func notDeferred() {
	if f, err := openFileWrite("foo.txt"); err != nil {
		// the handle is write-only and we don't check if `Close` succeeds
		f.Close() // NOT OK
	}

	if f, err := openFileRead("foo.txt"); err != nil {
		// the handle is read-only, so this is ok
		f.Close() // OK
	}

	if f, err := openFileReadWrite("foo.txt"); err != nil {
		// the handle is read-write and we don't check if `Close` succeeds
		f.Close() // NOT OK
	}
}

func foo() error {
	if f, err := openFileWrite("foo.txt"); err != nil {
		// the result of the call to `Close` is returned to the caller
		return f.Close() // OK
	}

	return nil
}

func isSyncedFirst() {
	if f, err := openFileWrite("foo.txt"); err != nil {
		// we have a call to `Sync` and check whether it was successful before proceeding
		if err := f.Sync(); err != nil {
			f.Close() // OK
		}
		f.Close() // OK
	}
}

func deferredCloseWithSync() {
	if f, err := openFileWrite("foo.txt"); err != nil {
		// a call to `Close` is deferred, but we have a call to `Sync` later which
		// precedes the call to `Close` during execution
		defer f.Close() // OK

		if err := f.Sync(); err != nil {
			log.Fatal(err)
		}
	}
}

func deferredCloseWithSyncEarlyReturn(n int) {
	if f, err := openFileWrite("foo.txt"); err != nil {
		// a call to `Close` is deferred
		defer f.Close() // NOT OK

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
	if f, err := openFileWrite("foo.txt"); err != nil {
		// we have a call to `Sync` which precedes the call to `Close`, but there is no check
		// to see if `Sync` may have failed
		f.Sync()
		f.Close() // NOT OK
	}
}
