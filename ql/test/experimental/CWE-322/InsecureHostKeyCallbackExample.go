package main

import "net"
import "fmt"
import "golang.org/x/crypto/ssh"

func insecureSSHClientConfig() {
	_ = &ssh.ClientConfig{
		User: "user",
		Auth: []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.HostKeyCallback(
			func(hostname string, remote net.Addr, key ssh.PublicKey) error {
				 return nil
		}),
	 }
}

func insecureSSHClientConfigAlt() {
	_ = &ssh.ClientConfig{
		User: "user",
		Auth: []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	 }
}

func insecureSSHClientConfigLocalFlow() {
	callback := ssh.HostKeyCallback(
		func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			 return nil
	})

	_ = &ssh.ClientConfig{
		User: "user",
		Auth: []ssh.AuthMethod{nil},
		HostKeyCallback: callback,
	 }
}

func insecureSSHClientConfigLocalFlowAlt() {
	callback := 
		func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			 return nil
	};

	_ = &ssh.ClientConfig{
		User: "user",
		Auth: []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.HostKeyCallback(callback),
	 }
}

func potentialInsecureSSHClientConfig(callback ssh.HostKeyCallback) {
	_ = &ssh.ClientConfig{
		User: "user",
		Auth: []ssh.AuthMethod{nil},
		HostKeyCallback: callback,
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
}