package pkg2

type T struct {
	g int
}

type G struct {
	g int
}

type MixedExportedAndNot interface {
	Exported()
	notExported()
}
