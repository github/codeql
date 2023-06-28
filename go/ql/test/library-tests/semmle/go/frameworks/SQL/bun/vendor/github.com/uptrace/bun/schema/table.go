package schema

import (
	"database/sql"
	"fmt"
	"reflect"
	"strings"
	"sync"
	"time"

	"github.com/jinzhu/inflection"

	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/internal/tagparser"
)

const (
	beforeAppendModelHookFlag internal.Flag = 1 << iota
	beforeScanHookFlag
	afterScanHookFlag
	beforeScanRowHookFlag
	afterScanRowHookFlag
)

var (
	baseModelType      = reflect.TypeOf((*BaseModel)(nil)).Elem()
	tableNameInflector = inflection.Plural
)

type BaseModel struct{}

// SetTableNameInflector overrides the default func that pluralizes
// model name to get table name, e.g. my_article becomes my_articles.
func SetTableNameInflector(fn func(string) string) {
	tableNameInflector = fn
}

// Table represents a SQL table created from Go struct.
type Table struct {
	dialect Dialect

	Type      reflect.Type
	ZeroValue reflect.Value // reflect.Struct
	ZeroIface interface{}   // struct pointer

	TypeName  string
	ModelName string

	Name              string
	SQLName           Safe
	SQLNameForSelects Safe
	Alias             string
	SQLAlias          Safe

	Fields     []*Field // PKs + DataFields
	PKs        []*Field
	DataFields []*Field

	fieldsMapMu sync.RWMutex
	FieldMap    map[string]*Field

	Relations map[string]*Relation
	Unique    map[string][]*Field

	SoftDeleteField       *Field
	UpdateSoftDeleteField func(fv reflect.Value, tm time.Time) error

	allFields []*Field // read only

	flags internal.Flag
}

func newTable(dialect Dialect, typ reflect.Type) *Table {
	t := new(Table)
	t.dialect = dialect
	t.Type = typ
	t.ZeroValue = reflect.New(t.Type).Elem()
	t.ZeroIface = reflect.New(t.Type).Interface()
	t.TypeName = internal.ToExported(t.Type.Name())
	t.ModelName = internal.Underscore(t.Type.Name())
	tableName := tableNameInflector(t.ModelName)
	t.setName(tableName)
	t.Alias = t.ModelName
	t.SQLAlias = t.quoteIdent(t.ModelName)

	hooks := []struct {
		typ  reflect.Type
		flag internal.Flag
	}{
		{beforeAppendModelHookType, beforeAppendModelHookFlag},

		{beforeScanHookType, beforeScanHookFlag},
		{afterScanHookType, afterScanHookFlag},

		{beforeScanRowHookType, beforeScanRowHookFlag},
		{afterScanRowHookType, afterScanRowHookFlag},
	}

	typ = reflect.PtrTo(t.Type)
	for _, hook := range hooks {
		if typ.Implements(hook.typ) {
			t.flags = t.flags.Set(hook.flag)
		}
	}

	// Deprecated.
	deprecatedHooks := []struct {
		typ  reflect.Type
		flag internal.Flag
		msg  string
	}{
		{beforeScanHookType, beforeScanHookFlag, "rename BeforeScan hook to BeforeScanRow"},
		{afterScanHookType, afterScanHookFlag, "rename AfterScan hook to AfterScanRow"},
	}
	for _, hook := range deprecatedHooks {
		if typ.Implements(hook.typ) {
			internal.Deprecated.Printf("%s: %s", t.TypeName, hook.msg)
			t.flags = t.flags.Set(hook.flag)
		}
	}

	return t
}

func (t *Table) init1() {
	t.initFields()
}

func (t *Table) init2() {
	t.initRelations()
}

func (t *Table) setName(name string) {
	t.Name = name
	t.SQLName = t.quoteIdent(name)
	t.SQLNameForSelects = t.quoteIdent(name)
	if t.SQLAlias == "" {
		t.Alias = name
		t.SQLAlias = t.quoteIdent(name)
	}
}

