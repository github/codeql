package orm

import (
	"fmt"

	"github.com/go-pg/pg/v10/types"
)

const (
	InvalidRelation = iota
	HasOneRelation
	BelongsToRelation
	HasManyRelation
	Many2ManyRelation
)

type Relation struct {
	Type        int
	Field       *Field
	JoinTable   *Table
	BaseFKs     []*Field
	JoinFKs     []*Field
	Polymorphic *Field

	M2MTableName  types.Safe
	M2MTableAlias types.Safe
	M2MBaseFKs    []string
	M2MJoinFKs    []string
}

func (r *Relation) String() string {
	return fmt.Sprintf("relation=%s", r.Field.GoName)
}
