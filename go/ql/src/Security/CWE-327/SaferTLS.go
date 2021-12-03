package main

import "crypto/tls"

func saferTLSConfig() {
	config := &tls.Config{}
	config.MinVersion = tls.VersionTLS12
	config.MaxVersion = tls.VersionTLS13
	// OR
	config.MaxVersion = 0 // GOOD: Setting MaxVersion to 0 means that the highest version available in the package will be used.
}
