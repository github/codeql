package orm

import (
	"fmt"
	"reflect"

	"github.com/go-pg/pg/v10/types"
)

type TableModel interface {
	Model

	IsNil() bool
	Table() *Table
	Relation() *Relation
	AppendParam(QueryFormatter, []byte, string) ([]byte, bool)

	Join(string, func(*Query) (*Query, error)) *join
	GetJoin(string) *join
	GetJoins() []join
	AddJoin(join) *join

	Root() reflect.Value
	Index() []int
	ParentIndex() []int
	Mount(reflect.Value)
	Kind() reflect.Kind
	Value() reflect.Value

	setSoftDeleteField() error
	scanColumn(types.ColumnInfo, types.Reader, int) (bool, error)
}

func newTableModelIndex(typ reflect.Type, root reflect.Value, index []int, rel *Relation) (TableModel, error) {
	typ = typeByIndex(typ, index)

	if typ.Kind() == reflect.Struct {
		return &structTableModel{
			table: GetTable(typ),
			rel:   rel,

			root:  root,
			index: index,
		}, nil
	}

	if typ.Kind() == reflect.Slice {
		structType := indirectType(typ.Elem())
		if structType.Kind() == reflect.Struct {
			m := sliceTableModel{
				structTableModel: structTableModel{
					table: GetTable(structType),
					rel:   rel,

					root:  root,
					index: index,
				},
			}
			m.init(typ)
			return &m, nil
		}
	}

	return nil, fmt.Errorf("pg: NewModel(%s)", typ)
}