func (t *Table) String() string {
	return "model=" + t.TypeName
}

func (t *Table) CheckPKs() error {
	if len(t.PKs) == 0 {
		return fmt.Errorf("bun: %s does not have primary keys", t)
	}
	return nil
}

func (t *Table) addField(field *Field) {
	t.Fields = append(t.Fields, field)
	if field.IsPK {
		t.PKs = append(t.PKs, field)
	} else {
		t.DataFields = append(t.DataFields, field)
	}
	t.FieldMap[field.Name] = field
}

func (t *Table) removeField(field *Field) {
	t.Fields = removeField(t.Fields, field)
	if field.IsPK {
		t.PKs = removeField(t.PKs, field)
	} else {
		t.DataFields = removeField(t.DataFields, field)
	}
	delete(t.FieldMap, field.Name)
}

func (t *Table) fieldWithLock(name string) *Field {
	t.fieldsMapMu.RLock()
	field := t.FieldMap[name]
	t.fieldsMapMu.RUnlock()
	return field
}

func (t *Table) HasField(name string) bool {
	_, ok := t.FieldMap[name]
	return ok
}

func (t *Table) Field(name string) (*Field, error) {
	field, ok := t.FieldMap[name]
	if !ok {
		return nil, fmt.Errorf("bun: %s does not have column=%s", t, name)
	}
	return field, nil
}

func (t *Table) fieldByGoName(name string) *Field {
	for _, f := range t.allFields {
		if f.GoName == name {
			return f
		}
	}
	return nil
}

func (t *Table) initFields() {
	t.Fields = make([]*Field, 0, t.Type.NumField())
	t.FieldMap = make(map[string]*Field, t.Type.NumField())
	t.addFields(t.Type, "", nil)
}

func (t *Table) addFields(typ reflect.Type, prefix string, index []int) {
	for i := 0; i < typ.NumField(); i++ {
		f := typ.Field(i)
		unexported := f.PkgPath != ""

		if unexported && !f.Anonymous { // unexported
			continue
		}
		if f.Tag.Get("bun") == "-" {
			continue
		}

		if f.Anonymous {
			if f.Name == "BaseModel" && f.Type == baseModelType {
				if len(index) == 0 {
					t.processBaseModelField(f)
				}
				continue
			}

			// If field is an embedded struct, add each field of the embedded struct.
			fieldType := indirectType(f.Type)
			if fieldType.Kind() == reflect.Struct {
				t.addFields(fieldType, "", withIndex(index, f.Index))

				tag := tagparser.Parse(f.Tag.Get("bun"))
				if tag.HasOption("inherit") || tag.HasOption("extend") {
					embeddedTable := t.dialect.Tables().Ref(fieldType)
					t.TypeName = embeddedTable.TypeName
					t.SQLName = embeddedTable.SQLName
					t.SQLNameForSelects = embeddedTable.SQLNameForSelects
					t.Alias = embeddedTable.Alias
					t.SQLAlias = embeddedTable.SQLAlias
					t.ModelName = embeddedTable.ModelName
				}
				continue
			}
		}

		// If field is not a struct, add it.
		// This will also add any embedded non-struct type as a field.
		if field := t.newField(f, prefix, index); field != nil {
			t.addField(field)
		}
	}
}

func (t *Table) processBaseModelField(f reflect.StructField) {
	tag := tagparser.Parse(f.Tag.Get("bun"))

	if isKnownTableOption(tag.Name) {
		internal.Warn.Printf(
			"%s.%s tag name %q is also an option name, is it a mistake? Try table:%s.",
			t.TypeName, f.Name, tag.Name, tag.Name,
		)
	}

	for name := range tag.Options {
		if !isKnownTableOption(name) {
			internal.Warn.Printf("%s.%s has unknown tag option: %q", t.TypeName, f.Name, name)
		}
	}

	if tag.Name != "" {
		t.setName(tag.Name)
	}

	if s, ok := tag.Option("table"); ok {
		t.setName(s)
	}

	if s, ok := tag.Option("select"); ok {
		t.SQLNameForSelects = t.quoteTableName(s)
	}

	if s, ok := tag.Option("alias"); ok {
		t.Alias = s
		t.SQLAlias = t.quoteIdent(s)
	}
}

