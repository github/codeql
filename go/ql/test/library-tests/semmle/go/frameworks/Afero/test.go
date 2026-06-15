package main

//go:generate depstubber -vendor  github.com/spf13/afero Afero,RegexpFs,HttpFs,ReadOnlyFs,MemMapFs,OsFs,BasePathFs WriteReader,SafeWriteReader,WriteFile,ReadFile,ReadDir,NewOsFs,NewRegexpFs,NewReadOnlyFs,NewCacheOnReadFs,,NewHttpFs,NewBasePathFs,NewIOFS

import (
	"fmt"
	"net/http"
	"os"
	"regexp"

	"github.com/spf13/afero"
)

func main() {
	return
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
	afs := &afero.Afero{Fs: osFS} // $ succ=Afero pred=osFS
	afs0 := afero.Afero{Fs: osFS} // $ succ=Afero pred=osFS
	afs = &afs0
	fmt.Println(afs.ReadFile(filepath)) // $ FileSystemAccess=filepath

	// BasePathFs ==> OK
	fmt.Println("Afero:")
	newBasePathFs := afero.NewBasePathFs(osFS, "tmp")
	basePathFs0 := &afero.Afero{Fs: newBasePathFs} // $ succ=Afero pred=newBasePathFs
	fmt.Println(basePathFs0.ReadFile(filepath))

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
