package main

import (
	"fmt"
	beego "github.com/beego/beego/v2/server/web"
	"github.com/gin-gonic/gin"
	"github.com/gofiber/fiber/v2"
	"github.com/kataras/iris/v12"
	"github.com/labstack/echo/v4"
	"github.com/spf13/afero"
	"github.com/valyala/fasthttp"
	"mime/multipart"
	"net"
	"net/http"
	"regexp"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	filepath := c.Ctx.Request.URL.Query()["filepath"][0]
	c.Ctx.Output.Download(filepath, "license.txt")
	buffer := make([]byte, 10)
	_ = c.SaveToFileWithBuffer("filenameExistsInForm", filepath, buffer)

}

func Afero(writer http.ResponseWriter, request *http.Request) {
	filepath := request.URL.Query()["filepath"][0]
	osFS := afero.NewOsFs()
	fmt.Println(afero.WriteFile(osFS, filepath, []byte("this is me d !"), 0755))
	content, _ := afero.ReadFile(osFS, filepath)
	fmt.Println(string(content))
	fmt.Println(osFS.Open(filepath))

	// BasePathFs
	fmt.Println("BasePathFs:")
	basePathFs := afero.NewBasePathFs(osFS, "tmp")
	fmt.Println(afero.ReadFile(basePathFs, filepath))

	// RegexpFs
	fmt.Println("RegexpFs:")
	regex, _ := regexp.Compile(".*")
	regexpFs := afero.NewRegexpFs(osFS, regex)
	fmt.Println(afero.ReadFile(regexpFs, filepath))

	// ReadOnlyFS
	fmt.Println("ReadOnlyFS:")
	readOnlyFS := afero.NewReadOnlyFs(osFS)
	fmt.Println(afero.ReadFile(readOnlyFS, filepath))

	// CacheOnReadFs
	fmt.Println("CacheOnReadFs:")
	cacheOnReadFs := afero.NewCacheOnReadFs(osFS, osFS, 10)
	fmt.Println(afero.ReadFile(cacheOnReadFs, filepath))

	// HttpFS
	fmt.Println("HttpFS:")
	httpFs := afero.NewHttpFs(osFS)
	httpFile, _ := httpFs.Open(filepath)
	tmpbytes := make([]byte, 30)
	fmt.Println(httpFile.Read(tmpbytes))
	fmt.Println(string(tmpbytes))

	// Afero
	fmt.Println("Afero:")
	afs := &afero.Afero{Fs: osFS}
	fmt.Println(afs.ReadFile(filepath))

	// IOFS ==> OK
	fmt.Println("IOFS:")
	ioFS := afero.NewIOFS(osFS)
	fmt.Println(ioFS.ReadFile(filepath))
	fmt.Println(ioFS.Open(filepath))
}

func Beego() {
	beego.Router("/", &MainController{})
	beego.Run()
}

func Echo() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.File(c.QueryParam("filePath"))
	})

	e.GET("/attachment", func(c echo.Context) error {
		return c.Attachment(c.QueryParam("filePath"), "file name in response")
	})
	_ = e.Start(":1323")
}

func Fiber() {
	app := fiber.New()
	app.Get("/a", func(c *fiber.Ctx) error {
		filepath := c.Params("filepath")
		return c.SendFile(filepath)
	})
	app.Get("/b", func(c *fiber.Ctx) error {
		filepath := c.Params("filepath")
		header, _ := c.FormFile("f")
		_ = c.SaveFile(header, filepath)
		c.Attachment(filepath)
		return c.SendFile(filepath)
	})
	_ = app.Listen(":3000")
}

func Fasthttp() {
	ln, _ := net.Listen("tcp4", "127.0.0.1:8080")
	requestHandler := func(ctx *fasthttp.RequestCtx) {
		filePath := ctx.QueryArgs().Peek("filePath")
		_ = ctx.Response.SendFile(string(filePath))
		ctx.SendFile(string(filePath))
		ctx.SendFileBytes(filePath)
		fileHeader, _ := ctx.FormFile("file")
		_ = fasthttp.SaveMultipartFile(fileHeader, string(filePath))
		fasthttp.ServeFile(ctx, string(filePath))
		fasthttp.ServeFileUncompressed(ctx, string(filePath))
		fasthttp.ServeFileBytes(ctx, filePath)
		fasthttp.ServeFileBytesUncompressed(ctx, filePath)
	}
	_ = fasthttp.Serve(ln, requestHandler)
}
func IrisTest() {
	app := iris.New()
	app.UseRouter(iris.Compression)
	app.Get("/", func(ctx iris.Context) {
		filepath := ctx.URLParam("filepath")
		_ = ctx.SendFile(filepath, "file")
		_ = ctx.SendFileWithRate(filepath, "file", 0, 0)
		_ = ctx.ServeFile(filepath)
		_ = ctx.ServeFileWithRate(filepath, 0, 0)
		_, _, _ = ctx.UploadFormFiles(filepath, beforeSave)
		_, fileHeader, _ := ctx.FormFile("file")
		_, _ = ctx.SaveFormFile(fileHeader, filepath)

	})
	app.Listen(":8080")

}
func beforeSave(ctx iris.Context, file *multipart.FileHeader) bool {
	return true
}
func Gin() {
	router := gin.Default()
	router.POST("/FormUploads", func(c *gin.Context) {
		filepath := c.Query("filepath")
		c.File(filepath)
		http.ServeFile(c.Writer, c.Request, filepath)
		c.FileAttachment(filepath, "file name in response")
		file, _ := c.FormFile("afile")
		_ = c.SaveUploadedFile(file, filepath)
	})
	_ = router.Run()
}
