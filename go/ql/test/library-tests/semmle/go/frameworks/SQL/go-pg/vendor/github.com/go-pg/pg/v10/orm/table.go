package orm

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net"
	"reflect"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/jinzhu/inflection"
	"github.com/vmihailenco/tagparser"

	"github.com/go-pg/zerochecker"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/pgjson"
	"github.com/go-pg/pg/v10/types"
)

const (
	beforeScanHookFlag = uint16(1) << iota
	afterScanHookFlag
	afterSelectHookFlag
	beforeInsertHookFlag
	afterInsertHookFlag
	beforeUpdateHookFlag
	afterUpdateHookFlag
	beforeDeleteHookFlag
	afterDeleteHookFlag
	discardUnknownColumnsFlag
)

var (
	timeType           = reflect.TypeOf((*time.Time)(nil)).Elem()
	nullTimeType       = reflect.TypeOf((*types.NullTime)(nil)).Elem()
	sqlNullTimeType    = reflect.TypeOf((*sql.NullTime)(nil)).Elem()
	ipType             = reflect.TypeOf((*net.IP)(nil)).Elem()
	ipNetType          = reflect.TypeOf((*net.IPNet)(nil)).Elem()
	scannerType        = reflect.TypeOf((*sql.Scanner)(nil)).Elem()
	nullBoolType       = reflect.TypeOf((*sql.NullBool)(nil)).Elem()
	nullFloatType      = reflect.TypeOf((*sql.NullFloat64)(nil)).Elem()
	nullIntType        = reflect.TypeOf((*sql.NullInt64)(nil)).Elem()
	nullStringType     = reflect.TypeOf((*sql.NullString)(nil)).Elem()
	jsonRawMessageType = reflect.TypeOf((*json.RawMessage)(nil)).Elem()
)

var tableNameInflector = inflection.Plural

// SetTableNameInflector overrides the default func that pluralizes
// model name to get table name, e.g. my_article becomes my_articles.
func SetTableNameInflector(fn func(string) string) {
	tableNameInflector = fn
}

// Table represents a SQL table created from Go struct.
type Table struct {
	Type       reflect.Type
	zeroStruct reflect.Value

	TypeName  string
	Alias     types.Safe
	ModelName string

	SQLName           types.Safe
	SQLNameForSelects types.Safe

	Tablespace types.Safe

	PartitionBy string

	allFields     []*Field // read only
	skippedFields []*Field

	Fields      []*Field // PKs + DataFields
	PKs         []*Field
	DataFields  []*Field
	fieldsMapMu sync.RWMutex
	FieldsMap   map[string]*Field

	Methods   map[string]*Method
	Relations map[string]*Relation
	Unique    map[string][]*Field

	SoftDeleteField    *Field
	SetSoftDeleteField func(fv reflect.Value) error

	flags uint16
}

func newTable(typ reflect.Type) *Table {
	t := new(Table)
	t.Type = typ
	t.zeroStruct = reflect.New(t.Type).Elem()
	t.TypeName = internal.ToExported(t.Type.Name())
	t.ModelName = internal.Underscore(t.Type.Name())
	tableName := tableNameInflector(t.ModelName)
	t.setName(quoteIdent(tableName))
	t.Alias = quoteIdent(t.ModelName)

	typ = reflect.PtrTo(t.Type)
	if typ.Implements(beforeScanHookType) {
		t.setFlag(beforeScanHookFlag)
	}
	if typ.Implements(afterScanHookType) {
		t.setFlag(afterScanHookFlag)
	}
	if typ.Implements(afterSelectHookType) {
		t.setFlag(afterSelectHookFlag)
	}
	if typ.Implements(beforeInsertHookType) {
		t.setFlag(beforeInsertHookFlag)
	}
	if typ.Implements(afterInsertHookType) {
		t.setFlag(afterInsertHookFlag)
	}
	if typ.Implements(beforeUpdateHookType) {
		t.setFlag(beforeUpdateHookFlag)
	}
	if typ.Implements(afterUpdateHookType) {
		t.setFlag(afterUpdateHookFlag)
	}
	if typ.Implements(beforeDeleteHookType) {
		t.setFlag(beforeDeleteHookFlag)
	}
	if typ.Implements(afterDeleteHookType) {
		t.setFlag(afterDeleteHookFlag)
	}

	return t
}

func (t *Table) init1() {
	t.initFields()
	t.initMethods()
}

func (t *Table) init2() {
	t.initInlines()
	t.initRelations()
	t.skippedFields = nil
}

func (t *Table) setName(name types.Safe) {
	t.SQLName = name
	t.SQLNameForSelects = name
	if t.Alias == "" {
		t.Alias = name
	}
}

func (t *Table) String() string {
	return "model=" + t.TypeName
}

func (t *Table) setFlag(flag uint16) {
	t.flags |= flag
}

func (t *Table) hasFlag(flag uint16) bool {
	if t == nil {
		return false
	}
	return t.flags&flag != 0
}

func (t *Table) checkPKs() error {
	if len(t.PKs) == 0 {
		return fmt.Errorf("pg: %s does not have primary keys", t)
	}
	return nil
}

func (t *Table) mustSoftDelete() error {
	if t.SoftDeleteField == nil {
		return fmt.Errorf("pg: %s does not support soft deletes", t)
	}
	return nil
}

func (t *Table) AddField(field *Field) {
	t.Fields = append(t.Fields, field)
	if field.hasFlag(PrimaryKeyFlag) {
		t.PKs = append(t.PKs, field)
	} else {
		t.DataFields = append(t.DataFields, field)
	}
	t.FieldsMap[field.SQLName] = field
}

func (t *Table) RemoveField(field *Field) {
	t.Fields = removeField(t.Fields, field)
	if field.hasFlag(PrimaryKeyFlag) {
		t.PKs = removeField(t.PKs, field)
	} else {
		t.DataFields = removeField(t.DataFields, field)
	}
	delete(t.FieldsMap, field.SQLName)
}

