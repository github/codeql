package dbscheme

import (
	"fmt"
	"io"
	"log"
	"reflect"
	"strings"

	"github.com/github/codeql-go/extractor/trap"
)

// A Type represents a database type
type Type interface {
	def() string
	ref() string
	repr() string
	valid(val interface{}) bool
}

// A PrimitiveType represents a primitive dataase type
type PrimitiveType int

const (
	// INT represents the primitive database type `int`
	INT PrimitiveType = iota
	// FLOAT represents the primitive database type `float`
	FLOAT
	// BOOLEAN represents the primitive database type `boolean`
	BOOLEAN
	// DATE represents the primitive database type `date`
	DATE
	// STRING represents the primitive database type `string`
	STRING
)

// A PrimaryKeyType represents a database type defined by a primary key column
type PrimaryKeyType struct {
	name string
}

// A UnionType represents a database type defined as the union of other database types
type UnionType struct {
	name       string
	components []Type
}

// An AliasType represents a database type which is an alias of another database type
type AliasType struct {
	name       string
	underlying Type
}

// A CaseType represents a database type defined by a primary key column with a supplementary kind column
type CaseType struct {
	base     Type
	column   string
	branches []*BranchType
}

// A BranchType represents one branch of a case type
type BranchType struct {
	idx  int
	name string
}

func (pt PrimitiveType) def() string {
	return ""
}

func (pt PrimitiveType) ref() string {
	switch pt {
	case INT:
		return "int"
	case FLOAT:
		return "float"
	case BOOLEAN:
		return "boolean"
	case DATE:
		return "date"
	case STRING:
		return "string"
	default:
		panic(fmt.Sprintf("Unexpected primitive type %d", pt))
	}
}

func (pt PrimitiveType) repr() string {
	switch pt {
	case INT:
		return "int"
	case FLOAT:
		return "float"
	case BOOLEAN:
		return "boolean"
	case DATE:
		return "date"
	case STRING:
		return "string"
	default:
		panic(fmt.Sprintf("Unexpected primitive type %d", pt))
	}
}

func (pt PrimitiveType) valid(value interface{}) bool {
	switch value.(type) {
	case int:
		return pt == INT
	case float64:
		return pt == FLOAT
	case bool:
		return pt == BOOLEAN
	case string:
		return pt == STRING
	}
	return false
}

func (pkt PrimaryKeyType) def() string {
	return ""
}

func (pkt PrimaryKeyType) ref() string {
	return pkt.name
}

func (pkt PrimaryKeyType) repr() string {
	return "int"
}

func (pkt PrimaryKeyType) valid(value interface{}) bool {
	_, ok := value.(trap.Label)
	return ok
}

func (ut UnionType) def() string {
	var b strings.Builder
	nl := 0
	fmt.Fprintf(&b, "%s = ", ut.name)
	for i, comp := range ut.components {
		if i > 0 {
			if i < len(ut.components)-1 && b.Len()-nl > 100 {
				fmt.Fprintf(&b, "\n%s", strings.Repeat(" ", len(ut.name)))
				nl = b.Len()
			}
			fmt.Fprint(&b, " | ")
		}
		fmt.Fprint(&b, comp.ref())
	}
	fmt.Fprint(&b, ";")
	return b.String()
}

func (ut UnionType) ref() string {
	return ut.name
}

func (ut UnionType) repr() string {
	return "int"
}

func (ut UnionType) valid(value interface{}) bool {
	_, ok := value.(trap.Label)
	return ok
}

func (at AliasType) def() string {
	return at.name + " = " + at.underlying.ref() + ";"
}

func (at AliasType) ref() string {
	return at.name
}

func (at AliasType) repr() string {
	return at.underlying.repr()
}

func (at AliasType) valid(value interface{}) bool {
	return at.underlying.valid(value)
}

func (ct CaseType) def() string {
	var b strings.Builder
	fmt.Fprintf(&b, "case %s.%s of", ct.base.ref(), ct.column)
	sep := "  "
	for _, branch := range ct.branches {
		fmt.Fprintf(&b, "\n%s%s", sep, branch.def())
		sep = "| "
	}
	fmt.Fprint(&b, ";")
	return b.String()
}

func (ct CaseType) ref() string {
	panic("case types do not have a name")
}

func (ct CaseType) repr() string {
	return "int"
}

func (ct CaseType) valid(value interface{}) bool {
	_, ok := value.(trap.Label)
	return ok
}

func (bt BranchType) def() string {
	return fmt.Sprintf("%d = %s", bt.idx, bt.name)
}

func (bt BranchType) ref() string {
	return bt.name
}

func (bt BranchType) repr() string {
	return "int"
}

func (bt BranchType) valid(value interface{}) bool {
	_, ok := value.(trap.Label)
	return ok
}

// Index returns the numeric index of this branch type
func (bt BranchType) Index() int {
	return bt.idx
}

// A Column represents a column in a database table
type Column struct {
	columnName string
	columnType Type
	unique     bool
	ref        bool
}

func (col Column) String() string {
	var b strings.Builder
	if col.unique {
		fmt.Fprint(&b, "unique ")
	}
	fmt.Fprintf(&b, "%s %s: %s", col.columnType.repr(), col.columnName, col.columnType.ref())
	if col.ref {
		fmt.Fprint(&b, " ref")
	}
	return b.String()
}

// Key returns a new column that is the same as this column, but has the `key` flag set to `true`
func (col Column) Key() Column {
	return Column{col.columnName, col.columnType, true, false}
}

// Unique returns a new column that is the same as this column, but has the `unique` flag set to `true`
func (col Column) Unique() Column {
	return Column{col.columnName, col.columnType, true, col.ref}
}

