package main

import (
	"crypto/tls"
	"os"
)

func main() {}

func insecureFunc() bool {
	return len(os.Args) > 5
}

func oldVersionFunc() bool {
	return len(os.Args) < 7
}

func minMaxTlsVersion() {
	{
		config := &tls.Config{}
		config.MinVersion = 0 // BAD
	}
	{
		config := &tls.Config{}
		config.MaxVersion = 0 // GOOD
	}
	///
	{
		config := &tls.Config{
			MinVersion: 0, // BAD
		}
		_ = config
	}
	{
		config := &tls.Config{
			MaxVersion: 0, // GOOD
		}
		_ = config
	}
	///
	{
		config := &tls.Config{}
		config.MinVersion = tls.VersionSSL30 // BAD
	}
	{
		config := &tls.Config{}
		config.MaxVersion = tls.VersionSSL30 // BAD
	}
	///
	{
		config := &tls.Config{}
		config.MinVersion = tls.VersionTLS10 // BAD
	}
	{
		config := &tls.Config{}
		config.MaxVersion = tls.VersionTLS10 // BAD
	}
	///
	{
		config := &tls.Config{}
		config.MinVersion = tls.VersionTLS11 // BAD
	}
	{
		config := &tls.Config{}
		config.MaxVersion = tls.VersionTLS11 // BAD
	}
	///
	{
		config := &tls.Config{
			MinVersion: tls.VersionTLS11, // BAD
		}
		_ = config
	}
	{
		config := &tls.Config{
			MaxVersion: tls.VersionTLS11, // BAD
		}
		_ = config
	}
	{
		config := &tls.Config{
			MinVersion: tls.VersionTLS12, // GOOD
		}
		_ = config
	}
	{
		config := &tls.Config{
			MaxVersion: tls.VersionTLS13, // GOOD
		}
		_ = config
	}
	///
	{
		config := &tls.Config{
			MinVersion: 0x0300, // BAD
		}
		_ = config
	}
	{
		config := &tls.Config{
			MaxVersion: 0x0301, // BAD
		}
		_ = config
	}
	///
	unknown := len(os.Args) > 1
	insecureFlag := len(os.Args) > 2
	oldVersionFlag := len(os.Args) > 3
	if unknown {
		config := &tls.Config{
			MinVersion: 0, // BAD
		}
		_ = config
	}
	if insecureFlag {
		config := &tls.Config{
			MinVersion: 0, // OK (guarded by a flag suggesting deliberate insecurity)
		}
		_ = config
	}
	if oldVersionFlag {
		config := &tls.Config{
			MinVersion: 0, // OK (guarded by a flag suggesting deliberate legacy support)
		}
		_ = config
	}
	///
	{
		var version uint16
		if unknown {
			version = tls.VersionTLS13
		} else {
			version = tls.VersionSSL30 // OK (flows together with a modern version, suggesting configurable security)
		}
		config := &tls.Config{
			MinVersion: version,
		}
		_ = config
	}
	///
	{
		var config tls.Config
		if unknown {
			config.MinVersion = tls.VersionTLS13
		} else {
			config.MinVersion = tls.VersionSSL30 // OK (flows together with a modern version, suggesting configurable security)
		}
		_ = config
	}
	///
	{
		var config *tls.Config = &tls.Config{}
		if unknown {
			config.MinVersion = tls.VersionTLS13
		} else {
			config.MinVersion = tls.VersionSSL30 // OK (flows together with a modern version, suggesting configurable security)
		}
		_ = config
	}
	///
	{
		insecureConfig := &tls.Config{
			MinVersion: 0, // OK (var name suggests deliberate insecurity)
		}
		_ = insecureConfig
	}
	///
	{
		legacyConfig := &tls.Config{
			MinVersion: 0, // OK (var name suggests deliberate legacy support)
		}
		_ = legacyConfig
	}
	///
	{
		var insecureConfig tls.Config
		insecureConfig.MinVersion = 0 // OK (var name suggests deliberate insecurity)
		_ = insecureConfig
	}
	///
	{
		var legacyConfig tls.Config
		legacyConfig.MinVersion = 0 // OK (var name suggests deliberate legacy support)
		_ = legacyConfig
	}
	///
	{
		switch unknown {
		case oldVersionFlag:
			config := &tls.Config{
				MinVersion: 0, // OK (switch-case name suggests legacy support)
			}
			_ = config
		case insecureFlag:
			config := &tls.Config{
				MinVersion: 0, // OK (switch-case name suggests insecurity)
			}
			_ = config
		default:
			config := &tls.Config{
				MinVersion: 0, // BAD
			}
			_ = config
		}

		switch os.Args[0] {
		case "oldVersionFlag":
			config := &tls.Config{
				MinVersion: 0, // OK (switch-case name suggests legacy support)
			}
			_ = config
		case "insecureFlag":
			config := &tls.Config{
				MinVersion: 0, // OK (switch-case name suggests insecurity)
			}
			_ = config
		default:
			config := &tls.Config{
				MinVersion: 0, // BAD
			}
			_ = config
		}
	}
	///
	if insecureFunc() {
		config := &tls.Config{
			MinVersion: 0, // OK (guarded by function call suggesting deliberate insecurity)
		}
		_ = config
	}
	///
	var isInsecure bool = insecureFunc()
	isInsecurePtr := &isInsecure
	if *isInsecurePtr {
		config := &tls.Config{
			MinVersion: 0, // OK (guarded by pointer deref suggesting deliberate insecurity)
		}
		_ = config
	}
	///
	if os.Getenv("DISABLE_TLS_VERIFICATION") == "true" {
		config := &tls.Config{
			MinVersion: 0, // OK (guarded by environment variable)
		}
		_ = config
	}
	///
	if isInsecure == true {
		config := &tls.Config{
			MinVersion: 0, // OK (guarded by comparison)
		}
		_ = config
	}
}