func removeField(fields []*Field, field *Field) []*Field {
	for i, f := range fields {
		if f == field {
			fields = append(fields[:i], fields[i+1:]...)
		}
	}
	return fields
}

func (t *Table) getField(name string) *Field {
	t.fieldsMapMu.RLock()
	field := t.FieldsMap[name]
	t.fieldsMapMu.RUnlock()
	return field
}

func (t *Table) HasField(name string) bool {
	_, ok := t.FieldsMap[name]
	return ok
}

func (t *Table) GetField(name string) (*Field, error) {
	field, ok := t.FieldsMap[name]
	if !ok {
		return nil, fmt.Errorf("pg: %s does not have column=%s", t, name)
	}
	return field, nil
}

func (t *Table) AppendParam(b []byte, strct reflect.Value, name string) ([]byte, bool) {
	field, ok := t.FieldsMap[name]
	if ok {
		b = field.AppendValue(b, strct, 1)
		return b, true
	}

	method, ok := t.Methods[name]
	if ok {
		b = method.AppendValue(b, strct.Addr(), 1)
		return b, true
	}

	return b, false
}

func (t *Table) initFields() {
	t.Fields = make([]*Field, 0, t.Type.NumField())
	t.FieldsMap = make(map[string]*Field, t.Type.NumField())
	t.addFields(t.Type, nil)
}

func (t *Table) addFields(typ reflect.Type, baseIndex []int) {
	for i := 0; i < typ.NumField(); i++ {
		f := typ.Field(i)

		// Make a copy so slice is not shared between fields.
		index := make([]int, len(baseIndex))
		copy(index, baseIndex)

		if f.Anonymous {
			if f.Tag.Get("sql") == "-" || f.Tag.Get("pg") == "-" {
				continue
			}

			fieldType := indirectType(f.Type)
			if fieldType.Kind() != reflect.Struct {
				continue
			}
			t.addFields(fieldType, append(index, f.Index...))

			pgTag := tagparser.Parse(f.Tag.Get("pg"))
			if _, inherit := pgTag.Options["inherit"]; inherit {
				embeddedTable := _tables.get(fieldType, true)
				t.TypeName = embeddedTable.TypeName
				t.SQLName = embeddedTable.SQLName
				t.SQLNameForSelects = embeddedTable.SQLNameForSelects
				t.Alias = embeddedTable.Alias
				t.ModelName = embeddedTable.ModelName
			}

			continue
		}

		field := t.newField(f, index)
		if field != nil {
			t.AddField(field)
		}
	}
}

