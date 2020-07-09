package main

import (
	"golang.org/x/crypto/ssh"
	"io/ioutil"
)

func main() {}

func secureHostKeyCallback() {
	publicKeyBytes, _ := ioutil.ReadFile("allowed_hostkey.pub")
	publicKey, _ := ssh.ParsePublicKey(publicKeyBytes)

	_ = &ssh.ClientConfig{
		User:            "username",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.FixedHostKey(publicKey),
	}
}
