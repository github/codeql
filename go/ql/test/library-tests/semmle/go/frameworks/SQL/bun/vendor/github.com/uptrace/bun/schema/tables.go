package schema

import (
	"fmt"
	"reflect"
	"sync"
)

type tableInProgress struct {
	table *Table

	init1Once sync.Once
	init2Once sync.Once
}

func newTableInProgress(table *Table) *tableInProgress {
	return &tableInProgress{
		table: table,
	}
}

func (inp *tableInProgress) init1() bool {
	var inited bool
	inp.init1Once.Do(func() {
		inp.table.init1()
		inited = true
	})
	return inited
}

func (inp *tableInProgress) init2() bool {
	var inited bool
	inp.init2Once.Do(func() {
		inp.table.init2()
		inited = true
	})
	return inited
}

type Tables struct {
	dialect Dialect
	tables  sync.Map

	mu         sync.RWMutex
	inProgress map[reflect.Type]*tableInProgress
}

func NewTables(dialect Dialect) *Tables {
	return &Tables{
		dialect:    dialect,
		inProgress: make(map[reflect.Type]*tableInProgress),
	}
}

func (t *Tables) Register(models ...interface{}) {
	for _, model := range models {
		_ = t.Get(reflect.TypeOf(model).Elem())
	}
}

func (t *Tables) Get(typ reflect.Type) *Table {
	return t.table(typ, false)
}

func (t *Tables) Ref(typ reflect.Type) *Table {
	return t.table(typ, true)
}

func (t *Tables) table(typ reflect.Type, allowInProgress bool) *Table {
	typ = indirectType(typ)
	if typ.Kind() != reflect.Struct {
		panic(fmt.Errorf("got %s, wanted %s", typ.Kind(), reflect.Struct))
	}

	if v, ok := t.tables.Load(typ); ok {
		return v.(*Table)
	}

	t.mu.Lock()

	if v, ok := t.tables.Load(typ); ok {
		t.mu.Unlock()
		return v.(*Table)
	}

	var table *Table

	inProgress := t.inProgress[typ]
	if inProgress == nil {
		table = newTable(t.dialect, typ)
		inProgress = newTableInProgress(table)
		t.inProgress[typ] = inProgress
	} else {
		table = inProgress.table
	}

	t.mu.Unlock()

	inProgress.init1()
	if allowInProgress {
		return table
	}

	if !inProgress.init2() {
		return table
	}

	t.mu.Lock()
	delete(t.inProgress, typ)
	t.tables.Store(typ, table)
	t.mu.Unlock()

	t.dialect.OnTable(table)

	for _, field := range table.FieldMap {
		if field.UserSQLType == "" {
			field.UserSQLType = field.DiscoveredSQLType
		}
		if field.CreateTableSQLType == "" {
			field.CreateTableSQLType = field.UserSQLType
		}
	}

	return table
}

func (t *Tables) ByModel(name string) *Table {
	var found *Table
	t.tables.Range(func(key, value interface{}) bool {
		t := value.(*Table)
		if t.TypeName == name {
			found = t
			return false
		}
		return true
	})
	return found
}

func (t *Tables) ByName(name string) *Table {
	var found *Table
	t.tables.Range(func(key, value interface{}) bool {
		t := value.(*Table)
		if t.Name == name {
			found = t
			return false
		}
		return true
	})
	return found
}