//nolint
func (t *Table) newField(f reflect.StructField, index []int) *Field {
	pgTag := tagparser.Parse(f.Tag.Get("pg"))

	switch f.Name {
	case "tableName":
		if len(index) > 0 {
			return nil
		}

		if isKnownTableOption(pgTag.Name) {
			internal.Warn.Printf(
				"%s.%s tag name %q is also an option name; is it a mistake?",
				t.TypeName, f.Name, pgTag.Name,
			)
		}

		for name := range pgTag.Options {
			if !isKnownTableOption(name) {
				internal.Warn.Printf("%s.%s has unknown tag option: %q", t.TypeName, f.Name, name)
			}
		}

		if tableSpace, ok := pgTag.Options["tablespace"]; ok {
			s, _ := tagparser.Unquote(tableSpace)
			t.Tablespace = quoteIdent(s)
		}

		partitionBy, ok := pgTag.Options["partition_by"]
		if !ok {
			partitionBy, ok = pgTag.Options["partitionBy"]
			if ok {
				internal.Deprecated.Printf("partitionBy is renamed to partition_by")
			}
		}
		if ok {
			s, _ := tagparser.Unquote(partitionBy)
			t.PartitionBy = s
		}

		if pgTag.Name == "_" {
			t.setName("")
		} else if pgTag.Name != "" {
			s, _ := tagparser.Unquote(pgTag.Name)
			t.setName(types.Safe(quoteTableName(s)))
		}

		if s, ok := pgTag.Options["select"]; ok {
			s, _ = tagparser.Unquote(s)
			t.SQLNameForSelects = types.Safe(quoteTableName(s))
		}

		if v, ok := pgTag.Options["alias"]; ok {
			v, _ = tagparser.Unquote(v)
			t.Alias = quoteIdent(v)
		}

		pgTag := tagparser.Parse(f.Tag.Get("pg"))
		if _, ok := pgTag.Options["discard_unknown_columns"]; ok {
			t.setFlag(discardUnknownColumnsFlag)
		}

		return nil
	}

	if f.PkgPath != "" {
		return nil
	}

	sqlName := internal.Underscore(f.Name)

	if pgTag.Name != sqlName && isKnownFieldOption(pgTag.Name) {
		internal.Warn.Printf(
			"%s.%s tag name %q is also an option name; is it a mistake?",
			t.TypeName, f.Name, pgTag.Name,
		)
	}

	for name := range pgTag.Options {
		if !isKnownFieldOption(name) {
			internal.Warn.Printf("%s.%s has unknown tag option: %q", t.TypeName, f.Name, name)
		}
	}

	skip := pgTag.Name == "-"
	if !skip && pgTag.Name != "" {
		sqlName = pgTag.Name
	}

	index = append(index, f.Index...)
	if field := t.getField(sqlName); field != nil {
		if indexEqual(field.Index, index) {
			return field
		}
		t.RemoveField(field)
	}

	field := &Field{
		Field: f,
		Type:  indirectType(f.Type),

		GoName:  f.Name,
		SQLName: sqlName,
		Column:  quoteIdent(sqlName),

		Index: index,
	}

	if _, ok := pgTag.Options["notnull"]; ok {
		field.setFlag(NotNullFlag)
	}
	if v, ok := pgTag.Options["unique"]; ok {
		if v == "" {
			field.setFlag(UniqueFlag)
		}
		// Split the value by comma, this will allow multiple names to be specified.
		// We can use this to create multiple named unique constraints where a single column
		// might be included in multiple constraints.
		v, _ = tagparser.Unquote(v)
		for _, uniqueName := range strings.Split(v, ",") {
			if t.Unique == nil {
				t.Unique = make(map[string][]*Field)
			}
			t.Unique[uniqueName] = append(t.Unique[uniqueName], field)
		}
	}
	if v, ok := pgTag.Options["default"]; ok {
		v, ok = tagparser.Unquote(v)
		if ok {
			field.Default = types.Safe(types.AppendString(nil, v, 1))
		} else {
			field.Default = types.Safe(v)
		}
	}

	//nolint
	if _, ok := pgTag.Options["pk"]; ok {
		field.setFlag(PrimaryKeyFlag)
	} else if strings.HasSuffix(field.SQLName, "_id") ||
		strings.HasSuffix(field.SQLName, "_uuid") {
		field.setFlag(ForeignKeyFlag)
	} else if strings.HasPrefix(field.SQLName, "fk_") {
		field.setFlag(ForeignKeyFlag)
	} else if len(t.PKs) == 0 && !pgTag.HasOption("nopk") {
		switch field.SQLName {
		case "id", "uuid", "pk_" + t.ModelName:
			field.setFlag(PrimaryKeyFlag)
		}
	}

	if _, ok := pgTag.Options["use_zero"]; ok {
		field.setFlag(UseZeroFlag)
	}
	if _, ok := pgTag.Options["array"]; ok {
		field.setFlag(ArrayFlag)
	}

	field.SQLType = fieldSQLType(field, pgTag)
	if strings.HasSuffix(field.SQLType, "[]") {
		field.setFlag(ArrayFlag)
	}

	if v, ok := pgTag.Options["on_delete"]; ok {
		field.OnDelete = v
	}

	if v, ok := pgTag.Options["on_update"]; ok {
		field.OnUpdate = v
	}

	if _, ok := pgTag.Options["composite"]; ok {
		field.append = compositeAppender(f.Type)
		field.scan = compositeScanner(f.Type)
	} else if _, ok := pgTag.Options["json_use_number"]; ok {
		field.append = types.Appender(f.Type)
		field.scan = scanJSONValue
	} else if field.hasFlag(ArrayFlag) {
		field.append = types.ArrayAppender(f.Type)
		field.scan = types.ArrayScanner(f.Type)
	} else if _, ok := pgTag.Options["hstore"]; ok {
		field.append = types.HstoreAppender(f.Type)
		field.scan = types.HstoreScanner(f.Type)
	} else if field.SQLType == pgTypeBigint && field.Type.Kind() == reflect.Uint64 {
		if f.Type.Kind() == reflect.Ptr {
			field.append = appendUintPtrAsInt
		} else {
			field.append = appendUintAsInt
		}
		field.scan = types.Scanner(f.Type)
	} else if _, ok := pgTag.Options["msgpack"]; ok {
		field.append = msgpackAppender(f.Type)
		field.scan = msgpackScanner(f.Type)
	} else {
		field.append = types.Appender(f.Type)
		field.scan = types.Scanner(f.Type)
	}
	field.isZero = zerochecker.Checker(f.Type)

	if v, ok := pgTag.Options["alias"]; ok {
		v, _ = tagparser.Unquote(v)
		t.FieldsMap[v] = field
	}

	t.allFields = append(t.allFields, field)
	if skip {
		t.skippedFields = append(t.skippedFields, field)
		t.FieldsMap[field.SQLName] = field
		return nil
	}

	if _, ok := pgTag.Options["soft_delete"]; ok {
		t.SetSoftDeleteField = setSoftDeleteFieldFunc(f.Type)
		if t.SetSoftDeleteField == nil {
			err := fmt.Errorf(
				"pg: soft_delete is only supported for time.Time, pg.NullTime, sql.NullInt64, and int64 (or implement ValueScanner that scans time)")
			panic(err)
		}
		t.SoftDeleteField = field
	}

	return field
}

func (t *Table) initMethods() {
	t.Methods = make(map[string]*Method)
	typ := reflect.PtrTo(t.Type)
	for i := 0; i < typ.NumMethod(); i++ {
		m := typ.Method(i)
		if m.PkgPath != "" {
			continue
		}
		if m.Type.NumIn() > 1 {
			continue
		}
		if m.Type.NumOut() != 1 {
			continue
		}

		retType := m.Type.Out(0)
		t.Methods[m.Name] = &Method{
			Index: m.Index,

			appender: types.Appender(retType),
		}
	}
}

func (t *Table) initInlines() {
	for _, f := range t.skippedFields {
		if f.Type.Kind() == reflect.Struct {
			t.inlineFields(f, nil)
		}
	}
}

func (t *Table) initRelations() {
	for i := 0; i < len(t.Fields); {
		f := t.Fields[i]
		if t.tryRelation(f) {
			t.Fields = removeField(t.Fields, f)
			t.DataFields = removeField(t.DataFields, f)
		} else {
			i++
		}

		if f.Type.Kind() == reflect.Struct {
			t.inlineFields(f, nil)
		}
	}
}

func (t *Table) tryRelation(field *Field) bool {
	pgTag := tagparser.Parse(field.Field.Tag.Get("pg"))

	if rel, ok := pgTag.Options["rel"]; ok {
		return t.tryRelationType(field, rel, pgTag)
	}
	if _, ok := pgTag.Options["many2many"]; ok {
		return t.tryRelationType(field, "many2many", pgTag)
	}

	if field.UserSQLType != "" || isScanner(field.Type) {
		return false
	}

	switch field.Type.Kind() {
	case reflect.Slice:
		return t.tryRelationSlice(field, pgTag)
	case reflect.Struct:
		return t.tryRelationStruct(field, pgTag)
	}
	return false
}

