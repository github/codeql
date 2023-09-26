package main

//go:generate depstubber -vendor  github.com/beego/beego/v2/server/web Controller Run,Router
//go:generate depstubber -vendor  github.com/beego/beego/v2/server/web/context BeegoOutput,Context
//go:generate depstubber -vendor  github.com/gin-gonic/gin Context Default
//go:generate depstubber -vendor  github.com/gofiber/fiber/v2 Ctx New
//go:generate depstubber -vendor  github.com/kataras/iris/v12 Context
//go:generate depstubber -vendor  github.com/labstack/echo/v4 Context New
//go:generate depstubber -vendor  github.com/spf13/afero Afero,RegexpFs,HttpFs,ReadOnlyFs,MemMapFs,OsFs,BasePathFs WriteReader,SafeWriteReader,WriteFile,ReadFile,ReadDir,NewOsFs,NewRegexpFs,NewReadOnlyFs,NewCacheOnReadFs,,NewHttpFs,NewBasePathFs,NewIOFS


import (
	"fmt"
	beego "github.com/beego/beego/v2/server/web"
	BeegoContext "github.com/beego/beego/v2/server/web/context"
	"github.com/gin-gonic/gin"
	"github.com/gofiber/fiber/v2"
	"github.com/kataras/iris/v12/context"
	"github.com/labstack/echo/v4"
	"github.com/spf13/afero"
	"net/http"
	"os"
	"regexp"
)

func main() {
	return
}

func BeegoController(beegoController beego.Controller) {
	beegoOutput := BeegoContext.BeegoOutput{}
	beegoOutput.Download("filepath", "license.txt")
	buffer := make([]byte, 10)
	_ = beegoController.SaveToFileWithBuffer("filenameExistsInForm", "filepath", buffer)
}

func Afero(writer http.ResponseWriter, request *http.Request) {
	filepath := request.URL.Query()["filepath"][0]
	//osFS := afero.NewMemMapFs()
	// OR
	osFS := afero.NewOsFs()
	fmt.Println(osFS.MkdirAll("tmp/b", 0755))
	fmt.Println(afero.WriteFile(osFS, "tmp/a", []byte("this is me a !"), 0755))
	fmt.Println(afero.WriteFile(osFS, "tmp/b/c", []byte("this is me c !"), 0755))
	fmt.Println(afero.WriteFile(osFS, "tmp/d", []byte("this is me d !"), 0755))
	content, _ := afero.ReadFile(osFS, filepath)
	fmt.Println(string(content))
	fmt.Println(osFS.Open(filepath))
	// BAD
	fmt.Println(afero.SafeWriteReader(osFS, filepath, os.Stdout))
	fmt.Println(afero.WriteReader(osFS, filepath, os.Stdout))

	// RegexpFs ==> BAD
	fmt.Println("RegexpFs:")
	regex, _ := regexp.Compile(".*")
	regexpFs := afero.NewRegexpFs(osFS, regex)
	fmt.Println(afero.ReadFile(regexpFs, filepath))

	// ReadOnlyFS ==> BAD
	fmt.Println("ReadOnlyFS:")
	readOnlyFS := afero.NewReadOnlyFs(osFS)
	fmt.Println(afero.ReadFile(readOnlyFS, filepath))

	// CacheOnReadFs ==> BAD
	fmt.Println("CacheOnReadFs:")
	cacheOnReadFs := afero.NewCacheOnReadFs(osFS, osFS, 10)
	fmt.Println(afero.ReadFile(cacheOnReadFs, filepath))

	// HttpFS ==> BAD
	fmt.Println("HttpFS:")
	httpFs := afero.NewHttpFs(osFS)
	httpFile, _ := httpFs.Open(filepath)
	tmpbytes := make([]byte, 30)
	fmt.Println(httpFile.Read(tmpbytes))
	fmt.Println(string(tmpbytes))

	// osFS ==> BAD
	fmt.Println("Afero:")
	afs := &afero.Afero{Fs: osFS}
	fmt.Println(afs.ReadFile(filepath))

	// BasePathFs ==> BAD
	fmt.Println("Afero:")
	basePathFs0 := &afero.Afero{Fs: afero.NewBasePathFs(osFS, "tmp")}
	fmt.Println(basePathFs0.ReadFile(filepath))

	// IOFS ==> GOOD
	fmt.Println("IOFS:")
	ioFS := afero.NewIOFS(osFS)
	fmt.Println(ioFS.ReadFile(filepath))
	fmt.Println(ioFS.Open(filepath))

	// BasePathFs ==> GOOD
	fmt.Println("BasePathFs:")
	basePathFs := afero.NewBasePathFs(osFS, "tmp")
	fmt.Println(afero.ReadFile(basePathFs, filepath))
	afero.ReadFile(basePathFs, filepath)
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
	app.Get("/b", func(c *fiber.Ctx) error {
		filepath := c.Params("filepath")
		header, _ := c.FormFile("f")
		_ = c.SaveFile(header, filepath)
		return c.SendFile(filepath)
	})
	_ = app.Listen(":3000")
}

func IrisTest(ctx context.Context) {
	filepath := ctx.URLParam("filepath")
	_ = ctx.SendFile(filepath, "file")
	_ = ctx.SendFileWithRate(filepath, "file", 0, 0)
	_ = ctx.ServeFile(filepath)
	_ = ctx.ServeFileWithRate(filepath, 0, 0)
	_, _, _ = ctx.UploadFormFiles(filepath, nil)
	_, fileHeader, _ := ctx.FormFile("file")
	_, _ = ctx.SaveFormFile(fileHeader, filepath)

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
