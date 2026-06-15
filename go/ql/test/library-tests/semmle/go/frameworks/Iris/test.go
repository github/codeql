package iris

//go:generate depstubber -vendor github.com/kataras/iris/v12/context Context

import "github.com/kataras/iris/v12/context"

func FileSystemAccess(ctx context.Context) {
	filepath := ctx.URLParam("filepath")
	_ = ctx.SendFile(filepath, "file")               // $ FileSystemAccess=filepath
	_ = ctx.SendFileWithRate(filepath, "file", 0, 0) // $ FileSystemAccess=filepath
	_ = ctx.ServeFile(filepath)                      // $ FileSystemAccess=filepath
	_ = ctx.ServeFileWithRate(filepath, 0, 0)        // $ FileSystemAccess=filepath
	_, _, _ = ctx.UploadFormFiles(filepath, nil)     // $ FileSystemAccess=filepath
	_, fileHeader, _ := ctx.FormFile("file")
	_, _ = ctx.SaveFormFile(fileHeader, filepath) // $ FileSystemAccess=filepath
}