func (t *Table) tryRelationType(field *Field, rel string, pgTag *tagparser.Tag) bool {
	switch rel {
	case "has-one":
		return t.mustHasOneRelation(field, pgTag)
	case "belongs-to":
		return t.mustBelongsToRelation(field, pgTag)
	case "has-many":
		return t.mustHasManyRelation(field, pgTag)
	case "many2many":
		return t.mustM2MRelation(field, pgTag)
	default:
		panic(fmt.Errorf("pg: unknown relation=%s on field=%s", rel, field.GoName))
	}
}

func (t *Table) mustHasOneRelation(field *Field, pgTag *tagparser.Tag) bool {
	joinTable := _tables.get(field.Type, true)
	joinPKs := joinTable.PKs

	joinFKPrefix, joinFKOK := pgTag.Options["join_fk"]

	if err := joinTable.checkPKs(); err != nil && !joinFKOK {
		// join performed by primary key if join_fk not specified
		// so join table must have primary key
		panic(err)
	}

	if joinFKOK {
		joinField := joinTable.getField(joinFKPrefix)
		if joinField == nil {
			panic(fmt.Errorf(
				"pg: %s has-one %s: field %s specified by join_fk doesn't exist on %s",
				t.TypeName, field.GoName, joinFKPrefix, joinTable.TypeName,
			))
		}

		joinPKs = []*Field{joinField}
	}

	fkPrefix, fkOK := pgTag.Options["fk"]

	if fkOK && len(joinPKs) == 1 {
		fk := t.getField(fkPrefix)
		if fk == nil {
			panic(fmt.Errorf(
				"pg: %s has-one %s: %s must have column %s "+
					"(use fk:custom_column tag on %s field to specify custom column)",
				t.TypeName, field.GoName, t.TypeName, fkPrefix, field.GoName,
			))
		}

		t.addRelation(&Relation{
			Type:      HasOneRelation,
			Field:     field,
			JoinTable: joinTable,
			BaseFKs:   []*Field{fk},
			JoinFKs:   joinPKs,
		})
		return true
	}

	if !fkOK {
		fkPrefix = internal.Underscore(field.GoName) + "_"
	}
	fks := make([]*Field, 0, len(joinPKs))

	for _, joinPK := range joinPKs {
		fkName := fkPrefix + joinPK.SQLName
		if fk := t.getField(fkName); fk != nil {
			fks = append(fks, fk)
			continue
		}

		if fk := t.getField(joinPK.SQLName); fk != nil {
			fks = append(fks, fk)
			continue
		}

		panic(fmt.Errorf(
			"pg: %s has-one %s: %s must have column %s "+
				"(use fk:custom_column tag on %s field to specify custom column)",
			t.TypeName, field.GoName, t.TypeName, fkName, field.GoName,
		))
	}

	t.addRelation(&Relation{
		Type:      HasOneRelation,
		Field:     field,
		JoinTable: joinTable,
		BaseFKs:   fks,
		JoinFKs:   joinPKs,
	})
	return true
}

func (t *Table) mustBelongsToRelation(field *Field, pgTag *tagparser.Tag) bool {
	if err := t.checkPKs(); err != nil {
		panic(err)
	}
	joinTable := _tables.get(field.Type, true)
	fkPrefix, fkOK := pgTag.Options["join_fk"]

	if fkOK && len(t.PKs) == 1 {
		fk := joinTable.getField(fkPrefix)
		if fk == nil {
			panic(fmt.Errorf(
				"pg: %s belongs-to %s: %s must have column %s "+
					"(use join_fk:custom_column tag on %s field to specify custom column)",
				field.GoName, t.TypeName, joinTable.TypeName, fkPrefix, field.GoName,
			))
		}

		t.addRelation(&Relation{
			Type:      BelongsToRelation,
			Field:     field,
			JoinTable: joinTable,
			BaseFKs:   t.PKs,
			JoinFKs:   []*Field{fk},
		})
		return true
	}

	if !fkOK {
		fkPrefix = internal.Underscore(t.ModelName) + "_"
	}
	fks := make([]*Field, 0, len(t.PKs))

	for _, pk := range t.PKs {
		fkName := fkPrefix + pk.SQLName
		if fk := joinTable.getField(fkName); fk != nil {
			fks = append(fks, fk)
			continue
		}

		if fk := joinTable.getField(pk.SQLName); fk != nil {
			fks = append(fks, fk)
			continue
		}

		panic(fmt.Errorf(
			"pg: %s belongs-to %s: %s must have column %s "+
				"(use join_fk:custom_column tag on %s field to specify custom column)",
			field.GoName, t.TypeName, joinTable.TypeName, fkName, field.GoName,
		))
	}

	t.addRelation(&Relation{
		Type:      BelongsToRelation,
		Field:     field,
		JoinTable: joinTable,
		BaseFKs:   t.PKs,
		JoinFKs:   fks,
	})
	return true
}

