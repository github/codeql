package main

import (
	"net/http"
)

func Handler(r *http.Request) {
	use(r.Header)
	use(r.Header.Values("X-Forwarded-By"))
	use(r.Header.Get("Authentication"))

	buf := make([]byte, 100)
	use(r.Body.Read(buf))
	body, err := r.GetBody()
	if err != nil {
		return
	}
	use(body.Read(buf))
}
