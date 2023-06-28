package sqlitedialect

import (
	"reflect"

	"github.com/uptrace/bun/schema"
)

func scanner(typ reflect.Type) schema.ScannerFunc {
	return schema.Scanner(typ)
}