func (t *Table) mustHasManyRelation(field *Field, pgTag *tagparser.Tag) bool {
	if err := t.checkPKs(); err != nil {
		panic(err)
	}
	if field.Type.Kind() != reflect.Slice {
		panic(fmt.Errorf(
			"pg: %s.%s has-many relation requires slice, got %q",
			t.TypeName, field.GoName, field.Type.Kind(),
		))
	}

	joinTable := _tables.get(indirectType(field.Type.Elem()), true)
	fkPrefix, fkOK := pgTag.Options["join_fk"]
	_, polymorphic := pgTag.Options["polymorphic"]

	if fkOK && !polymorphic && len(t.PKs) == 1 {
		fk := joinTable.getField(fkPrefix)
		if fk == nil {
			panic(fmt.Errorf(
				"pg: %s has-many %s: %s must have column %s "+
					"(use join_fk:custom_column tag on %s field to specify custom column)",
				t.TypeName, field.GoName, joinTable.TypeName, fkPrefix, field.GoName,
			))
		}

		t.addRelation(&Relation{
			Type:      HasManyRelation,
			Field:     field,
			JoinTable: joinTable,
			BaseFKs:   t.PKs,
			JoinFKs:   []*Field{fk},
		})
		return true
	}

	if !fkOK {
		fkPrefix = internal.Underscore(t.ModelName) + "_"
	}
	fks := make([]*Field, 0, len(t.PKs))

	for _, pk := range t.PKs {
		fkName := fkPrefix + pk.SQLName
		if fk := joinTable.getField(fkName); fk != nil {
			fks = append(fks, fk)
			continue
		}

		if fk := joinTable.getField(pk.SQLName); fk != nil {
			fks = append(fks, fk)
			continue
		}

		panic(fmt.Errorf(
			"pg: %s has-many %s: %s must have column %s "+
				"(use join_fk:custom_column tag on %s field to specify custom column)",
			t.TypeName, field.GoName, joinTable.TypeName, fkName, field.GoName,
		))
	}

	var typeField *Field

	if polymorphic {
		typeFieldName := fkPrefix + "type"
		typeField = joinTable.getField(typeFieldName)
		if typeField == nil {
			panic(fmt.Errorf(
				"pg: %s has-many %s: %s must have polymorphic column %s",
				t.TypeName, field.GoName, joinTable.TypeName, typeFieldName,
			))
		}
	}

	t.addRelation(&Relation{
		Type:        HasManyRelation,
		Field:       field,
		JoinTable:   joinTable,
		BaseFKs:     t.PKs,
		JoinFKs:     fks,
		Polymorphic: typeField,
	})
	return true
}

func (t *Table) mustM2MRelation(field *Field, pgTag *tagparser.Tag) bool {
	if field.Type.Kind() != reflect.Slice {
		panic(fmt.Errorf(
			"pg: %s.%s many2many relation requires slice, got %q",
			t.TypeName, field.GoName, field.Type.Kind(),
		))
	}
	joinTable := _tables.get(indirectType(field.Type.Elem()), true)

	if err := t.checkPKs(); err != nil {
		panic(err)
	}
	if err := joinTable.checkPKs(); err != nil {
		panic(err)
	}

	m2mTableNameString, ok := pgTag.Options["many2many"]
	if !ok {
		panic(fmt.Errorf("pg: %s must have many2many tag option", field.GoName))
	}
	m2mTableName := quoteTableName(m2mTableNameString)

	m2mTable := _tables.getByName(m2mTableName)
	if m2mTable == nil {
		panic(fmt.Errorf(
			"pg: can't find %s table (use orm.RegisterTable to register the model)",
			m2mTableName,
		))
	}

	var baseFKs []string
	var joinFKs []string

	{
		fkPrefix, ok := pgTag.Options["fk"]
		if !ok {
			fkPrefix = internal.Underscore(t.ModelName) + "_"
		}

		if ok && len(t.PKs) == 1 {
			if m2mTable.getField(fkPrefix) == nil {
				panic(fmt.Errorf(
					"pg: %s many2many %s: %s must have column %s "+
						"(use fk:custom_column tag on %s field to specify custom column)",
					t.TypeName, field.GoName, m2mTable.TypeName, fkPrefix, field.GoName,
				))
			}
			baseFKs = []string{fkPrefix}
		} else {
			for _, pk := range t.PKs {
				fkName := fkPrefix + pk.SQLName
				if m2mTable.getField(fkName) != nil {
					baseFKs = append(baseFKs, fkName)
					continue
				}

				if m2mTable.getField(pk.SQLName) != nil {
					baseFKs = append(baseFKs, pk.SQLName)
					continue
				}

				panic(fmt.Errorf(
					"pg: %s many2many %s: %s must have column %s "+
						"(use fk:custom_column tag on %s field to specify custom column)",
					t.TypeName, field.GoName, m2mTable.TypeName, fkName, field.GoName,
				))
			}
		}
	}

	{
		joinFKPrefix, ok := pgTag.Options["join_fk"]
		if !ok {
			joinFKPrefix = internal.Underscore(joinTable.ModelName) + "_"
		}

		if ok && len(joinTable.PKs) == 1 {
			if m2mTable.getField(joinFKPrefix) == nil {
				panic(fmt.Errorf(
					"pg: %s many2many %s: %s must have column %s "+
						"(use join_fk:custom_column tag on %s field to specify custom column)",
					joinTable.TypeName, field.GoName, m2mTable.TypeName, joinFKPrefix, field.GoName,
				))
			}
			joinFKs = []string{joinFKPrefix}
		} else {
			for _, joinPK := range joinTable.PKs {
				fkName := joinFKPrefix + joinPK.SQLName
				if m2mTable.getField(fkName) != nil {
					joinFKs = append(joinFKs, fkName)
					continue
				}

				if m2mTable.getField(joinPK.SQLName) != nil {
					joinFKs = append(joinFKs, joinPK.SQLName)
					continue
				}

				panic(fmt.Errorf(
					"pg: %s many2many %s: %s must have column %s "+
						"(use join_fk:custom_column tag on %s field to specify custom column)",
					t.TypeName, field.GoName, m2mTable.TypeName, fkName, field.GoName,
				))
			}
		}
	}

	t.addRelation(&Relation{
		Type:          Many2ManyRelation,
		Field:         field,
		JoinTable:     joinTable,
		M2MTableName:  m2mTableName,
		M2MTableAlias: m2mTable.Alias,
		M2MBaseFKs:    baseFKs,
		M2MJoinFKs:    joinFKs,
	})
	return true
}

