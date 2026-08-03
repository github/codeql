package test

//go:generate depstubber -vendor  github.com/labstack/echo/v4 Context New

import (
	"strings"

	"github.com/labstack/echo/v4"
)

// Section: testing echo-specific user-controlled inputs, written as HTML.
// All are XSS vulnerabilities, except as specifically noted.

func testParam(ctx echo.Context) error {
	param := ctx.Param("someParam") // $ Source[go/reflected-xss]
	ctx.HTML(200, param)            // $ Alert[go/reflected-xss]
	return nil
}

func testParamValues(ctx echo.Context) error {
	param := ctx.ParamValues()[0] // $ Source[go/reflected-xss]
	ctx.HTML(200, param)          // $ Alert[go/reflected-xss]
	return nil
}

func testQueryParam(ctx echo.Context) error {
	param := ctx.QueryParam("someParam") // $ Source[go/reflected-xss]
	ctx.HTML(200, param)                 // $ Alert[go/reflected-xss]
	return nil
}

func testQueryParams(ctx echo.Context) error {
	param := ctx.QueryParams()["someParam"][0] // $ Source[go/reflected-xss]
	ctx.HTML(200, param)                       // $ Alert[go/reflected-xss]
	return nil
}

func testQueryString(ctx echo.Context) error {
	qstr := ctx.QueryString() // $ Source[go/reflected-xss]
	ctx.HTML(200, qstr)       // $ Alert[go/reflected-xss]
	return nil
}

func testFormValue(ctx echo.Context) error {
	val := ctx.FormValue("someField") // $ Source[go/reflected-xss]
	ctx.HTML(200, val)                // $ Alert[go/reflected-xss]
	return nil
}

func testFormParams(ctx echo.Context) error {
	params, _ := ctx.FormParams()         // $ Source[go/reflected-xss]
	ctx.HTML(200, params["someField"][0]) // $ Alert[go/reflected-xss]
	return nil
}

func testFormFile(ctx echo.Context) error {
	fileHeader, _ := ctx.FormFile("someFilename") // $ Source[go/reflected-xss]
	file, _ := fileHeader.Open()
	buffer := make([]byte, 100)
	file.Read(buffer)
	ctx.HTMLBlob(200, buffer) // $ Alert[go/reflected-xss]
	return nil
}

func testMultipartFormValue(ctx echo.Context) error {
	form, _ := ctx.MultipartForm()            // $ Source[go/reflected-xss]
	ctx.HTML(200, form.Value["someField"][0]) // $ Alert[go/reflected-xss]
	return nil
}

func testMultipartFormFile(ctx echo.Context) error {
	form, _ := ctx.MultipartForm() // $ Source[go/reflected-xss]
	fileHeader := form.File["someFilename"][0]
	file, _ := fileHeader.Open()
	buffer := make([]byte, 100)
	file.Read(buffer)
	ctx.HTMLBlob(200, buffer) // $ Alert[go/reflected-xss]
	return nil
}

func testCookie(ctx echo.Context) error {
	val, _ := ctx.Cookie("someKey") // $ Source[go/reflected-xss]
	ctx.HTML(200, val.Value)        // $ Alert[go/reflected-xss]
	return nil
}

func testCookies(ctx echo.Context) error {
	cookies := ctx.Cookies()        // $ Source[go/reflected-xss]
	ctx.HTML(200, cookies[0].Value) // $ Alert[go/reflected-xss]
	return nil
}

type myStruct struct {
	s string
}

func testBind(ctx echo.Context) error {
	data := myStruct{}
	ctx.Bind(&data)       // $ Source[go/reflected-xss]
	ctx.HTML(200, data.s) // $ Alert[go/reflected-xss]
	return nil
}

// Section: testing Context as a generic map. The empty context is clean;
// once tainted data is written to it it becomes a problem.

func testGetSetEmpty(ctx echo.Context) error {
	ctx.HTML(200, ctx.Get("someKey").(string)) // OK, the context is empty
	return nil
}

func testGetSet(ctx echo.Context) error {
	ctx.Set("someKey", ctx.Param("someParam")) // $ Source[go/reflected-xss]
	ctx.HTML(200, ctx.Get("someKey").(string)) // $ Alert[go/reflected-xss] // BAD, the context is tainted
	return nil
}

// Section: testing output methods defined on echo.Context. I only test HTML output methods,
// as we don't have any queries at the moment checking for data that shouldn't go to the user,
// even in JSON or text form.
// All are XSS vulnerabilities, except as specifically noted.

