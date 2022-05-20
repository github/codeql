package main

import "testing"

func login(user, password string) bool {
	return true
}

func TestLogin(t *testing.T) {
	user := "testuser"
	password := "horsebatterystaplecorrect" // lgtm[go/hardcoded-credentials]
	if !login(user, password) {
		t.Errorf("Login test failed.")
	}
}
