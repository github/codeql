package main

//go:generate depstubber -vendor  github.com/beego/beego/v2/server/web Controller Run,Router
//go:generate depstubber -vendor  github.com/beego/beego/v2/server/web/context BeegoOutput,Context
//go:generate depstubber -vendor  github.com/gin-gonic/gin Context Default
//go:generate depstubber -vendor  github.com/gofiber/fiber/v2 Ctx New
//go:generate depstubber -vendor  github.com/kataras/iris/v12/context Context
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
	beegoOutput.Download("filepath", "license.txt") // $ FileSystemAccess="filepath"
	buffer := make([]byte, 10)
	_ = beegoController.SaveToFileWithBuffer("filenameExistsInForm", "filepath", buffer) // $ FileSystemAccess="filepath"
}

func Afero(writer http.ResponseWriter, request *http.Request) {
	filepath := request.URL.Query()["filepath"][0]
	//osFS := afero.NewMemMapFs()
	// OR
	osFS := afero.NewOsFs()
	fmt.Println(osFS.MkdirAll(filepath, 0755))                                   // $ FileSystemAccess=filepath
	fmt.Println(afero.WriteFile(osFS, filepath, []byte("this is me a !"), 0755)) // $ FileSystemAccess=filepath
	content, _ := afero.ReadFile(osFS, filepath)                                 // $ FileSystemAccess=filepath
	fmt.Println(string(content))
	fmt.Println(osFS.Open(filepath)) // $ FileSystemAccess=filepath
	// NOT OK
	fmt.Println(afero.SafeWriteReader(osFS, filepath, os.Stdout)) // $ FileSystemAccess=filepath
	fmt.Println(afero.WriteReader(osFS, filepath, os.Stdout))     // $ FileSystemAccess=filepath

	// RegexpFs ==> NOT OK
	fmt.Println("RegexpFs:")
	regex, _ := regexp.Compile(".*")
	regexpFs := afero.NewRegexpFs(osFS, regex)
	fmt.Println(afero.ReadFile(regexpFs, filepath)) // $ FileSystemAccess=filepath

	// ReadOnlyFS ==> NOT OK
	fmt.Println("ReadOnlyFS:")
	readOnlyFS := afero.NewReadOnlyFs(osFS)
	fmt.Println(afero.ReadFile(readOnlyFS, filepath)) // $ FileSystemAccess=filepath

	// CacheOnReadFs ==> NOT OK
	fmt.Println("CacheOnReadFs:")
	cacheOnReadFs := afero.NewCacheOnReadFs(osFS, osFS, 10)
	fmt.Println(afero.ReadFile(cacheOnReadFs, filepath)) // $ FileSystemAccess=filepath

	// HttpFS ==> NOT OK
	fmt.Println("HttpFS:")
	httpFs := afero.NewHttpFs(osFS)
	httpFile, _ := httpFs.Open(filepath) // $ FileSystemAccess=filepath
	tmpbytes := make([]byte, 30)
	fmt.Println(httpFile.Read(tmpbytes))
	fmt.Println(string(tmpbytes))

	// osFS ==> NOT OK
	fmt.Println("Afero:")
	afs := &afero.Afero{Fs: osFS}       // $ succ=Afero pred=osFS
	afs0 := afero.Afero{Fs: osFS} // $ succ=Afero pred=osFS
    afs = &afs0
	fmt.Println(afs.ReadFile(filepath)) // $ FileSystemAccess=filepath

	// BasePathFs ==> OK
	fmt.Println("Afero:")
	newBasePathFs := afero.NewBasePathFs(osFS, "tmp")
	basePathFs0 := &afero.Afero{Fs: newBasePathFs}// $ succ=Afero pred=newBasePathFs
	// following is a FP, and in a dataflow configuration if we use Afero::additionalTaintStep then we won't have following in results
	fmt.Println(basePathFs0.ReadFile(filepath)) // $ SPURIOUS: FileSystemAccess=filepath

	// IOFS ==> OK
	fmt.Println("IOFS:")
	ioFS := afero.NewIOFS(osFS)
	fmt.Println(ioFS.ReadFile(filepath))
	fmt.Println(ioFS.Open(filepath))

	// BasePathFs ==> OK
	fmt.Println("BasePathFs:")
	basePathFs := afero.NewBasePathFs(osFS, "tmp")
	fmt.Println(afero.ReadFile(basePathFs, filepath))
	afero.ReadFile(basePathFs, filepath)
}

func Echo() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		filepath := c.QueryParam("filePath")
		return c.File(filepath) // $ FileSystemAccess=filepath
	})

	e.GET("/attachment", func(c echo.Context) error {
		filepath := c.QueryParam("filePath")
		return c.Attachment(filepath, "file name in response") // $ FileSystemAccess=filepath
	})
	_ = e.Start(":1323")
}

func Fiber() {
	app := fiber.New()
	app.Get("/b", func(c *fiber.Ctx) error {
		filepath := c.Params("filepath")
		header, _ := c.FormFile("f")
		_ = c.SaveFile(header, filepath) // $ FileSystemAccess=filepath
		return c.SendFile(filepath)      // $ FileSystemAccess=filepath
	})
	_ = app.Listen(":3000")
}

func IrisTest(ctx context.Context) {
	filepath := ctx.URLParam("filepath")
	_ = ctx.SendFile(filepath, "file")               // $ FileSystemAccess=filepath
	_ = ctx.SendFileWithRate(filepath, "file", 0, 0) // $ FileSystemAccess=filepath
	_ = ctx.ServeFile(filepath)                      // $ FileSystemAccess=filepath
	_ = ctx.ServeFileWithRate(filepath, 0, 0)        // $ FileSystemAccess=filepath
	_, _, _ = ctx.UploadFormFiles(filepath, nil)     // $ FileSystemAccess=filepath
	_, fileHeader, _ := ctx.FormFile("file")
	_, _ = ctx.SaveFormFile(fileHeader, filepath) // $ FileSystemAccess=filepath

}
func Gin() {
	router := gin.Default()
	router.POST("/FormUploads", func(c *gin.Context) {
		filepath := c.Query("filepath")
		c.File(filepath)                                    // $ FileSystemAccess=filepath
		http.ServeFile(c.Writer, c.Request, filepath)       // $ FileSystemAccess=filepath
		c.FileAttachment(filepath, "file name in response") // $ FileSystemAccess=filepath
		file, _ := c.FormFile("afile")
		_ = c.SaveUploadedFile(file, filepath) // $ FileSystemAccess=filepath
	})
	_ = router.Run()
}
