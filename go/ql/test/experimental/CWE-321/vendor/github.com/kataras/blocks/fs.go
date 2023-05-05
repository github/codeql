package blocks

import (
	"fmt"
	"io/fs"
	"net/http"
	"os"
	"path/filepath"
)

func getFS(fsOrDir interface{}) fs.FS {
	switch v := fsOrDir.(type) {
	case string:
		return os.DirFS(v)
	case http.FileSystem: // handles go-bindata.
		return &httpFS{v}
	case fs.FS:
		return v
	default:
		panic(fmt.Errorf(`blocks: unexpected "fsOrDir" argument type of %T (string or fs.FS or embed.FS or http.FileSystem)`, v))
	}
}

// walk recursively in "fileSystem" descends "root" path, calling "walkFn".
func walk(fileSystem fs.FS, root string, walkFn filepath.WalkFunc) error {
	if root != "" && root != "/" {
		sub, err := fs.Sub(fileSystem, root)
		if err != nil {
			return err
		}

		fileSystem = sub
	}

	if root == "" {
		root = "."
	}

	return fs.WalkDir(fileSystem, root, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return fmt.Errorf("%s: %w", path, err)
		}

		info, err := d.Info()
		if err != nil {
			if err != filepath.SkipDir {
				return fmt.Errorf("%s: %w", path, err)
			}

			return nil
		}

		if info.IsDir() {
			return nil
		}

		return walkFn(path, info, err)
	})

}

func asset(fileSystem fs.FS, name string) ([]byte, error) {
	return fs.ReadFile(fileSystem, name)
}

type httpFS struct {
	fs http.FileSystem
}

func (f *httpFS) Open(name string) (fs.File, error) {
	if name == "." {
		name = "/"
	}

	return f.fs.Open(filepath.ToSlash(name))
}

func (f *httpFS) ReadDir(name string) ([]fs.DirEntry, error) {
	name = filepath.ToSlash(name)
	if name == "." {
		name = "/"
	}

	file, err := f.fs.Open(name)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	infos, err := file.Readdir(-1)
	if err != nil {
		return nil, err
	}

	entries := make([]fs.DirEntry, 0, len(infos))
	for _, info := range infos {
		if info.IsDir() { // http file's does not return the whole tree, so read it.
			sub, err := f.ReadDir(info.Name())
			if err != nil {
				return nil, err
			}

			entries = append(entries, sub...)
			continue
		}

		entry := fs.FileInfoToDirEntry(info)
		entries = append(entries, entry)
	}

	return entries, nil
}
