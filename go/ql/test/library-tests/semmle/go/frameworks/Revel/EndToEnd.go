package main

import (
	"bytes"
	"errors"
	staticControllers "github.com/revel/modules/static/app/controllers"
	"github.com/revel/revel"
	"os"
	"time"
)

// Use typical inheritence pattern, per github.com/revel/examples/booking:

// Doesn't really matter which controller is used here since it'll be stubbed--
// the important thing is we're inheriting a controller from a Revel module, which
// itself implements revel.Controller.
type MyApplication struct {
	staticControllers.Static
}

// ...then it's common for files to inherit the whole-appliction controller.
type MyRoute struct {
	MyApplication
}

// Implement some request handlers on that Controller exhibiting some common problems:

func (c MyRoute) Handler1() revel.Result {
	// GOOD: the Render function is likely to properly escape the user-controlled parameter.
	return c.Render("someviewparam", c.Params.Form.Get("someField"))
}

func (c MyRoute) Handler2() revel.Result {
	// BAD: the RenderBinary function copies an `io.Reader` to the user's browser.
	buf := &bytes.Buffer{}
	buf.WriteString(c.Params.Form.Get("someField"))
	return c.RenderBinary(buf, "index.html", revel.Inline, time.Now()) // $ responsebody='buf'
}

func (c MyRoute) Handler3() revel.Result {
	// GOOD: the RenderBinary function copies an `io.Reader` to the user's browser, but the filename
	// means it will be given a safe content-type.
	buf := &bytes.Buffer{}
	buf.WriteString(c.Params.Form.Get("someField"))
	return c.RenderBinary(buf, "index.txt", revel.Inline, time.Now()) // $ responsebody='buf'
}

func (c MyRoute) Handler4() revel.Result {
	// GOOD: the RenderError function either uses an HTML template with probable escaping,
	// or it uses content-type text/plain.
	err := errors.New(c.Params.Form.Get("someField"))
	return c.RenderError(err) // $ responsebody='err'
}

func (c MyRoute) Handler5() revel.Result {
	// BAD: returning an arbitrary file (but this is detected at the os.Open call, not
	// due to modelling Revel)
	f, _ := os.Open(c.Params.Form.Get("someField"))
	return c.RenderFile(f, revel.Inline)
}

func (c MyRoute) Handler6() revel.Result {
	// BAD: returning an arbitrary file (detected as a user-controlled file-op, not XSS)
	return c.RenderFileName(c.Params.Form.Get("someField"), revel.Inline)
}

func (c MyRoute) Handler7() revel.Result {
	// BAD: straightforward XSS
	return c.RenderHTML(c.Params.Form.Get("someField")) // $ responsebody='call to Get'
}

func (c MyRoute) Handler8() revel.Result {
	// GOOD: uses JSON content-type
	return c.RenderJSON(c.Params.Form.Get("someField")) // $ responsebody='call to Get'
}

func (c MyRoute) Handler9() revel.Result {
	// GOOD: uses Javascript content-type
	return c.RenderJSONP("callback", c.Params.Form.Get("someField")) // $ responsebody='call to Get'
}

func (c MyRoute) Handler10() revel.Result {
	// GOOD: uses text content-type
	return c.RenderText(c.Params.Form.Get("someField")) // $ responsebody='call to Get'
}

func (c MyRoute) Handler11() revel.Result {
	// GOOD: uses xml content-type
	return c.RenderXML(c.Params.Form.Get("someField")) // $ responsebody='call to Get'
}

func (c MyRoute) Handler12() revel.Result {
	// BAD: open redirect
	return c.Redirect(c.Params.Form.Get("someField"))
}
