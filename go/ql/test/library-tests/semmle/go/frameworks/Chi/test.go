package main

import (
	"net/http"

	"github.com/go-chi/chi"
)

var hidden string

func hideUserData(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		hidden = r.URL.Path
		next.ServeHTTP(w, r)
	})
}

func main() {
	r := chi.NewRouter()
	r.With(hideUserData).Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(hidden))
		w.Write([]byte(chi.URLParam(r, "someParam")))
		w.Write([]byte(chi.URLParamFromCtx(r.Context(), "someKey")))
		w.Write([]byte(chi.RouteContext(r.Context()).URLParam("someOtherKey")))
	})
	http.ListenAndServe(":3000", r)
}
