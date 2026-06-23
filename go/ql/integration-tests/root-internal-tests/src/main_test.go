package main

import "testing"

// Root internal test - tests private functions
func TestPrivateFunc(t *testing.T) {
	if privateFunc() != 24 {
		t.Error("privateFunc failed")
	}
}

func TestPublicFunc(t *testing.T) {
	if PublicFunc() != 42 {
		t.Error("PublicFunc failed")
	}
}
