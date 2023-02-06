package main

import (
	"crypto/tls"
	"net/http"
)

func bad1(cfg *tls.Config) {
	cfg.InsecureSkipVerify = true // NOT OK
}

func good1(cfg *tls.Config) {
	cfg.InsecureSkipVerify = false // OK
}

type opts struct {
	mode string
}

func (opts) validateCertificates() bool { return true }

func (opts) get(option string) (bool, error) { return true, nil }

func good2(cfg *tls.Config, secure, selfCert, selfSign bool, options *opts, trustCertificates *bool,
	enableVerification interface{}, disableVerification bool) {
	if !secure {
		cfg.InsecureSkipVerify = true // OK
	}
	if selfCert {
		cfg.InsecureSkipVerify = true // OK
	}
	if selfSign {
		cfg.InsecureSkipVerify = true // OK
	}
	if !options.validateCertificates() {
		cfg.InsecureSkipVerify = true // OK
	}
	if v, _ := options.get("verifyCertificates"); !v {
		cfg.InsecureSkipVerify = true // OK
	}
	if *trustCertificates {
		cfg.InsecureSkipVerify = true // OK
	}
	if !enableVerification.(bool) {
		cfg.InsecureSkipVerify = true // OK
	}
	if options.mode == "disableVerification" {
		cfg.InsecureSkipVerify = true // OK
	}
}

func makeInsecureConfig() *tls.Config {
	return &tls.Config{InsecureSkipVerify: true} // OK
}

func makeConfig() *tls.Config {
	return &tls.Config{InsecureSkipVerify: true} // NOT OK
}

func bad3() *http.Transport {
	transport := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, // NOT OK
	}
	return transport
}

func good3() *http.Transport {
	insecureTransport := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, // OK
	}
	return insecureTransport
}
