package test

//go:generate depstubber -vendor  github.com/beego/beego/v2/server/web Controller Run,Router
//go:generate depstubber -vendor  github.com/beego/beego/v2/server/web/context BeegoOutput,Context

import (
	"encoding/json"
	"io/ioutil"
	"mime/multipart"
	"net/http"
	"os"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/utils"
	beegov2 "github.com/beego/beego/v2/server/web"
	Beegov2Context "github.com/beego/beego/v2/server/web/context"
)

type subBindMe struct {
	z string
}

type bindMe struct {
	a []string
	b string
	c subBindMe
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromBind(input *context.BeegoInput, sink http.ResponseWriter) {
	var bound bindMe
	input.Bind(bound, "someKey")   // $ Source[go/reflected-xss]
	sink.Write([]byte(bound.a[0])) // $ Alert[go/reflected-xss]
	sink.Write([]byte(bound.b))    // $ Alert[go/reflected-xss]
	sink.Write([]byte(bound.c.z))  // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromCookie(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Cookie("someKey"))) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromData(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Data()["someKey"].(string))) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromGetData(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.GetData("someKey").(string))) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromHeader(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Header("someKey"))) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromParam(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Param("someKey"))) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromParams(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Params()["someKey"])) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromQuery(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Query("someKey"))) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromRefer(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Refer())) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromReferer(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Referer())) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromURI(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.URI())) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromURL(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.URL())) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromUserAgent(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.UserAgent())) // $ Alert[go/reflected-xss]
}

// BAD: with no obvious ContentType call we assume this could be text/html.
func echoToBodyNoContentType(input *context.BeegoInput, output *context.BeegoOutput) {
	output.Body(input.Data()["someKey"].([]byte)) // $ Alert[go/reflected-xss]
}

// OK: JSON can't (by itself) cause XSS
func echoToBodyContentTypeJson(input *context.BeegoInput, output *context.BeegoOutput) {
	output.ContentType("application/json")
	output.Body(input.Data()["someKey"].([]byte))
}

// BAD: echoing untrusted data with an HTML content type
func echoToBodyContentTypeHtml(input *context.BeegoInput, output *context.BeegoOutput) {
	output.ContentType("text/html")
	output.Body(input.Data()["someKey"].([]byte)) // $ Alert[go/reflected-xss]
}

// OK: JSON can't (by itself) cause XSS
func echoToBodyContentTypeJsonUsingHeader(input *context.BeegoInput, output *context.BeegoOutput) {
	output.Header("content-type", "application/json")
	output.Body(input.Data()["someKey"].([]byte))
}

// BAD: echoing untrusted data with an HTML content type
func echoToBodyContentTypeHtmlUsingHeader(input *context.BeegoInput, output *context.BeegoOutput) {
	output.Header("content-type", "text/html")
	output.Body(input.Data()["someKey"].([]byte)) // $ Alert[go/reflected-xss]
}

// OK: JSON and other non-HTML formats can't (by themselves) cause XSS
func echoToFixedContentTypeRoutines(input *context.BeegoInput, output *context.BeegoOutput) {
	output.JSON(input.Data()["someKey"].(string), false, false)
	output.JSONP(input.Data()["someKey"].(string), false)
	output.ServeFormatted(input.Data()["someKey"].(string), false, false)
	output.XML(input.Data()["someKey"].(string), false)
	output.YAML(input.Data()["someKey"].(string))
}

// BAD: echoing untrusted data with an HTML content type
// This time using a more realistic context: registering a function using App.Post.
func echoToBodyContentTypeHtmlUsingHandler() {
	beego.Post("", func(context *context.Context) {
		context.Output.Header("content-type", "text/html")
		context.Output.Body(context.Input.Data()["someKey"].([]byte)) // $ Alert[go/reflected-xss]
	})
}

// OK: using beego.htmlQuote sanitizes.
func echoToBodySanitized(input *context.BeegoInput, output *context.BeegoOutput) {
	output.Body([]byte(beego.Htmlquote(input.Data()["someKey"].(string))))
}

// BAD: logging something named "password".
func loggerTest(password string, logger *logs.BeeLogger) { // $ Source[go/clear-text-logging]
	beego.Alert(password)          // $ Alert[go/clear-text-logging]
	beego.Critical(password)       // $ Alert[go/clear-text-logging]
	beego.Debug(password)          // $ Alert[go/clear-text-logging]
	beego.Emergency(password)      // $ Alert[go/clear-text-logging]
	beego.Error(password)          // $ Alert[go/clear-text-logging]
	beego.Info(password)           // $ Alert[go/clear-text-logging]
	beego.Informational(password)  // $ Alert[go/clear-text-logging]
	beego.Notice(password)         // $ Alert[go/clear-text-logging]
	beego.Trace(password)          // $ Alert[go/clear-text-logging]
	beego.Warn(password)           // $ Alert[go/clear-text-logging]
	beego.Warning(password)        // $ Alert[go/clear-text-logging]
	logs.Alert(password)           // $ Alert[go/clear-text-logging]
	logs.Critical(password)        // $ Alert[go/clear-text-logging]
	logs.Debug(password)           // $ Alert[go/clear-text-logging]
	logs.Emergency(password)       // $ Alert[go/clear-text-logging]
	logs.Error(password)           // $ Alert[go/clear-text-logging]
	logs.Info(password)            // $ Alert[go/clear-text-logging]
	logs.Informational(password)   // $ Alert[go/clear-text-logging]
	logs.Notice(password)          // $ Alert[go/clear-text-logging]
	logs.Trace(password)           // $ Alert[go/clear-text-logging]
	logs.Warn(password)            // $ Alert[go/clear-text-logging]
	logs.Warning(password)         // $ Alert[go/clear-text-logging]
	logger.Alert(password)         // $ Alert[go/clear-text-logging]
	logger.Critical(password)      // $ Alert[go/clear-text-logging]
	logger.Debug(password)         // $ Alert[go/clear-text-logging]
	logger.Emergency(password)     // $ Alert[go/clear-text-logging]
	logger.Error(password)         // $ Alert[go/clear-text-logging]
	logger.Info(password)          // $ Alert[go/clear-text-logging]
	logger.Informational(password) // $ Alert[go/clear-text-logging]
	logger.Notice(password)        // $ Alert[go/clear-text-logging]
	logger.Trace(password)         // $ Alert[go/clear-text-logging]
	logger.Warn(password)          // $ Alert[go/clear-text-logging]
	logger.Warning(password)       // $ Alert[go/clear-text-logging]
	utils.Display(password)        // $ Alert[go/clear-text-logging]
}

type myStruct struct {
	field string
}

// BAD: echoing untrusted data, via various taint-propagating functions
func sanitizersTest(ctx *context.Context) {
	input := ctx.Input
	output := ctx.Output

	untrusted := input.Data()["someKey"]                       // $ Source[go/reflected-xss]
	output.Body([]byte(beego.HTML2str(untrusted.(string))))    // $ Alert[go/reflected-xss]
	output.Body([]byte(beego.Htmlunquote(untrusted.(string)))) // $ Alert[go/reflected-xss]
	mapVal, _ := beego.MapGet(untrusted.(map[string][]byte), "somekey")
	output.Body(mapVal.([]byte))                                // $ Alert[go/reflected-xss]
	output.Body([]byte(beego.Str2html(untrusted.(string))))     // $ Alert[go/reflected-xss]
	output.Body([]byte(beego.Substr(untrusted.(string), 1, 2))) // $ Alert[go/reflected-xss]

	var s myStruct
	beego.ParseForm(ctx.Request.Form, s) // $ Source[go/reflected-xss]
	output.Body([]byte(s.field))         // $ Alert[go/reflected-xss]
}

// BAD: using user-provided data as paths in file-system operations
func fsOpsTest(ctx *context.Context, c *beego.Controller, fs beego.FileSystem) {
	input := ctx.Input
	untrusted := input.Data()["someKey"].(string)                                                   // $ Source[go/path-injection]
	beego.Walk(nil, untrusted, func(path string, info os.FileInfo, err error) error { return nil }) // $ Alert[go/path-injection]
	fs.Open(untrusted)                                                                              // $ Alert[go/path-injection]
	c.SaveToFile("someReceviedFile", untrusted)                                                     // $ Alert[go/path-injection]
}

// BAD: echoing untrusted data, using various Controller sources
func controllerSourceTest(c *beego.Controller, output *context.BeegoOutput) {
	f, fh, _ := c.GetFile("somename") // $ Source[go/reflected-xss]
	output.Body([]byte(fh.Filename))  // $ Alert[go/reflected-xss]
	content, _ := ioutil.ReadAll(f)
	output.Body(content) // $ Alert[go/reflected-xss]

	files, _ := c.GetFiles("someothername") // $ Source[go/reflected-xss]
	output.Body([]byte(files[0].Filename))  // $ Alert[go/reflected-xss]

	s := c.GetString("somekey") // $ Source[go/reflected-xss]
	output.Body([]byte(s))      // $ Alert[go/reflected-xss]

	ss := c.GetStrings("someotherkey") // $ Source[go/reflected-xss]
	output.Body([]byte(ss[0]))         // $ Alert[go/reflected-xss]

	val := c.Input()["thirdkey"] // $ Source[go/reflected-xss]
	output.Body([]byte(val[0]))  // $ Alert[go/reflected-xss]

	var str myStruct
	c.ParseForm(str)               // $ Source[go/reflected-xss]
	output.Body([]byte(str.field)) // $ Alert[go/reflected-xss]
}

func controllerSinkTest(c *beego.Controller) {
	untrusted := c.GetString("somekey") // $ Source[go/reflected-xss]
	c.SetData(untrusted)                // GOOD: SetData always uses a non-html content-type, so no XSS risk

	c.CustomAbort(500, untrusted) // $ Alert[go/reflected-xss] // BAD: CustomAbort doesn't set a content-type, so there is an XSS risk
}

func redirectTest(c *beego.Controller, ctx *context.Context) {
	c.Redirect(c.GetString("somekey"), 304)   // $ Alert[go/unvalidated-url-redirection]
	ctx.Redirect(304, c.GetString("somekey")) // $ Alert[go/unvalidated-url-redirection]
}

// BAD: echoing untrusted data, using Context source
func contextSourceTest(c *context.Context) {
	c.Output.Body([]byte(c.GetCookie("somekey"))) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data, using Context sinks
func contextSinkTest(c *context.Context) {
	c.WriteString(c.GetCookie("somekey"))     // $ Alert[go/reflected-xss]
	c.Abort(500, c.GetCookie("someOtherKey")) // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data, using context.WriteBody as a propagator
func contextWriteBodyTest(c *context.Context) {
	context.WriteBody("some/encoding", c.ResponseWriter, []byte(c.GetCookie("someKey"))) // $ Alert[go/reflected-xss]
}

// BAD unless otherwise noted: echoing untrusted data, using various utils methods as propagators
func testUtilsPropagators(c *beego.Controller) {
	files, _ := c.GetFiles("someothername") // $ Source[go/reflected-xss]
	genericFiles := make([]interface{}, len(files), len(files))
	for i := range files {
		genericFiles[i] = files[i]
	}

	untainted := make([]interface{}, 1, 1)

	c.CustomAbort(500, utils.GetDisplayString(files[0].Filename))                                    // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceChunk(genericFiles, 1)[0][0].(*multipart.FileHeader).Filename)     // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceDiff(genericFiles, untainted)[0].(*multipart.FileHeader).Filename) // $ Alert[go/reflected-xss]
	// GOOD: the tainted values are subtracted, so taint is not propagated
	c.CustomAbort(500, utils.SliceDiff(untainted, genericFiles)[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(
		500,
		utils.SliceFilter(
			genericFiles,
			func([]interface{}) bool { return true })[0].(*multipart.FileHeader).Filename) // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceIntersect(genericFiles, untainted)[0].(*multipart.FileHeader).Filename)  // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceIntersect(untainted, genericFiles)[0].(*multipart.FileHeader).Filename)  // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceMerge(genericFiles, untainted)[0].(*multipart.FileHeader).Filename)      // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceMerge(untainted, genericFiles)[0].(*multipart.FileHeader).Filename)      // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SlicePad(untainted, 10, genericFiles[0])[0].(*multipart.FileHeader).Filename) // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SlicePad(genericFiles, 10, untainted[0])[0].(*multipart.FileHeader).Filename) // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceRand(genericFiles).(*multipart.FileHeader).Filename)                     // $ Alert[go/reflected-xss]
	// Note this is misnamed -- it's a map operation, not a reduce
	c.CustomAbort(500, utils.SliceReduce(genericFiles, func(x interface{}) interface{} { return x })[0].(*multipart.FileHeader).Filename) // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceShuffle(genericFiles)[0].(*multipart.FileHeader).Filename)                                              // $ Alert[go/reflected-xss]
	c.CustomAbort(500, utils.SliceUnique(genericFiles)[0].(*multipart.FileHeader).Filename)                                               // $ Alert[go/reflected-xss]
}

// BAD: echoing untrusted data, using BeeMap as an intermediary
func testBeeMap(c *beego.Controller) {
	bMap := utils.NewBeeMap()
	untrusted := c.GetString("someKey") // $ Source[go/reflected-xss]
	bMap.Set("someKey", untrusted)
	c.CustomAbort(500, bMap.Get("someKey").(string))     // $ Alert[go/reflected-xss]
	c.CustomAbort(500, bMap.Items()["someKey"].(string)) // $ Alert[go/reflected-xss]
}

// GOOD: using the input URL for a redirect operation
func testSafeRedirects(c *beego.Controller, ctx *context.Context) {
	c.Redirect(ctx.Input.URI(), 304)
	ctx.Redirect(304, ctx.Input.URL())
}

// BAD: using RequestBody data as path in a file-system operation
func requestBodySourceTest(ctx *context.Context, c *beego.Controller) {
	var dat map[string]interface{}
	json.Unmarshal(ctx.Input.RequestBody, &dat) // $ Source[go/path-injection]
	untrusted := dat["filepath"].(string)
	c.SaveToFile("someReceviedFile", untrusted) // $ Alert[go/path-injection]
}

// BAD: using user-provided data as paths in file-system operations
func fsOpsTest2(ctx *context.Context, c *beego.Controller, fs beego.FileSystem) {
	input := ctx.Input
	untrusted := input.Data()["someKey"].(string) // $ Source[go/path-injection]
	beegoOutput := context.BeegoOutput{}
	beegoOutput.Download(untrusted, "license.txt") // $ Alert[go/path-injection]
}

// BAD: using user-provided data as paths in file-system operations
func fsOpsV2Test(ctx *Beegov2Context.Context, c *beegov2.Controller) {
	input := ctx.Input
	untrusted := input.Data()["someKey"].(string) // $ Source[go/path-injection]
	buffer := make([]byte, 10)
	_ = c.SaveToFileWithBuffer("filenameExistsInForm", untrusted, buffer) // $ Alert[go/path-injection]
	beegoOutput := Beegov2Context.BeegoOutput{}
	beegoOutput.Download(untrusted, "license.txt") // $ Alert[go/path-injection]
}
