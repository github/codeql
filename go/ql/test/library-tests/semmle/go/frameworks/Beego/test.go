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
	input.Bind(bound, "someKey")
	sink.Write([]byte(bound.a[0]))
	sink.Write([]byte(bound.b))
	sink.Write([]byte(bound.c.z))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromCookie(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Cookie("someKey")))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromData(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Data()["someKey"].(string)))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromGetData(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.GetData("someKey").(string)))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromHeader(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Header("someKey")))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromParam(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Param("someKey")))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromParams(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Params()["someKey"]))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromQuery(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Query("someKey")))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromRefer(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Refer()))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromReferer(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.Referer()))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromURI(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.URI()))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromURL(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.URL()))
}

// BAD: echoing untrusted data to an `http.ResponseWriter`
func xssFromUserAgent(input *context.BeegoInput, sink http.ResponseWriter) {
	sink.Write([]byte(input.UserAgent()))
}

// BAD: with no obvious ContentType call we assume this could be text/html.
func echoToBodyNoContentType(input *context.BeegoInput, output *context.BeegoOutput) {
	output.Body(input.Data()["someKey"].([]byte))
}

// OK: JSON can't (by itself) cause XSS
func echoToBodyContentTypeJson(input *context.BeegoInput, output *context.BeegoOutput) {
	output.ContentType("application/json")
	output.Body(input.Data()["someKey"].([]byte))
}

// BAD: echoing untrusted data with an HTML content type
func echoToBodyContentTypeHtml(input *context.BeegoInput, output *context.BeegoOutput) {
	output.ContentType("text/html")
	output.Body(input.Data()["someKey"].([]byte))
}

// OK: JSON can't (by itself) cause XSS
func echoToBodyContentTypeJsonUsingHeader(input *context.BeegoInput, output *context.BeegoOutput) {
	output.Header("content-type", "application/json")
	output.Body(input.Data()["someKey"].([]byte))
}

// BAD: echoing untrusted data with an HTML content type
func echoToBodyContentTypeHtmlUsingHeader(input *context.BeegoInput, output *context.BeegoOutput) {
	output.Header("content-type", "text/html")
	output.Body(input.Data()["someKey"].([]byte))
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
		context.Output.Body(context.Input.Data()["someKey"].([]byte))
	})
}

// OK: using beego.htmlQuote sanitizes.
func echoToBodySanitized(input *context.BeegoInput, output *context.BeegoOutput) {
	output.Body([]byte(beego.Htmlquote(input.Data()["someKey"].(string))))
}

// BAD: logging something named "password".
func loggerTest(password string, logger *logs.BeeLogger) {
	beego.Alert(password)
	beego.Critical(password)
	beego.Debug(password)
	beego.Emergency(password)
	beego.Error(password)
	beego.Info(password)
	beego.Informational(password)
	beego.Notice(password)
	beego.Trace(password)
	beego.Warn(password)
	beego.Warning(password)
	logs.Alert(password)
	logs.Critical(password)
	logs.Debug(password)
	logs.Emergency(password)
	logs.Error(password)
	logs.Info(password)
	logs.Informational(password)
	logs.Notice(password)
	logs.Trace(password)
	logs.Warn(password)
	logs.Warning(password)
	logger.Alert(password)
	logger.Critical(password)
	logger.Debug(password)
	logger.Emergency(password)
	logger.Error(password)
	logger.Info(password)
	logger.Informational(password)
	logger.Notice(password)
	logger.Trace(password)
	logger.Warn(password)
	logger.Warning(password)
	utils.Display(password)
}

type myStruct struct {
	field string
}

// BAD: echoing untrusted data, via various taint-propagating functions
func sanitizersTest(ctx *context.Context) {
	input := ctx.Input
	output := ctx.Output

	untrusted := input.Data()["someKey"]
	output.Body([]byte(beego.HTML2str(untrusted.(string))))
	output.Body([]byte(beego.Htmlunquote(untrusted.(string))))
	mapVal, _ := beego.MapGet(untrusted.(map[string][]byte), "somekey")
	output.Body(mapVal.([]byte))
	output.Body([]byte(beego.Str2html(untrusted.(string))))
	output.Body([]byte(beego.Substr(untrusted.(string), 1, 2)))

	var s myStruct
	beego.ParseForm(ctx.Request.Form, s)
	output.Body([]byte(s.field))
}

// BAD: using user-provided data as paths in file-system operations
func fsOpsTest(ctx *context.Context, c *beego.Controller, fs beego.FileSystem) {
	input := ctx.Input
	untrusted := input.Data()["someKey"].(string)
	beego.Walk(nil, untrusted, func(path string, info os.FileInfo, err error) error { return nil })
	fs.Open(untrusted)
	c.SaveToFile("someReceviedFile", untrusted)
}