// nolint
func (t *Table) newField(f reflect.StructField, prefix string, index []int) *Field {
	tag := tagparser.Parse(f.Tag.Get("bun"))

	if nextPrefix, ok := tag.Option("embed"); ok {
		fieldType := indirectType(f.Type)
		if fieldType.Kind() != reflect.Struct {
			panic(fmt.Errorf("bun: embed %s.%s: got %s, wanted reflect.Struct",
				t.TypeName, f.Name, fieldType.Kind()))
		}
		t.addFields(fieldType, prefix+nextPrefix, withIndex(index, f.Index))
		return nil
	}

	sqlName := internal.Underscore(f.Name)
	if tag.Name != "" && tag.Name != sqlName {
		if isKnownFieldOption(tag.Name) {
			internal.Warn.Printf(
				"%s.%s tag name %q is also an option name, is it a mistake? Try column:%s.",
				t.TypeName, f.Name, tag.Name, tag.Name,
			)
		}
		sqlName = tag.Name
	}
	if s, ok := tag.Option("column"); ok {
		sqlName = s
	}
	sqlName = prefix + sqlName

	for name := range tag.Options {
		if !isKnownFieldOption(name) {
			internal.Warn.Printf("%s.%s has unknown tag option: %q", t.TypeName, f.Name, name)
		}
	}

	index = withIndex(index, f.Index)
	if field := t.fieldWithLock(sqlName); field != nil {
		if indexEqual(field.Index, index) {
			return field
		}
		t.removeField(field)
	}

	field := &Field{
		StructField: f,
		IsPtr:       f.Type.Kind() == reflect.Ptr,

		Tag:          tag,
		IndirectType: indirectType(f.Type),
		Index:        index,

		Name:    sqlName,
		GoName:  f.Name,
		SQLName: t.quoteIdent(sqlName),
	}

	field.NotNull = tag.HasOption("notnull")
	field.NullZero = tag.HasOption("nullzero")
	if tag.HasOption("pk") {
		field.IsPK = true
		field.NotNull = true
	}
	if tag.HasOption("autoincrement") {
		field.AutoIncrement = true
		field.NullZero = true
	}
	if tag.HasOption("identity") {
		field.Identity = true
	}

	if v, ok := tag.Options["unique"]; ok {
		var names []string
		if len(v) == 1 {
			// Split the value by comma, this will allow multiple names to be specified.
			// We can use this to create multiple named unique constraints where a single column
			// might be included in multiple constraints.
			names = strings.Split(v[0], ",")
		} else {
			names = v
		}

		for _, uniqueName := range names {
			if t.Unique == nil {
				t.Unique = make(map[string][]*Field)
			}
			t.Unique[uniqueName] = append(t.Unique[uniqueName], field)
		}
	}
	if s, ok := tag.Option("default"); ok {
		field.SQLDefault = s
		field.NullZero = true
	}
	if s, ok := field.Tag.Option("type"); ok {
		field.UserSQLType = s
	}
	field.DiscoveredSQLType = DiscoverSQLType(field.IndirectType)
	field.Append = FieldAppender(t.dialect, field)
	field.Scan = FieldScanner(t.dialect, field)
	field.IsZero = zeroChecker(field.StructField.Type)

	if v, ok := tag.Option("alt"); ok {
		t.FieldMap[v] = field
	}

	t.allFields = append(t.allFields, field)
	if tag.HasOption("scanonly") {
		t.FieldMap[field.Name] = field
		if field.IndirectType.Kind() == reflect.Struct {
			t.inlineFields(field, nil)
		}
		return nil
	}

	if _, ok := tag.Options["soft_delete"]; ok {
		t.SoftDeleteField = field
		t.UpdateSoftDeleteField = softDeleteFieldUpdater(field)
	}

	return field
}

