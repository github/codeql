package app

import (
	"fmt"
	"github.com/revel/revel"
	"github.com/revel/revel/logger"
	"net/http"
	"os"
)

func init() {
	// Filters is the default set of global filters.
	revel.Filters = []revel.Filter{
		revel.PanicFilter,             // Recover from panics and display an error page instead.
		revel.RouterFilter,            // Use the routing table to select the right Action
		revel.FilterConfiguringFilter, // A hook for adding or removing per-Action filters.
		revel.ParamsFilter,            // Parse parameters into Controller.Params.
		revel.SessionFilter,           // Restore and write the session cookie.
		revel.FlashFilter,             // Restore and write the flash cookie.
		revel.ValidationFilter,        // Restore kept validation errors and save new ones from cookie.
		revel.I18nFilter,              // Resolve the requested language
		HeaderFilter,                  // Add some security based headers
		revel.InterceptorFilter,       // Run interceptors around the action.
		revel.CompressFilter,          // Compress the result.
		revel.ActionInvoker,           // Invoke the action.
	}
	logger.LogFunctionMap["stdoutjson"] =
		func(c *logger.CompositeMultiHandler, options *logger.LogOptions) {
			// Set the json formatter to os.Stdout, replace any existing handlers for the level specified
			c.SetJson(os.Stdout, options)
		}
	revel.AddInitEventHandler(func(event revel.Event, i interface{}) revel.EventResponse {
		switch event {
		case revel.ENGINE_BEFORE_INITIALIZED:
			revel.AddHTTPMux("/this/is/a/test", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				fmt.Fprintln(w, "Hi there, it worked", r.URL.Path) // $ responsebody='selection of Path' responsebody='"Hi there, it worked"'
				w.WriteHeader(200)
			}))
			revel.AddHTTPMux("/this/is/", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				fmt.Fprintln(w, "Hi there, shorter prefix", r.URL.Path) // $ responsebody='selection of Path' responsebody='"Hi there, shorter prefix"'
				w.WriteHeader(200)
			}))
		}
		return 0
	})

	revel.OnAppStart(func() {}, 5)
}

var HeaderFilter = func(c *revel.Controller, fc []revel.Filter) {
	// Add some common security headers
	c.Response.Out.Header().Add("X-Frame-Options", "SAMEORIGIN")
	c.Response.Out.Header().Add("X-XSS-Protection", "1; mode=block")
	c.Response.Out.Header().Add("X-Content-Type-Options", "nosniff")

	fc[0](c, fc[1:]) // Execute the next filter stage.
}
