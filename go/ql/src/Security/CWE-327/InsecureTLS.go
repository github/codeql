package main

import (
	"crypto/tls"
)

func main() {}

func insecureMinMaxTlsVersion() {
	{
		config := &tls.Config{}
		config.MinVersion = 0 // BAD: Setting the MinVersion to 0 equals to choosing the lowest supported version (i.e. SSL3.0)
	}
	{
		config := &tls.Config{}
		config.MinVersion = tls.VersionSSL30 // BAD: SSL 3.0 is a non-secure version of the protocol; it's not safe to use it as MinVersion.
	}
	{
		config := &tls.Config{}
		config.MaxVersion = tls.VersionSSL30 // BAD: SSL 3.0 is a non-secure version of the protocol; it's not safe to use it as MaxVersion.
	}
}

func insecureCipherSuites() {
	config := &tls.Config{
		CipherSuites: []uint16{
			tls.TLS_RSA_WITH_RC4_128_SHA, // BAD: TLS_RSA_WITH_RC4_128_SHA is one of the non-secure cipher suites; it's not safe to be used.
		},
	}
	_ = config
}
