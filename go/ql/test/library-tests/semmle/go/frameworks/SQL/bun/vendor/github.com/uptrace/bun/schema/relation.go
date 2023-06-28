package schema

import (
	"fmt"
)

const (
	InvalidRelation = iota
	HasOneRelation
	BelongsToRelation
	HasManyRelation
	ManyToManyRelation
)

type Relation struct {
	Type       int
	Field      *Field
	JoinTable  *Table
	BaseFields []*Field
	JoinFields []*Field
	OnUpdate   string
	OnDelete   string
	Condition  []string

	PolymorphicField *Field
	PolymorphicValue string

	M2MTable      *Table
	M2MBaseFields []*Field
	M2MJoinFields []*Field
}

func (r *Relation) String() string {
	return fmt.Sprintf("relation=%s", r.Field.GoName)
}