// BAD: echoing untrusted data, using various Controller sources
func controllerSourceTest(c *beego.Controller, output *context.BeegoOutput) {
	f, fh, _ := c.GetFile("somename")
	output.Body([]byte(fh.Filename))
	content, _ := ioutil.ReadAll(f)
	output.Body(content)

	files, _ := c.GetFiles("someothername")
	output.Body([]byte(files[0].Filename))

	s := c.GetString("somekey")
	output.Body([]byte(s))

	ss := c.GetStrings("someotherkey")
	output.Body([]byte(ss[0]))

	val := c.Input()["thirdkey"]
	output.Body([]byte(val[0]))

	var str myStruct
	c.ParseForm(str)
	output.Body([]byte(str.field))
}

func controllerSinkTest(c *beego.Controller) {
	untrusted := c.GetString("somekey")
	c.SetData(untrusted) // GOOD: SetData always uses a non-html content-type, so no XSS risk

	c.CustomAbort(500, untrusted) // BAD: CustomAbort doesn't set a content-type, so there is an XSS risk
}

func redirectTest(c *beego.Controller, ctx *context.Context) {
	c.Redirect(c.GetString("somekey"), 304)   // BAD: User-controlled redirect
	ctx.Redirect(304, c.GetString("somekey")) // BAD: User-controlled redirect
}

// BAD: echoing untrusted data, using Context source
func contextSourceTest(c *context.Context) {
	c.Output.Body([]byte(c.GetCookie("somekey")))
}

// BAD: echoing untrusted data, using Context sinks
func contextSinkTest(c *context.Context) {
	c.WriteString(c.GetCookie("somekey"))
	c.Abort(500, c.GetCookie("someOtherKey"))
}

// BAD: echoing untrusted data, using context.WriteBody as a propagator
func contextWriteBodyTest(c *context.Context) {
	context.WriteBody("some/encoding", c.ResponseWriter, []byte(c.GetCookie("someKey")))
}

// BAD unless otherwise noted: echoing untrusted data, using various utils methods as propagators
func testUtilsPropagators(c *beego.Controller) {
	files, _ := c.GetFiles("someothername")
	genericFiles := make([]interface{}, len(files), len(files))
	for i := range files {
		genericFiles[i] = files[i]
	}

	untainted := make([]interface{}, 1, 1)

	c.CustomAbort(500, utils.GetDisplayString(files[0].Filename))
	c.CustomAbort(500, utils.SliceChunk(genericFiles, 1)[0][0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SliceDiff(genericFiles, untainted)[0].(*multipart.FileHeader).Filename)
	// GOOD: the tainted values are subtracted, so taint is not propagated
	c.CustomAbort(500, utils.SliceDiff(untainted, genericFiles)[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(
		500,
		utils.SliceFilter(
			genericFiles,
			func([]interface{}) bool { return true })[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SliceIntersect(genericFiles, untainted)[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SliceIntersect(untainted, genericFiles)[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SliceMerge(genericFiles, untainted)[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SliceMerge(untainted, genericFiles)[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SlicePad(untainted, 10, genericFiles[0])[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SlicePad(genericFiles, 10, untainted[0])[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SliceRand(genericFiles).(*multipart.FileHeader).Filename)
	// Note this is misnamed -- it's a map operation, not a reduce
	c.CustomAbort(500, utils.SliceReduce(genericFiles, func(x interface{}) interface{} { return x })[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SliceShuffle(genericFiles)[0].(*multipart.FileHeader).Filename)
	c.CustomAbort(500, utils.SliceUnique(genericFiles)[0].(*multipart.FileHeader).Filename)
}

// BAD: echoing untrusted data, using BeeMap as an intermediary
func testBeeMap(c *beego.Controller) {
	bMap := utils.NewBeeMap()
	untrusted := c.GetString("someKey")
	bMap.Set("someKey", untrusted)
	c.CustomAbort(500, bMap.Get("someKey").(string))
	c.CustomAbort(500, bMap.Items()["someKey"].(string))
}

// GOOD: using the input URL for a redirect operation
func testSafeRedirects(c *beego.Controller, ctx *context.Context) {
	c.Redirect(ctx.Input.URI(), 304)
	ctx.Redirect(304, ctx.Input.URL())
}

// BAD: using RequestBody data as path in a file-system operation
func requestBodySourceTest(ctx *context.Context, c *beego.Controller) {
	var dat map[string]interface{}
	json.Unmarshal(ctx.Input.RequestBody, &dat)
	untrusted := dat["filepath"].(string)
	c.SaveToFile("someReceviedFile", untrusted)
}

// BAD: using user-provided data as paths in file-system operations
func fsOpsTest2(ctx *context.Context, c *beego.Controller, fs beego.FileSystem) {
	input := ctx.Input
	untrusted := input.Data()["someKey"].(string)
	beegoOutput := context.BeegoOutput{}
	beegoOutput.Download(untrusted, "license.txt")
}

// BAD: using user-provided data as paths in file-system operations
func fsOpsV2Test(ctx *Beegov2Context.Context, c *beegov2.Controller) {
	input := ctx.Input
	untrusted := input.Data()["someKey"].(string)
	buffer := make([]byte, 10)
	_ = c.SaveToFileWithBuffer("filenameExistsInForm", untrusted, buffer)
	beegoOutput := Beegov2Context.BeegoOutput{}
	beegoOutput.Download(untrusted, "license.txt")
}