//---------------------------------------------------------------------------------------

func (t *Table) initRelations() {
	for i := 0; i < len(t.Fields); {
		f := t.Fields[i]
		if t.tryRelation(f) {
			t.Fields = removeField(t.Fields, f)
			t.DataFields = removeField(t.DataFields, f)
		} else {
			i++
		}

		if f.IndirectType.Kind() == reflect.Struct {
			t.inlineFields(f, nil)
		}
	}
}

func (t *Table) tryRelation(field *Field) bool {
	if rel, ok := field.Tag.Option("rel"); ok {
		t.initRelation(field, rel)
		return true
	}
	if field.Tag.HasOption("m2m") {
		t.addRelation(t.m2mRelation(field))
		return true
	}

	if field.Tag.HasOption("join") {
		internal.Warn.Printf(
			`%s.%s "join" option must come together with "rel" option`,
			t.TypeName, field.GoName,
		)
	}

	return false
}

func (t *Table) initRelation(field *Field, rel string) {
	switch rel {
	case "belongs-to":
		t.addRelation(t.belongsToRelation(field))
	case "has-one":
		t.addRelation(t.hasOneRelation(field))
	case "has-many":
		t.addRelation(t.hasManyRelation(field))
	default:
		panic(fmt.Errorf("bun: unknown relation=%s on field=%s", rel, field.GoName))
	}
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

func (t *Table) belongsToRelation(field *Field) *Relation {
	joinTable := t.dialect.Tables().Ref(field.IndirectType)
	if err := joinTable.CheckPKs(); err != nil {
		panic(err)
	}

	rel := &Relation{
		Type:      HasOneRelation,
		Field:     field,
		JoinTable: joinTable,
	}

	if field.Tag.HasOption("join_on") {
		rel.Condition = field.Tag.Options["join_on"]
	}

	rel.OnUpdate = "ON UPDATE NO ACTION"
	if onUpdate, ok := field.Tag.Options["on_update"]; ok {
		if len(onUpdate) > 1 {
			panic(fmt.Errorf("bun: %s belongs-to %s: on_update option must be a single field", t.TypeName, field.GoName))
		}

		rule := strings.ToUpper(onUpdate[0])
		if !isKnownFKRule(rule) {
			internal.Warn.Printf("bun: %s belongs-to %s: unknown on_update rule %s", t.TypeName, field.GoName, rule)
		}

		s := fmt.Sprintf("ON UPDATE %s", rule)
		rel.OnUpdate = s
	}

	rel.OnDelete = "ON DELETE NO ACTION"
	if onDelete, ok := field.Tag.Options["on_delete"]; ok {
		if len(onDelete) > 1 {
			panic(fmt.Errorf("bun: %s belongs-to %s: on_delete option must be a single field", t.TypeName, field.GoName))
		}

		rule := strings.ToUpper(onDelete[0])
		if !isKnownFKRule(rule) {
			internal.Warn.Printf("bun: %s belongs-to %s: unknown on_delete rule %s", t.TypeName, field.GoName, rule)
		}
		s := fmt.Sprintf("ON DELETE %s", rule)
		rel.OnDelete = s
	}

	if join, ok := field.Tag.Options["join"]; ok {
		baseColumns, joinColumns := parseRelationJoin(join)
		for i, baseColumn := range baseColumns {
			joinColumn := joinColumns[i]

			if f := t.fieldWithLock(baseColumn); f != nil {
				rel.BaseFields = append(rel.BaseFields, f)
			} else {
				panic(fmt.Errorf(
					"bun: %s belongs-to %s: %s must have column %s",
					t.TypeName, field.GoName, t.TypeName, baseColumn,
				))
			}

			if f := joinTable.fieldWithLock(joinColumn); f != nil {
				rel.JoinFields = append(rel.JoinFields, f)
			} else {
				panic(fmt.Errorf(
					"bun: %s belongs-to %s: %s must have column %s",
					t.TypeName, field.GoName, joinTable.TypeName, joinColumn,
				))
			}
		}
		return rel
	}

	rel.JoinFields = joinTable.PKs
	fkPrefix := internal.Underscore(field.GoName) + "_"
	for _, joinPK := range joinTable.PKs {
		fkName := fkPrefix + joinPK.Name
		if fk := t.fieldWithLock(fkName); fk != nil {
			rel.BaseFields = append(rel.BaseFields, fk)
			continue
		}

		if fk := t.fieldWithLock(joinPK.Name); fk != nil {
			rel.BaseFields = append(rel.BaseFields, fk)
			continue
		}

		panic(fmt.Errorf(
			"bun: %s belongs-to %s: %s must have column %s "+
				"(to override, use join:base_column=join_column tag on %s field)",
			t.TypeName, field.GoName, t.TypeName, fkName, field.GoName,
		))
	}
	return rel
}

func (t *Table) hasOneRelation(field *Field) *Relation {
	if err := t.CheckPKs(); err != nil {
		panic(err)
	}

	joinTable := t.dialect.Tables().Ref(field.IndirectType)
	rel := &Relation{
		Type:      BelongsToRelation,
		Field:     field,
		JoinTable: joinTable,
	}

	if field.Tag.HasOption("join_on") {
		rel.Condition = field.Tag.Options["join_on"]
	}

	if join, ok := field.Tag.Options["join"]; ok {
		baseColumns, joinColumns := parseRelationJoin(join)
		for i, baseColumn := range baseColumns {
			if f := t.fieldWithLock(baseColumn); f != nil {
				rel.BaseFields = append(rel.BaseFields, f)
			} else {
				panic(fmt.Errorf(
					"bun: %s has-one %s: %s must have column %s",
					field.GoName, t.TypeName, t.TypeName, baseColumn,
				))
			}

			joinColumn := joinColumns[i]
			if f := joinTable.fieldWithLock(joinColumn); f != nil {
				rel.JoinFields = append(rel.JoinFields, f)
			} else {
				panic(fmt.Errorf(
					"bun: %s has-one %s: %s must have column %s",
					field.GoName, t.TypeName, joinTable.TypeName, joinColumn,
				))
			}
		}
		return rel
	}

	rel.BaseFields = t.PKs
	fkPrefix := internal.Underscore(t.ModelName) + "_"
	for _, pk := range t.PKs {
		fkName := fkPrefix + pk.Name
		if f := joinTable.fieldWithLock(fkName); f != nil {
			rel.JoinFields = append(rel.JoinFields, f)
			continue
		}

		if f := joinTable.fieldWithLock(pk.Name); f != nil {
			rel.JoinFields = append(rel.JoinFields, f)
			continue
		}

		panic(fmt.Errorf(
			"bun: %s has-one %s: %s must have column %s "+
				"(to override, use join:base_column=join_column tag on %s field)",
			field.GoName, t.TypeName, joinTable.TypeName, fkName, field.GoName,
		))
	}
	return rel
}

func (t *Table) hasManyRelation(field *Field) *Relation {
	if err := t.CheckPKs(); err != nil {
		panic(err)
	}
	if field.IndirectType.Kind() != reflect.Slice {
		panic(fmt.Errorf(
			"bun: %s.%s has-many relation requires slice, got %q",
			t.TypeName, field.GoName, field.IndirectType.Kind(),
		))
	}

	joinTable := t.dialect.Tables().Ref(indirectType(field.IndirectType.Elem()))
	polymorphicValue, isPolymorphic := field.Tag.Option("polymorphic")
	rel := &Relation{
		Type:      HasManyRelation,
		Field:     field,
		JoinTable: joinTable,
	}

	if field.Tag.HasOption("join_on") {
		rel.Condition = field.Tag.Options["join_on"]
	}

	var polymorphicColumn string

	if join, ok := field.Tag.Options["join"]; ok {
		baseColumns, joinColumns := parseRelationJoin(join)
		for i, baseColumn := range baseColumns {
			joinColumn := joinColumns[i]

			if isPolymorphic && baseColumn == "type" {
				polymorphicColumn = joinColumn
				continue
			}

			if f := t.fieldWithLock(baseColumn); f != nil {
				rel.BaseFields = append(rel.BaseFields, f)
			} else {
				panic(fmt.Errorf(
					"bun: %s has-many %s: %s must have column %s",
					t.TypeName, field.GoName, t.TypeName, baseColumn,
				))
			}

			if f := joinTable.fieldWithLock(joinColumn); f != nil {
				rel.JoinFields = append(rel.JoinFields, f)
			} else {
				panic(fmt.Errorf(
					"bun: %s has-many %s: %s must have column %s",
					t.TypeName, field.GoName, joinTable.TypeName, joinColumn,
				))
			}
		}
	} else {
		rel.BaseFields = t.PKs
		fkPrefix := internal.Underscore(t.ModelName) + "_"
		if isPolymorphic {
			polymorphicColumn = fkPrefix + "type"
		}

		for _, pk := range t.PKs {
			joinColumn := fkPrefix + pk.Name
			if fk := joinTable.fieldWithLock(joinColumn); fk != nil {
				rel.JoinFields = append(rel.JoinFields, fk)
				continue
			}

			if fk := joinTable.fieldWithLock(pk.Name); fk != nil {
				rel.JoinFields = append(rel.JoinFields, fk)
				continue
			}

			panic(fmt.Errorf(
				"bun: %s has-many %s: %s must have column %s "+
					"(to override, use join:base_column=join_column tag on the field %s)",
				t.TypeName, field.GoName, joinTable.TypeName, joinColumn, field.GoName,
			))
		}
	}

	if isPolymorphic {
		rel.PolymorphicField = joinTable.fieldWithLock(polymorphicColumn)
		if rel.PolymorphicField == nil {
			panic(fmt.Errorf(
				"bun: %s has-many %s: %s must have polymorphic column %s",
				t.TypeName, field.GoName, joinTable.TypeName, polymorphicColumn,
			))
		}

		if polymorphicValue == "" {
			polymorphicValue = t.ModelName
		}
		rel.PolymorphicValue = polymorphicValue
	}

	return rel
}

func (t *Table) m2mRelation(field *Field) *Relation {
	if field.IndirectType.Kind() != reflect.Slice {
		panic(fmt.Errorf(
			"bun: %s.%s m2m relation requires slice, got %q",
			t.TypeName, field.GoName, field.IndirectType.Kind(),
		))
	}
	joinTable := t.dialect.Tables().Ref(indirectType(field.IndirectType.Elem()))

	if err := t.CheckPKs(); err != nil {
		panic(err)
	}
	if err := joinTable.CheckPKs(); err != nil {
		panic(err)
	}

	m2mTableName, ok := field.Tag.Option("m2m")
	if !ok {
		panic(fmt.Errorf("bun: %s must have m2m tag option", field.GoName))
	}

	m2mTable := t.dialect.Tables().ByName(m2mTableName)
	if m2mTable == nil {
		panic(fmt.Errorf(
			"bun: can't find m2m %s table (use db.RegisterModel)",
			m2mTableName,
		))
	}

	rel := &Relation{
		Type:      ManyToManyRelation,
		Field:     field,
		JoinTable: joinTable,
		M2MTable:  m2mTable,
	}

	if field.Tag.HasOption("join_on") {
		rel.Condition = field.Tag.Options["join_on"]
	}

	var leftColumn, rightColumn string

	if join, ok := field.Tag.Options["join"]; ok {
		left, right := parseRelationJoin(join)
		leftColumn = left[0]
		rightColumn = right[0]
	} else {
		leftColumn = t.TypeName
		rightColumn = joinTable.TypeName
	}

	leftField := m2mTable.fieldByGoName(leftColumn)
	if leftField == nil {
		panic(fmt.Errorf(
			"bun: %s many-to-many %s: %s must have field %s "+
				"(to override, use tag join:LeftField=RightField on field %s.%s",
			t.TypeName, field.GoName, m2mTable.TypeName, leftColumn, t.TypeName, field.GoName,
		))
	}

	rightField := m2mTable.fieldByGoName(rightColumn)
	if rightField == nil {
		panic(fmt.Errorf(
			"bun: %s many-to-many %s: %s must have field %s "+
				"(to override, use tag join:LeftField=RightField on field %s.%s",
			t.TypeName, field.GoName, m2mTable.TypeName, rightColumn, t.TypeName, field.GoName,
		))
	}

	leftRel := m2mTable.belongsToRelation(leftField)
	rel.BaseFields = leftRel.JoinFields
	rel.M2MBaseFields = leftRel.BaseFields

	rightRel := m2mTable.belongsToRelation(rightField)
	rel.JoinFields = rightRel.JoinFields
	rel.M2MJoinFields = rightRel.BaseFields

	return rel
}

func (t *Table) inlineFields(field *Field, seen map[reflect.Type]struct{}) {
	if seen == nil {
		seen = map[reflect.Type]struct{}{t.Type: {}}
	}

	if _, ok := seen[field.IndirectType]; ok {
		return
	}
	seen[field.IndirectType] = struct{}{}

	joinTable := t.dialect.Tables().Ref(field.IndirectType)
	for _, f := range joinTable.allFields {
		f = f.Clone()
		f.GoName = field.GoName + "_" + f.GoName
		f.Name = field.Name + "__" + f.Name
		f.SQLName = t.quoteIdent(f.Name)
		f.Index = withIndex(field.Index, f.Index)

		t.fieldsMapMu.Lock()
		if _, ok := t.FieldMap[f.Name]; !ok {
			t.FieldMap[f.Name] = f
		}
		t.fieldsMapMu.Unlock()

		if f.IndirectType.Kind() != reflect.Struct {
			continue
		}

		if _, ok := seen[f.IndirectType]; !ok {
			t.inlineFields(f, seen)
		}
	}
}

//------------------------------------------------------------------------------

func (t *Table) Dialect() Dialect { return t.dialect }

func (t *Table) HasBeforeAppendModelHook() bool { return t.flags.Has(beforeAppendModelHookFlag) }

// DEPRECATED. Use HasBeforeScanRowHook.
func (t *Table) HasBeforeScanHook() bool { return t.flags.Has(beforeScanHookFlag) }

// DEPRECATED. Use HasAfterScanRowHook.
func (t *Table) HasAfterScanHook() bool { return t.flags.Has(afterScanHookFlag) }

func (t *Table) HasBeforeScanRowHook() bool { return t.flags.Has(beforeScanRowHookFlag) }
func (t *Table) HasAfterScanRowHook() bool  { return t.flags.Has(afterScanRowHookFlag) }

//------------------------------------------------------------------------------

func (t *Table) AppendNamedArg(
	fmter Formatter, b []byte, name string, strct reflect.Value,
) ([]byte, bool) {
	if field, ok := t.FieldMap[name]; ok {
		return field.AppendValue(fmter, b, strct), true
	}
	return b, false
}

func (t *Table) quoteTableName(s string) Safe {
	// Don't quote if table name contains placeholder (?) or parentheses.
	if strings.IndexByte(s, '?') >= 0 ||
		strings.IndexByte(s, '(') >= 0 ||
		strings.IndexByte(s, ')') >= 0 {
		return Safe(s)
	}
	return t.quoteIdent(s)
}

func (t *Table) quoteIdent(s string) Safe {
	return Safe(NewFormatter(t.dialect).AppendIdent(nil, s))
}

func isKnownTableOption(name string) bool {
	switch name {
	case "table", "alias", "select":
		return true
	}
	return false
}

func isKnownFieldOption(name string) bool {
	switch name {
	case "column",
		"alias",
		"type",
		"array",
		"hstore",
		"composite",
		"json_use_number",
		"msgpack",
		"notnull",
		"nullzero",
		"default",
		"unique",
		"soft_delete",
		"scanonly",
		"skipupdate",

		"pk",
		"autoincrement",
		"rel",
		"join",
		"join_on",
		"on_update",
		"on_delete",
		"m2m",
		"polymorphic",
		"identity":
		return true
	}
	return false
}

func isKnownFKRule(name string) bool {
	switch name {
	case "CASCADE",
		"RESTRICT",
		"SET NULL",
		"SET DEFAULT":
		return true
	}
	return false
}

func removeField(fields []*Field, field *Field) []*Field {
	for i, f := range fields {
		if f == field {
			return append(fields[:i], fields[i+1:]...)
		}
	}
	return fields
}

func parseRelationJoin(join []string) ([]string, []string) {
	var ss []string
	if len(join) == 1 {
		ss = strings.Split(join[0], ",")
	} else {
		ss = join
	}

	baseColumns := make([]string, len(ss))
	joinColumns := make([]string, len(ss))
	for i, s := range ss {
		ss := strings.Split(strings.TrimSpace(s), "=")
		if len(ss) != 2 {
			panic(fmt.Errorf("can't parse relation join: %q", join))
		}
		baseColumns[i] = ss[0]
		joinColumns[i] = ss[1]
	}
	return baseColumns, joinColumns
}

//------------------------------------------------------------------------------

func softDeleteFieldUpdater(field *Field) func(fv reflect.Value, tm time.Time) error {
	typ := field.StructField.Type

	switch typ {
	case timeType:
		return func(fv reflect.Value, tm time.Time) error {
			ptr := fv.Addr().Interface().(*time.Time)
			*ptr = tm
			return nil
		}
	case nullTimeType:
		return func(fv reflect.Value, tm time.Time) error {
			ptr := fv.Addr().Interface().(*sql.NullTime)
			*ptr = sql.NullTime{Time: tm}
			return nil
		}
	case nullIntType:
		return func(fv reflect.Value, tm time.Time) error {
			ptr := fv.Addr().Interface().(*sql.NullInt64)
			*ptr = sql.NullInt64{Int64: tm.UnixNano()}
			return nil
		}
	}

	switch field.IndirectType.Kind() {
	case reflect.Int64:
		return func(fv reflect.Value, tm time.Time) error {
			ptr := fv.Addr().Interface().(*int64)
			*ptr = tm.UnixNano()
			return nil
		}
	case reflect.Ptr:
		typ = typ.Elem()
	default:
		return softDeleteFieldUpdaterFallback(field)
	}

	switch typ { //nolint:gocritic
	case timeType:
		return func(fv reflect.Value, tm time.Time) error {
			fv.Set(reflect.ValueOf(&tm))
			return nil
		}
	}

	switch typ.Kind() { //nolint:gocritic
	case reflect.Int64:
		return func(fv reflect.Value, tm time.Time) error {
			utime := tm.UnixNano()
			fv.Set(reflect.ValueOf(&utime))
			return nil
		}
	}

	return softDeleteFieldUpdaterFallback(field)
}

func softDeleteFieldUpdaterFallback(field *Field) func(fv reflect.Value, tm time.Time) error {
	return func(fv reflect.Value, tm time.Time) error {
		return field.ScanWithCheck(fv, tm)
	}
}

func withIndex(a, b []int) []int {
	dest := make([]int, 0, len(a)+len(b))
	dest = append(dest, a...)
	dest = append(dest, b...)
	return dest
}
