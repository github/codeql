package orm

import (
	"fmt"
	"reflect"
	"sync"

	"github.com/go-pg/pg/v10/types"
)

var _tables = newTables()

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

// GetTable returns a Table for a struct type.
func GetTable(typ reflect.Type) *Table {
	return _tables.Get(typ)
}

// RegisterTable registers a struct as SQL table.
// It is usually used to register intermediate table
// in many to many relationship.
func RegisterTable(strct interface{}) {
	_tables.Register(strct)
}

type tables struct {
	tables sync.Map

	mu         sync.RWMutex
	inProgress map[reflect.Type]*tableInProgress
}

func newTables() *tables {
	return &tables{
		inProgress: make(map[reflect.Type]*tableInProgress),
	}
}

func (t *tables) Register(strct interface{}) {
	typ := reflect.TypeOf(strct)
	if typ.Kind() == reflect.Ptr {
		typ = typ.Elem()
	}
	_ = t.Get(typ)
}

func (t *tables) get(typ reflect.Type, allowInProgress bool) *Table {
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
		table = newTable(typ)
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

	if inProgress.init2() {
		t.mu.Lock()
		delete(t.inProgress, typ)
		t.tables.Store(typ, table)
		t.mu.Unlock()
	}

	return table
}

func (t *tables) Get(typ reflect.Type) *Table {
	return t.get(typ, false)
}

func (t *tables) getByName(name types.Safe) *Table {
	var found *Table
	t.tables.Range(func(key, value interface{}) bool {
		t := value.(*Table)
		if t.SQLName == name {
			found = t
			return false
		}
		return true
	})
	return found
}