// EntityColumn constructs a column with name `columnName` holding entities of type `columnType`
func EntityColumn(columnType Type, columnName string) Column {
	return Column{columnName, columnType, false, true}
}

// StringColumn constructs a column with name `columnName` holding string values
func StringColumn(columnName string) Column {
	return Column{columnName, STRING, false, true}
}

// IntColumn constructs a column with name `columnName` holding integer values
func IntColumn(columnName string) Column {
	return Column{columnName, INT, false, true}
}

// FloatColumn constructs a column with name `columnName` holding floating point number values
func FloatColumn(columnName string) Column {
	return Column{columnName, FLOAT, false, true}
}

// A Table represents a database table
type Table struct {
	name    string
	schema  []Column
	keysets [][]string
}

// KeySet adds `keys` as a keyset to this table
func (tbl *Table) KeySet(keys ...string) *Table {
	tbl.keysets = append(tbl.keysets, keys)
	return tbl
}

func (tbl Table) String() string {
	var b strings.Builder
	for _, keyset := range tbl.keysets {
		fmt.Fprint(&b, "#keyset[")
		sep := ""
		for _, key := range keyset {
			fmt.Fprintf(&b, "%s%s", sep, key)
			sep = ", "
		}
		fmt.Fprint(&b, "]\n")
	}
	fmt.Fprint(&b, tbl.name)
	fmt.Fprint(&b, "(")
	nl := 0
	for i, column := range tbl.schema {
		if i > 0 {
			// wrap >100 char lines
			if i < len(tbl.schema)-1 && b.Len()-nl > 100 {
				fmt.Fprintf(&b, ",\n%s", strings.Repeat(" ", len(tbl.name)+1))
				nl = b.Len()
			} else {
				fmt.Fprint(&b, ", ")
			}
		}
		fmt.Fprint(&b, column.String())
	}
	fmt.Fprint(&b, ");")
	return b.String()
}

// Emit outputs a tuple of `values` for this table using trap writer `tw`
// and panicks if the tuple does not have the right schema
func (tbl Table) Emit(tw *trap.Writer, values ...interface{}) {
	if ncol, nval := len(tbl.schema), len(values); ncol != nval {
		log.Fatalf("wrong number of values for table %s; expected %d, but got %d", tbl.name, ncol, nval)
	}
	for i, col := range tbl.schema {
		if !col.columnType.valid(values[i]) {
			panic(fmt.Sprintf("Invalid value for column %d of table %s; expected a %s, but got %s which is a %s", i, tbl.name, col.columnType.ref(), values[i], reflect.TypeOf(values[i])))
		}
	}
	tw.Emit(tbl.name, values)
}

var tables = []*Table{}
var types = []Type{}
var defaultSnippets = []string{}

// NewTable constructs a new table with the given `name` and `columns`
func NewTable(name string, columns ...Column) *Table {
	tbl := &Table{name, columns, [][]string{}}
	tables = append(tables, tbl)
	return tbl
}

// NewPrimaryKeyType constructs a new primary key type with the given `name`,
// and adds it to the union types `parents` (if any)
func NewPrimaryKeyType(name string, parents ...*UnionType) *PrimaryKeyType {
	tp := &PrimaryKeyType{name}
	types = append(types, tp)
	for _, parent := range parents {
		parent.components = append(parent.components, tp)
	}
	return tp
}

// NewUnionType constructs a new union type with the given `name`,
// and adds it to the union types `parents` (if any)
func NewUnionType(name string, parents ...*UnionType) *UnionType {
	tp := &UnionType{name, []Type{}}
	types = append(types, tp)
	for _, parent := range parents {
		parent.components = append(parent.components, tp)
	}
	return tp
}

// AddChild adds the type with given `name` to the union type.
// This is useful if a type defined in a snippet should be a child of a type defined in Go.
func (parent *UnionType) AddChild(name string) bool {
	tp := &PrimaryKeyType{name}
	// don't add tp to types; it's expected that it's already in the db somehow.
	parent.components = append(parent.components, tp)
	return true
}

// NewAliasType constructs a new alias type with the given `name` that aliases `underlying`
func NewAliasType(name string, underlying Type) *AliasType {
	tp := &AliasType{name, underlying}
	types = append(types, tp)
	return tp
}

// NewCaseType constructs a new case type on the given `base` type whose discriminator values
// come from `column`
func NewCaseType(base Type, column string) *CaseType {
	tp := &CaseType{base, column, []*BranchType{}}
	types = append(types, tp)
	return tp
}

// NewBranch adds a new branch with the given `name` to this case type
// and adds it to the union types `parents` (if any)
func (ct *CaseType) NewBranch(name string, parents ...*UnionType) *BranchType {
	tp := &BranchType{len(ct.branches), name}
	ct.branches = append(ct.branches, tp)
	for _, parent := range parents {
		parent.components = append(parent.components, tp)
	}
	return tp
}

// AddDefaultSnippet adds the given text `snippet` to the schema of this database
func AddDefaultSnippet(snippet string) bool {
	defaultSnippets = append(defaultSnippets, snippet)
	return true
}

// PrintDbScheme prints the schema of this database to the writer `w`
func PrintDbScheme(w io.Writer) {
	fmt.Fprintf(w, "/** Auto-generated dbscheme; do not edit. */\n\n")
	for _, snippet := range defaultSnippets {
		fmt.Fprintf(w, "%s\n", snippet)
	}
	for _, table := range tables {
		fmt.Fprintf(w, "%s\n\n", table.String())
	}
	for _, tp := range types {
		def := tp.def()
		if def != "" {
			fmt.Fprintf(w, "%s\n\n", def)
		}
	}
}
