package envconfig

import (
	"io"
	"text/template"
)

func CheckDisallowed(prefix string, cfg interface{}) error {
	return nil
}

func MustProcess(prefix string, cfg interface{}) {

}

func Process(prefix string, cfg interface{}) error {
	return nil
}

func Usage(prefix string, spec interface{}) error {
	return nil
}

func Usagef(prefix string, spec interface{}, out io.Writer, format string) error {
	return nil
}

func Usaget(prefix string, spec interface{}, out io.Writer, tmpl *template.Template) error {
	return nil
}