func testHTML(ctx echo.Context) error {
	param := ctx.Param("someParam") // $ Source[go/reflected-xss]
	ctx.HTML(200, param)            // $ Alert[go/reflected-xss]
	return nil
}

func testHTMLBlob(ctx echo.Context) error {
	param := ctx.Param("someParam")  // $ Source[go/reflected-xss]
	ctx.HTMLBlob(200, []byte(param)) // $ Alert[go/reflected-xss]
	return nil
}

func testBlob(ctx echo.Context) error {
	param := ctx.Param("someParam")           // $ Source[go/reflected-xss]
	ctx.Blob(200, "text/html", []byte(param)) // $ Alert[go/reflected-xss] // BAD, the content-type is HTML
	return nil
}

func testBlobSafe(ctx echo.Context) error {
	param := ctx.Param("someParam")
	ctx.Blob(200, "text/plain", []byte(param)) // OK, the content-type prevents XSS
	return nil
}

func testStream(ctx echo.Context) error {
	param := ctx.Param("someParam") // $ Source[go/reflected-xss]
	reader := strings.NewReader(param)
	ctx.Stream(200, "text/html", reader) // $ Alert[go/reflected-xss] // BAD, the content-type is HTML
	return nil
}

func testStreamSafe(ctx echo.Context) error {
	param := ctx.Param("someParam")
	reader := strings.NewReader(param)
	ctx.Stream(200, "text/plain", reader) // OK, the content-type prevents XSS
	return nil
}

// Section: testing output methods defined on Response (XSS vulnerability)

func testResponseWrite(ctx echo.Context) error {
	param := ctx.Param("someParam")     // $ Source[go/reflected-xss]
	ctx.Response().Write([]byte(param)) // $ Alert[go/reflected-xss]
	return nil
}

// Section: test detecting an open redirect using the Context.Redirect function:

func testRedirect(ctx echo.Context) error {
	param := ctx.Param("someParam") // $ Source[go/unvalidated-url-redirection]
	ctx.Redirect(301, param)        // $ Alert[go/unvalidated-url-redirection]
	return nil
}

func testLocalRedirects(ctx echo.Context) error {
	param := ctx.Param("someParam") // $ Source[go/unvalidated-url-redirection]
	param2 := param
	param3 := param
	// Gratuitous copy because sanitization of uses propagates to subsequent uses
	// GOOD: local redirects are unproblematic
	ctx.Redirect(301, "/local"+param)
	// BAD: this could be a non-local redirect
	ctx.Redirect(301, "/"+param2) // $ Alert[go/unvalidated-url-redirection]
	// GOOD: localhost redirects are unproblematic
	ctx.Redirect(301, "//localhost/"+param3)
	return nil
}

func testSafeSchemeChange(ctx echo.Context) error {
	// GOOD: Only safe parts of the URL are used
	url := *ctx.Request().URL
	if url.Scheme == "http" {
		url.Scheme = "https"
		ctx.Redirect(301, url.String())
	}
	return nil
}

func testNonExploitableFields(ctx echo.Context) error {
	// GOOD: all these fields and methods is disregarded for OpenRedirect attacks:
	ctx.Redirect(301, ctx.FormValue("someField"))
	params, _ := ctx.FormParams()
	ctx.Redirect(301, params["someField"][0])
	fileHeader, _ := ctx.FormFile("someFile")
	file, _ := fileHeader.Open()
	buffer := make([]byte, 100)
	file.Read(buffer)
	ctx.Redirect(301, string(buffer))
	form, _ := ctx.MultipartForm()
	ctx.Redirect(301, form.Value["someField"][0])
	val, _ := ctx.Cookie("someKey")
	ctx.Redirect(301, val.Value)
	cookies := ctx.Cookies()
	ctx.Redirect(301, cookies[0].Value)
	return nil
}

// BAD: using user-provided data as paths in file-system operations
func fsOpsTest() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		filepath := c.QueryParam("filePath") // $ Source[go/path-injection]
		return c.File(filepath)              // $ FileSystemAccess=filepath Alert[go/path-injection]
	})
	e.GET("/attachment", func(c echo.Context) error {
		filepath := c.QueryParam("filePath")                   // $ Source[go/path-injection]
		return c.Attachment(filepath, "file name in response") // $ FileSystemAccess=filepath Alert[go/path-injection]
	})
	_ = e.Start(":1323")
}
