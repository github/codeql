package main

import (
	"fmt"
	"net"

	"golang.org/x/crypto/ssh"
	"golang.org/x/crypto/ssh/knownhosts"
)

func insecureSSHClientConfig() {
	_ = &ssh.ClientConfig{
		User: "user",
		Auth: []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.HostKeyCallback( // BAD
			func(hostname string, remote net.Addr, key ssh.PublicKey) error {
				return nil
			}),
	}
}

func insecureSSHClientConfigAlt() {
	_ = &ssh.ClientConfig{
		User:            "user",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(), // BAD
	}
}

func insecureSSHClientConfigLocalFlow() {
	callback := ssh.HostKeyCallback(
		func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			return nil
		})

	_ = &ssh.ClientConfig{
		User:            "user",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: callback, // BAD
	}
}

func insecureSSHClientConfigLocalFlowAlt() {
	callback :=
		func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			return nil
		}

	_ = &ssh.ClientConfig{
		User:            "user",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.HostKeyCallback(callback), // BAD
	}
}

// Check that insecure and secure functions flowing together to the same
// sink is not flagged (we assume this is configurable security)
func potentialInsecureSSHClientConfig(callback ssh.HostKeyCallback) {
	_ = &ssh.ClientConfig{
		User:            "user",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: callback, // OK
	}
}

// Check that insecure and secure functions flowing to different writes to
// the same objects are not flagged (we assume this is configurable security)
func potentialInsecureSSHClientConfigTwoWrites(callback ssh.HostKeyCallback) {
	config := &ssh.ClientConfig{
		User:            "user",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: nil,
	}

	if callback == nil {
		config.HostKeyCallback = ssh.InsecureIgnoreHostKey() // OK
	} else {
		config.HostKeyCallback = callback
	}
}

// Check that insecure and secure functions flowing to different writes to
// the same objects are not flagged (we assume this is configurable security)
func potentialInsecureSSHClientConfigUsingKnownHosts(x bool) {
	config := &ssh.ClientConfig{
		User:            "user",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: nil,
	}

	if x {
		config.HostKeyCallback = ssh.InsecureIgnoreHostKey() // OK
	} else {
		callback, _ := knownhosts.New("somefile")
		config.HostKeyCallback = callback
	}
}

func main() {
	fmt.Printf("Hello insecure SSH client config!\n")

	insecureCallback := ssh.HostKeyCallback(
		func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			return nil
		})

	potentialInsecureSSHClientConfig(insecureCallback)

	potentiallySecureCallback := ssh.HostKeyCallback(
		func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			if hostname == "localhost" {
				return nil
			}
			return fmt.Errorf("ssh: Unexpected host for key")
		})

	potentialInsecureSSHClientConfig(potentiallySecureCallback)
	potentialInsecureSSHClientConfig(ssh.InsecureIgnoreHostKey())

	potentialInsecureSSHClientConfigTwoWrites(potentiallySecureCallback)
}
