package main

import (
	"net/http"
	"strings"
)

const (
	HeaderAllowOrigin      = "Access-Control-Allow-Origin"
	HeaderAllowCredentials = "Access-Control-Allow-Credentials"
)

func main() {
	{
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK: all origins are allowed,
			// but Access-Control-Allow-Credentials is not set.
			w.Header().Set("Access-Control-Allow-Origin", "*")
		})
	}
	{
		const Null = "null"
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: 'null' origin is allowed,
			// and Access-Control-Allow-Credentials is set to 'true'.
			w.Header().Set("Access-Control-Allow-Origin", "null") // $ Alert
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: 'null' origin is allowed,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			w.Header().Set(HeaderAllowOrigin, Null) // $ Alert
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK: 'null' origin is allowed,
			// but Access-Control-Allow-Credentials is set to 'false'.
			w.Header().Set("Access-Control-Allow-Origin", Null)
			w.Header().Set("Access-Control-Allow-Credentials", "false")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK: 'null' origin is allowed,
			// but Access-Control-Allow-Credentials is not set.
			w.Header().Set("Access-Control-Allow-Origin", Null)
		})
	}

	{
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			origin := req.Header.Get("origin")
			w.Header().Set(HeaderAllowOrigin, origin) // $ Alert
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			origin := req.Header.Get("origin")
			w.Header().Set("Access-Control-Allow-Origin", origin) // $ Alert
			w.Header().Set(HeaderAllowCredentials, "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			if origin := req.Header.Get("Origin"); origin != "" {
				w.Header().Set("Access-Control-Allow-Origin", origin) // $ Alert
			}
			w.Header().Set(HeaderAllowCredentials, "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// BUT `Access-Control-Allow-Credentials` is set to 'false':
			origin := req.Header.Get("origin")
			w.Header().Set("Access-Control-Allow-Origin", origin)
			w.Header().Set("Access-Control-Allow-Credentials", "false")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// BUT `Access-Control-Allow-Credentials` is not set:
			origin := req.Header.Get("origin")
			w.Header().Set("Access-Control-Allow-Origin", origin)
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// and `Access-Control-Allow-Credentials` is set to 'true',
			// BUT there is a check on the origin header:
			origin := req.Header.Get("origin")
			if allowedOrigin(origin) {
				w.Header().Set("Access-Control-Allow-Origin", origin)
			}
			w.Header().Set(HeaderAllowCredentials, "true")
		})
		allowedOrigins := map[string]bool{
			"example.com": true,
		}
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// and `Access-Control-Allow-Credentials` is set to 'true',
			// BUT there is a check on the origin header:
			origin := req.Header.Get("origin")
			isAllowed := allowedOrigins[origin]
			if isAllowed {
				w.Header().Set("Access-Control-Allow-Origin", origin)
			}
			w.Header().Set(HeaderAllowCredentials, "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// and `Access-Control-Allow-Credentials` is set to 'true',
			// BUT there is a check on the origin header:
			origin := req.Header.Get("origin")
			allowAllHosts := true
			allowedHost := isAllowedHost([]string{"example.com"}, origin)
			if allowAllHosts {
				w.Header().Set("Access-Control-Allow-Origin", "*")
			} else if allowedHost {
				w.Header().Set("Access-Control-Allow-Origin", origin)
				w.Header().Set(HeaderAllowCredentials, "true")
			}
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the input origin header is validated against a whitelist.
			responseHeader := w.Header()
			{
				origin := req.Header.Get("origin")
				if origin != "" && origin != "null" {
					if len(AccessControlAllowOrigins) == 0 ||
						AccessControlAllowOrigins[origin] {
						responseHeader.Set("Access-Control-Allow-Origin", origin)
						responseHeader.Set("Access-Control-Allow-Credentials", "true")
					}
				} else {
					responseHeader.Set("Access-Control-Allow-Origin", "*")
				}
			}
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			originSuffix := ".example.com"
			// OK-ish: the input origin header is validated against a suffix.
			origin := req.Header.Get("Origin")
			if origin != "" && (originSuffix == "" || strings.HasSuffix(origin, originSuffix)) {
				w.Header().Set("Access-Control-Allow-Origin", origin)
				w.Header().Set("Access-Control-Allow-Credentials", "true")
				w.Header().Set("Access-Control-Allow-Headers", "Content-Type, x-requested-by, *")
				w.Header().Set("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS")
				if req.Method == http.MethodOptions {
					w.WriteHeader(http.StatusOK)
					return
				}
			}
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			originSuffix := ".example.com"
			// OK-ish: the input origin header is validated against a whitelist.
			origin := req.Header.Get("Origin")
			if origin != "" && (originSuffix == "" || AccessControlAllowOrigins[origin]) {
				w.Header().Set("Access-Control-Allow-Origin", origin)
				w.Header().Set("Access-Control-Allow-Credentials", "true")
				w.Header().Set("Access-Control-Allow-Headers", "Content-Type, x-requested-by, *")
				w.Header().Set("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS")
				if req.Method == http.MethodOptions {
					w.WriteHeader(http.StatusOK)
					return
				}
			}
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the input origin header is validated against a whitelist.
			origin := req.Header.Get("origin")
			if origin != "" && origin != "null" {
				if len(AccessControlAllowOrigins) == 0 || AccessControlAllowOrigins[origin] {
					w.Header().Set("Access-Control-Allow-Origin", origin)
					w.Header().Set("Access-Control-Allow-Credentials", "true")
				}
			} else {
				w.Header().Set("Access-Control-Allow-Origin", "*")
			}
		})
		// http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		//  // OK-ish: the input origin header is validated against a whitelist.
		// 	origin := req.Header.Get("origin")
		// 	if origin != "" && origin != "null" {
		// 		if _, ok := AccessControlAllowOrigins[origin]; ok {
		// 			w.Header().Set("Access-Control-Allow-Origin", origin)
		// 			w.Header().Set("Access-Control-Allow-Credentials", "true")
		// 		}
		// 	} else {
		// 		w.Header().Set("Access-Control-Allow-Origin", "*")
		// 	}
		// })
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the input origin header is validated against a whitelist.
			if origin := req.Header.Get("Origin"); cors_map[origin] {
				w.Header().Set("Access-Control-Allow-Origin", origin)
			} else if len(origin) > 0 && cors_map["*"] {
				w.Header().Set("Access-Control-Allow-Origin", origin)
			}

			w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-Token, X-Client")
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the input origin header is validated against a whitelist.
			origin := req.Header.Get("origin")
			for _, v := range GetAllowOrigin() {
				if v == origin {
					w.Header().Add("Access-Control-Allow-Origin", origin)
					break
				}
			}

			w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-Token, X-Client")
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
	}
}

var (
	cors_map = map[string]bool{"*": true}
)

func GetAllowOrigin() []string {
	return []string{
		"example.com",
	}
}

var AccessControlAllowOrigins map[string]bool

func isAllowedHost(allowed []string, try string) bool {
	for _, v := range allowed {
		if try == v {
			return true
		}
	}
	return false
}

func allowedOrigin(origin string) bool {
	if origin == "example.com" {
		return true
	}
	return false
}