func cipherSuites() {
	{
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_RSA_WITH_RC4_128_SHA,                // BAD
				tls.TLS_RSA_WITH_AES_128_CBC_SHA256,         // BAD
				tls.TLS_ECDHE_ECDSA_WITH_RC4_128_SHA,        // BAD
				tls.TLS_ECDHE_RSA_WITH_RC4_128_SHA,          // BAD
				tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // BAD
				tls.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,   // BAD
			},
		}
		_ = config
	}
	{
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_RSA_WITH_RC4_128_SHA, // BAD
			},
		}
		_ = config
	}
	{
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_RSA_WITH_AES_128_CBC_SHA256, // BAD
			},
		}
		_ = config
	}
	{
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_ECDSA_WITH_RC4_128_SHA, // BAD
			},
		}
		_ = config
	}
	{
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_RSA_WITH_RC4_128_SHA, // BAD
			},
		}
		_ = config
	}
	{
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // BAD
			},
		}
		_ = config
	}
	{
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, // BAD
			},
		}
		_ = config
	}
	{
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_CHACHA20_POLY1305_SHA256, // GOOD
			},
		}
		_ = config
	}
	{
		config := &tls.Config{}
		config.CipherSuites = make([]uint16, 0)
		config.CipherSuites = append(config.CipherSuites, tls.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) // BAD
	}
	{
		config := &tls.Config{}
		config.CipherSuites = make([]uint16, 0)
		suites := tls.InsecureCipherSuites()
		for _, v := range suites {
			config.CipherSuites = append(config.CipherSuites, v.ID) // BAD
		}
	}
	{
		config := &tls.Config{}
		cipherSuites := make([]uint16, 0)
		suites := tls.InsecureCipherSuites()
		for _, v := range suites {
			cipherSuites = append(cipherSuites, v.ID)
		}
		config.CipherSuites = cipherSuites // BAD
	}
	{
		config := &tls.Config{}
		cipherSuites := make([]uint16, 0)
		suites := tls.InsecureCipherSuites()
		for i := range suites {
			cipherSuites = append(cipherSuites, suites[i].ID)
		}
		config.CipherSuites = cipherSuites // BAD
	}
	unknown := len(os.Args) > 1
	insecureFlag := len(os.Args) > 2
	oldVersionFlag := len(os.Args) > 3
	if unknown {
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // BAD
			},
		}
		_ = config
	}
	if insecureFlag {
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (guarded by a flag suggesting deliberate insecurity)
			},
		}
		_ = config
	}
	if oldVersionFlag {
		config := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (guarded by a flag suggesting deliberate legacy support)
			},
		}
		_ = config
	}
	{
		insecureConfig := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (var name suggests deliberate insecurity)
			},
		}
		_ = insecureConfig
	}
	{
		legacyConfig := &tls.Config{
			CipherSuites: []uint16{
				tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (var name suggests deliberate legacy support)
			},
		}
		_ = legacyConfig
	}
	{
		var insecureConfig tls.Config
		insecureConfig.CipherSuites = []uint16{
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (var name suggests deliberate insecurity)
		}
		_ = insecureConfig
	}
	{
		var legacyConfig tls.Config
		legacyConfig.CipherSuites = []uint16{
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (var name suggests deliberate legacy support)
		}
		_ = legacyConfig
	}
	{
		switch unknown {
		case oldVersionFlag:
			config := &tls.Config{
				CipherSuites: []uint16{
					tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (switch-case name suggests legacy support)
				},
			}
			_ = config
		case insecureFlag:
			config := &tls.Config{
				CipherSuites: []uint16{
					tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (switch-case name suggests insecurity)
				},
			}
			_ = config
		default:
			config := &tls.Config{
				CipherSuites: []uint16{
					tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // BAD
				},
			}
			_ = config
		}

		switch os.Args[0] {
		case "oldVersionFlag":
			config := &tls.Config{
				CipherSuites: []uint16{
					tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (switch-case name suggests legacy support)
				},
			}
			_ = config
		case "insecureFlag":
			config := &tls.Config{
				CipherSuites: []uint16{
					tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // OK (switch-case name suggests insecurity)
				},
			}
			_ = config
		default:
			config := &tls.Config{
				CipherSuites: []uint16{
					tls.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, // BAD
				},
			}
			_ = config
		}
	}
}