//nolint
func (t *Table) tryRelationSlice(field *Field, pgTag *tagparser.Tag) bool {
	if t.tryM2MRelation(field, pgTag) {
		internal.Deprecated.Printf(
			`add pg:"rel:many2many" to %s.%s field tag`, t.TypeName, field.GoName)
		return true
	}
	if t.tryHasManyRelation(field, pgTag) {
		internal.Deprecated.Printf(
			`add pg:"rel:has-many" to %s.%s field tag`, t.TypeName, field.GoName)
		return true
	}
	return false
}

func (t *Table) tryM2MRelation(field *Field, pgTag *tagparser.Tag) bool {
	elemType := indirectType(field.Type.Elem())
	if elemType.Kind() != reflect.Struct {
		return false
	}

	joinTable := _tables.get(elemType, true)

	fk, fkOK := pgTag.Options["fk"]
	if fkOK {
		if fk == "-" {
			return false
		}
		fk = tryUnderscorePrefix(fk)
	}

	m2mTableName := pgTag.Options["many2many"]
	if m2mTableName == "" {
		return false
	}

	m2mTable := _tables.getByName(quoteIdent(m2mTableName))

	var m2mTableAlias types.Safe
	if m2mTable != nil {
		m2mTableAlias = m2mTable.Alias
	} else if ind := strings.IndexByte(m2mTableName, '.'); ind >= 0 {
		m2mTableAlias = quoteIdent(m2mTableName[ind+1:])
	} else {
		m2mTableAlias = quoteIdent(m2mTableName)
	}

	var fks []string
	if !fkOK {
		fk = t.ModelName + "_"
	}
	if m2mTable != nil {
		keys := foreignKeys(t, m2mTable, fk, fkOK)
		if len(keys) == 0 {
			return false
		}
		for _, fk := range keys {
			fks = append(fks, fk.SQLName)
		}
	} else {
		if fkOK && len(t.PKs) == 1 {
			fks = append(fks, fk)
		} else {
			for _, pk := range t.PKs {
				fks = append(fks, fk+pk.SQLName)
			}
		}
	}

	joinFK, joinFKOk := pgTag.Options["join_fk"]
	if !joinFKOk {
		joinFK, joinFKOk = pgTag.Options["joinFK"]
		if joinFKOk {
			internal.Deprecated.Printf("joinFK is renamed to join_fk")
		}
	}
	if joinFKOk {
		joinFK = tryUnderscorePrefix(joinFK)
	} else {
		joinFK = joinTable.ModelName + "_"
	}

	var joinFKs []string
	if m2mTable != nil {
		keys := foreignKeys(joinTable, m2mTable, joinFK, joinFKOk)
		if len(keys) == 0 {
			return false
		}
		for _, fk := range keys {
			joinFKs = append(joinFKs, fk.SQLName)
		}
	} else {
		if joinFKOk && len(joinTable.PKs) == 1 {
			joinFKs = append(joinFKs, joinFK)
		} else {
			for _, pk := range joinTable.PKs {
				joinFKs = append(joinFKs, joinFK+pk.SQLName)
			}
		}
	}

	t.addRelation(&Relation{
		Type:          Many2ManyRelation,
		Field:         field,
		JoinTable:     joinTable,
		M2MTableName:  quoteIdent(m2mTableName),
		M2MTableAlias: m2mTableAlias,
		M2MBaseFKs:    fks,
		M2MJoinFKs:    joinFKs,
	})
	return true
}

func (t *Table) tryHasManyRelation(field *Field, pgTag *tagparser.Tag) bool {
	elemType := indirectType(field.Type.Elem())
	if elemType.Kind() != reflect.Struct {
		return false
	}

	joinTable := _tables.get(elemType, true)

	fk, fkOK := pgTag.Options["fk"]
	if fkOK {
		if fk == "-" {
			return false
		}
		fk = tryUnderscorePrefix(fk)
	}

	s, polymorphic := pgTag.Options["polymorphic"]
	var typeField *Field
	if polymorphic {
		fk = tryUnderscorePrefix(s)

		typeField = joinTable.getField(fk + "type")
		if typeField == nil {
			return false
		}
	} else if !fkOK {
		fk = t.ModelName + "_"
	}

	fks := foreignKeys(t, joinTable, fk, fkOK || polymorphic)
	if len(fks) == 0 {
		return false
	}

	var fkValues []*Field
	fkValue, ok := pgTag.Options["fk_value"]
	if ok {
		if len(fks) > 1 {
			panic(fmt.Errorf("got fk_value, but there are %d fks", len(fks)))
		}

		f := t.getField(fkValue)
		if f == nil {
			panic(fmt.Errorf("fk_value=%q not found in %s", fkValue, t))
		}
		fkValues = append(fkValues, f)
	} else {
		fkValues = t.PKs
	}

	if len(fks) != len(fkValues) {
		panic("len(fks) != len(fkValues)")
	}

	if len(fks) > 0 {
		t.addRelation(&Relation{
			Type:        HasManyRelation,
			Field:       field,
			JoinTable:   joinTable,
			BaseFKs:     fkValues,
			JoinFKs:     fks,
			Polymorphic: typeField,
		})
		return true
	}

	return false
}

func (t *Table) tryRelationStruct(field *Field, pgTag *tagparser.Tag) bool {
	joinTable := _tables.get(field.Type, true)

	if len(joinTable.allFields) == 0 {
		return false
	}

	if t.tryHasOne(joinTable, field, pgTag) {
		internal.Deprecated.Printf(
			`add pg:"rel:has-one" to %s.%s field tag`, t.TypeName, field.GoName)
		t.inlineFields(field, nil)
		return true
	}

	if t.tryBelongsToOne(joinTable, field, pgTag) {
		internal.Deprecated.Printf(
			`add pg:"rel:belongs-to" to %s.%s field tag`, t.TypeName, field.GoName)
		t.inlineFields(field, nil)
		return true
	}

	t.inlineFields(field, nil)
	return false
}

