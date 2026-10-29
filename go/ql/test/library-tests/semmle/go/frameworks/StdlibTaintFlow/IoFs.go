package main

import (
	"io/fs"
)

func walkDirCallback(path string, d fs.DirEntry, _ error) error {
	sink(14, path)
	sink(15, d)
	return nil
}

func steps() {
	{
		source := newSource(16).(fs.FileInfo)
		out := fs.FileInfoToDirEntry(source)
		sink(16, out)
	}
	{
		source := newSource(0).(fs.FS)
		out, _ := fs.Glob(source, "*")
		sink(0, out)
	}
	{
		source := newSource(1).(fs.FS)
		out, _ := fs.ReadFile(source, "filename")
		sink(1, out)
	}
	{
		source := newSource(2).(fs.FS)
		out, _ := fs.ReadDir(source, "dirname")
		sink(2, out)
	}
	{
		source := newSource(3).(fs.FS)
		out, _ := fs.Sub(source, "dirname")
		sink(3, out)
	}
	{
		source := newSource(4).(fs.FS)
		fs.WalkDir(source, ".", func(_ string, d fs.DirEntry, _ error) error {
			sink(4, d)
			return nil
		})
	}
	{
		source := newSource(5).(fs.FS)
		fs.WalkDir(source, ".", func(path string, _ fs.DirEntry, _ error) error {
			sink(5, path)
			return nil
		})
	}
	{
		source := newSource(6).(fs.DirEntry)
		out := source.Name()
		sink(6, out)
	}
	{
		source := newSource(7).(fs.DirEntry)
		out, _ := source.Info()
		sink(7, out)
	}
	{
		source := newSource(8).(fs.FS)
		out, _ := source.Open("filename")
		sink(8, out)
	}
	{
		source := newSource(9).(fs.GlobFS)
		out, _ := source.Glob("*")
		sink(9, out)
	}
	{
		source := newSource(10).(fs.ReadDirFS)
		out, _ := source.ReadDir("dirname")
		sink(10, out)
	}
	{
		source := newSource(11).(fs.ReadFileFS)
		out, _ := source.ReadFile("filename")
		sink(11, out)
	}
	{
		source := newSource(12).(fs.SubFS)
		out, _ := source.Sub("dirname")
		sink(12, out)
	}
	{
		source := newSource(13).(fs.File)
		var out []byte
		source.Read(out)
		sink(13, out)
	}
	{
		source := newSource(14).(fs.FS)
		fs.WalkDir(source, ".", walkDirCallback)
	}
	{
		source := newSource(15).(fs.FS)
		fs.WalkDir(source, ".", walkDirCallback)
	}
}
