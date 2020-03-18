package pg

import (
	"github.com/go-pg/pg/orm"
	"github.com/go-pg/pg/types"
)

func Q(query string, params ...interface{}) types.ValueAppender {
	return orm.Q(query, params...)
}

type Stmt struct {}

type baseDB struct {}

func (db *baseDB) FormatQuery(dst []byte, query string, params ...interface{}) []byte {
	return nil
}

func (db *baseDB) Prepare(q string) (*Stmt, error) {
	return nil, nil
}

type Conn struct { *baseDB }

type DB struct { *baseDB }

type Tx struct { *baseDB }