func (t *Table) inlineFields(strct *Field, path map[reflect.Type]struct{}) {
	if path == nil {
		path = map[reflect.Type]struct{}{
			t.Type: {},
		}
	}

	if _, ok := path[strct.Type]; ok {
		return
	}
	path[strct.Type] = struct{}{}

	joinTable := _tables.get(strct.Type, true)
	for _, f := range joinTable.allFields {
		f = f.Clone()
		f.GoName = strct.GoName + "_" + f.GoName
		f.SQLName = strct.SQLName + "__" + f.SQLName
		f.Column = quoteIdent(f.SQLName)
		f.Index = appendNew(strct.Index, f.Index...)

		t.fieldsMapMu.Lock()
		if _, ok := t.FieldsMap[f.SQLName]; !ok {
			t.FieldsMap[f.SQLName] = f
		}
		t.fieldsMapMu.Unlock()

		if f.Type.Kind() != reflect.Struct {
			continue
		}

		if _, ok := path[f.Type]; !ok {
			t.inlineFields(f, path)
		}
	}
}

func appendNew(dst []int, src ...int) []int {
	cp := make([]int, len(dst)+len(src))
	copy(cp, dst)
	copy(cp[len(dst):], src)
	return cp
}

func isScanner(typ reflect.Type) bool {
	return typ.Implements(scannerType) || reflect.PtrTo(typ).Implements(scannerType)
}

func fieldSQLType(field *Field, pgTag *tagparser.Tag) string {
	if typ, ok := pgTag.Options["type"]; ok {
		typ, _ = tagparser.Unquote(typ)
		field.UserSQLType = typ
		typ = normalizeSQLType(typ)
		return typ
	}

	if typ, ok := pgTag.Options["composite"]; ok {
		typ, _ = tagparser.Unquote(typ)
		return typ
	}

	if _, ok := pgTag.Options["hstore"]; ok {
		return "hstore"
	} else if _, ok := pgTag.Options["hstore"]; ok {
		return "hstore"
	}

	if field.hasFlag(ArrayFlag) {
		switch field.Type.Kind() {
		case reflect.Slice, reflect.Array:
			sqlType := sqlType(field.Type.Elem())
			return sqlType + "[]"
		}
	}

	sqlType := sqlType(field.Type)
	return sqlType
}

func sqlType(typ reflect.Type) string {
	switch typ {
	case timeType, nullTimeType, sqlNullTimeType:
		return pgTypeTimestampTz
	case ipType:
		return pgTypeInet
	case ipNetType:
		return pgTypeCidr
	case nullBoolType:
		return pgTypeBoolean
	case nullFloatType:
		return pgTypeDoublePrecision
	case nullIntType:
		return pgTypeBigint
	case nullStringType:
		return pgTypeText
	case jsonRawMessageType:
		return pgTypeJSONB
	}

	switch typ.Kind() {
	case reflect.Int8, reflect.Uint8, reflect.Int16:
		return pgTypeSmallint
	case reflect.Uint16, reflect.Int32:
		return pgTypeInteger
	case reflect.Uint32, reflect.Int64, reflect.Int:
		return pgTypeBigint
	case reflect.Uint, reflect.Uint64:
		// Unsigned bigint is not supported - use bigint.
		return pgTypeBigint
	case reflect.Float32:
		return pgTypeReal
	case reflect.Float64:
		return pgTypeDoublePrecision
	case reflect.Bool:
		return pgTypeBoolean
	case reflect.String:
		return pgTypeText
	case reflect.Map, reflect.Struct:
		return pgTypeJSONB
	case reflect.Array, reflect.Slice:
		if typ.Elem().Kind() == reflect.Uint8 {
			return pgTypeBytea
		}
		return pgTypeJSONB
	default:
		return typ.Kind().String()
	}
}

func normalizeSQLType(s string) string {
	switch s {
	case "int2":
		return pgTypeSmallint
	case "int4", "int", "serial":
		return pgTypeInteger
	case "int8", pgTypeBigserial:
		return pgTypeBigint
	case "float4":
		return pgTypeReal
	case "float8":
		return pgTypeDoublePrecision
	}
	return s
}

func sqlTypeEqual(a, b string) bool {
	return a == b
}

func (t *Table) tryHasOne(joinTable *Table, field *Field, pgTag *tagparser.Tag) bool {
	fk, fkOK := pgTag.Options["fk"]
	if fkOK {
		if fk == "-" {
			return false
		}
		fk = tryUnderscorePrefix(fk)
	} else {
		fk = internal.Underscore(field.GoName) + "_"
	}

	fks := foreignKeys(joinTable, t, fk, fkOK)
	if len(fks) > 0 {
		t.addRelation(&Relation{
			Type:      HasOneRelation,
			Field:     field,
			JoinTable: joinTable,
			BaseFKs:   fks,
			JoinFKs:   joinTable.PKs,
		})
		return true
	}
	return false
}

func (t *Table) tryBelongsToOne(joinTable *Table, field *Field, pgTag *tagparser.Tag) bool {
	fk, fkOK := pgTag.Options["fk"]
	if fkOK {
		if fk == "-" {
			return false
		}
		fk = tryUnderscorePrefix(fk)
	} else {
		fk = internal.Underscore(t.TypeName) + "_"
	}

	fks := foreignKeys(t, joinTable, fk, fkOK)
	if len(fks) > 0 {
		t.addRelation(&Relation{
			Type:      BelongsToRelation,
			Field:     field,
			JoinTable: joinTable,
			BaseFKs:   t.PKs,
			JoinFKs:   fks,
		})
		return true
	}
	return false
}

func (t *Table) addRelation(rel *Relation) {
	if t.Relations == nil {
		t.Relations = make(map[string]*Relation)
	}
	_, ok := t.Relations[rel.Field.GoName]
	if ok {
		panic(fmt.Errorf("%s already has %s", t, rel))
	}
	t.Relations[rel.Field.GoName] = rel
}

