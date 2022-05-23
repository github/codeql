//go:build !linux
// +build !linux

package main

func dostuff() {
	panic("non-linux")
}