func foreignKeys(base, join *Table, fk string, tryFK bool) []*Field {
	var fks []*Field

	for _, pk := range base.PKs {
		fkName := fk + pk.SQLName
		f := join.getField(fkName)
		if f != nil && sqlTypeEqual(pk.SQLType, f.SQLType) {
			fks = append(fks, f)
			continue
		}

		if strings.IndexByte(pk.SQLName, '_') == -1 {
			continue
		}

		f = join.getField(pk.SQLName)
		if f != nil && sqlTypeEqual(pk.SQLType, f.SQLType) {
			fks = append(fks, f)
			continue
		}
	}
	if len(fks) > 0 && len(fks) == len(base.PKs) {
		return fks
	}

	fks = nil
	for _, pk := range base.PKs {
		if !strings.HasPrefix(pk.SQLName, "pk_") {
			continue
		}
		fkName := "fk_" + pk.SQLName[3:]
		f := join.getField(fkName)
		if f != nil && sqlTypeEqual(pk.SQLType, f.SQLType) {
			fks = append(fks, f)
		}
	}
	if len(fks) > 0 && len(fks) == len(base.PKs) {
		return fks
	}

	if fk == "" || len(base.PKs) != 1 {
		return nil
	}

	if tryFK {
		f := join.getField(fk)
		if f != nil && sqlTypeEqual(base.PKs[0].SQLType, f.SQLType) {
			return []*Field{f}
		}
	}

	for _, suffix := range []string{"id", "uuid"} {
		f := join.getField(fk + suffix)
		if f != nil && sqlTypeEqual(base.PKs[0].SQLType, f.SQLType) {
			return []*Field{f}
		}
	}

	return nil
}

func scanJSONValue(v reflect.Value, rd types.Reader, n int) error {
	// Zero value so it works with SelectOrInsert.
	// TODO: better handle slices
	v.Set(reflect.New(v.Type()).Elem())

	if n == -1 {
		return nil
	}

	dec := pgjson.NewDecoder(rd)
	dec.UseNumber()
	return dec.Decode(v.Addr().Interface())
}

func appendUintAsInt(b []byte, v reflect.Value, _ int) []byte {
	return strconv.AppendInt(b, int64(v.Uint()), 10)
}

func appendUintPtrAsInt(b []byte, v reflect.Value, _ int) []byte {
	return strconv.AppendInt(b, int64(v.Elem().Uint()), 10)
}

func tryUnderscorePrefix(s string) string {
	if s == "" {
		return s
	}
	if c := s[0]; internal.IsUpper(c) {
		return internal.Underscore(s) + "_"
	}
	return s
}

func quoteTableName(s string) types.Safe {
	// Don't quote if table name contains placeholder (?) or parentheses.
	if strings.IndexByte(s, '?') >= 0 ||
		strings.IndexByte(s, '(') >= 0 && strings.IndexByte(s, ')') >= 0 {
		return types.Safe(s)
	}
	return quoteIdent(s)
}

func quoteIdent(s string) types.Safe {
	return types.Safe(types.AppendIdent(nil, s, 1))
}

func setSoftDeleteFieldFunc(typ reflect.Type) func(fv reflect.Value) error {
	switch typ {
	case timeType:
		return func(fv reflect.Value) error {
			ptr := fv.Addr().Interface().(*time.Time)
			*ptr = time.Now()
			return nil
		}
	case nullTimeType:
		return func(fv reflect.Value) error {
			ptr := fv.Addr().Interface().(*types.NullTime)
			*ptr = types.NullTime{Time: time.Now()}
			return nil
		}
	case nullIntType:
		return func(fv reflect.Value) error {
			ptr := fv.Addr().Interface().(*sql.NullInt64)
			*ptr = sql.NullInt64{Int64: time.Now().UnixNano()}
			return nil
		}
	}

	switch typ.Kind() {
	case reflect.Int64:
		return func(fv reflect.Value) error {
			ptr := fv.Addr().Interface().(*int64)
			*ptr = time.Now().UnixNano()
			return nil
		}
	case reflect.Ptr:
		break
	default:
		return setSoftDeleteFallbackFunc(typ)
	}

	originalType := typ
	typ = typ.Elem()

	switch typ { //nolint:gocritic
	case timeType:
		return func(fv reflect.Value) error {
			now := time.Now()
			fv.Set(reflect.ValueOf(&now))
			return nil
		}
	}

	switch typ.Kind() { //nolint:gocritic
	case reflect.Int64:
		return func(fv reflect.Value) error {
			utime := time.Now().UnixNano()
			fv.Set(reflect.ValueOf(&utime))
			return nil
		}
	}

	return setSoftDeleteFallbackFunc(originalType)
}

func setSoftDeleteFallbackFunc(typ reflect.Type) func(fv reflect.Value) error {
	scanner := types.Scanner(typ)
	if scanner == nil {
		return nil
	}

	return func(fv reflect.Value) error {
		var flags int
		b := types.AppendTime(nil, time.Now(), flags)
		return scanner(fv, pool.NewBytesReader(b), len(b))
	}
}

func isKnownTableOption(name string) bool {
	switch name {
	case "alias",
		"select",
		"tablespace",
		"partition_by",
		"discard_unknown_columns":
		return true
	}
	return false
}

func isKnownFieldOption(name string) bool {
	switch name {
	case "alias",
		"type",
		"array",
		"hstore",
		"composite",
		"json_use_number",
		"msgpack",
		"notnull",
		"use_zero",
		"default",
		"unique",
		"soft_delete",
		"on_delete",
		"on_update",

		"pk",
		"nopk",
		"rel",
		"fk",
		"join_fk",
		"many2many",
		"polymorphic":
		return true
	}
	return false
}
