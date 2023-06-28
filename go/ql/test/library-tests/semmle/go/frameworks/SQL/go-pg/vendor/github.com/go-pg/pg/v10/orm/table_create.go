package orm

import (
	"sort"
	"strconv"

	"github.com/go-pg/pg/v10/types"
)

type CreateTableOptions struct {
	Varchar     int // replaces PostgreSQL data type `text` with `varchar(n)`
	Temp        bool
	IfNotExists bool

	// FKConstraints causes CreateTable to create foreign key constraints
	// for has one relations. ON DELETE hook can be added using tag
	// `pg:"on_delete:RESTRICT"` on foreign key field. ON UPDATE hook can be added using tag
	// `pg:"on_update:CASCADE"`
	FKConstraints bool
}

type CreateTableQuery struct {
	q   *Query
	opt *CreateTableOptions
}

var (
	_ QueryAppender = (*CreateTableQuery)(nil)
	_ QueryCommand  = (*CreateTableQuery)(nil)
)

func NewCreateTableQuery(q *Query, opt *CreateTableOptions) *CreateTableQuery {
	return &CreateTableQuery{
		q:   q,
		opt: opt,
	}
}

func (q *CreateTableQuery) String() string {
	b, err := q.AppendQuery(defaultFmter, nil)
	if err != nil {
		panic(err)
	}
	return string(b)
}

func (q *CreateTableQuery) Operation() QueryOp {
	return CreateTableOp
}

func (q *CreateTableQuery) Clone() QueryCommand {
	return &CreateTableQuery{
		q:   q.q.Clone(),
		opt: q.opt,
	}
}

func (q *CreateTableQuery) Query() *Query {
	return q.q
}

func (q *CreateTableQuery) AppendTemplate(b []byte) ([]byte, error) {
	return q.AppendQuery(dummyFormatter{}, b)
}

func (q *CreateTableQuery) AppendQuery(fmter QueryFormatter, b []byte) (_ []byte, err error) {
	if q.q.stickyErr != nil {
		return nil, q.q.stickyErr
	}
	if q.q.tableModel == nil {
		return nil, errModelNil
	}

	table := q.q.tableModel.Table()

	b = append(b, "CREATE "...)
	if q.opt != nil && q.opt.Temp {
		b = append(b, "TEMP "...)
	}
	b = append(b, "TABLE "...)
	if q.opt != nil && q.opt.IfNotExists {
		b = append(b, "IF NOT EXISTS "...)
	}
	b, err = q.q.appendFirstTable(fmter, b)
	if err != nil {
		return nil, err
	}
	b = append(b, " ("...)

	for i, field := range table.Fields {
		if i > 0 {
			b = append(b, ", "...)
		}

		b = append(b, field.Column...)
		b = append(b, " "...)
		b = q.appendSQLType(b, field)
		if field.hasFlag(NotNullFlag) {
			b = append(b, " NOT NULL"...)
		}
		if field.hasFlag(UniqueFlag) {
			b = append(b, " UNIQUE"...)
		}
		if field.Default != "" {
			b = append(b, " DEFAULT "...)
			b = append(b, field.Default...)
		}
	}

	b = appendPKConstraint(b, table.PKs)
	b = appendUniqueConstraints(b, table)

	if q.opt != nil && q.opt.FKConstraints {
		for _, rel := range table.Relations {
			b = q.appendFKConstraint(fmter, b, rel)
		}
	}

	b = append(b, ")"...)

	if table.PartitionBy != "" {
		b = append(b, " PARTITION BY "...)
		b = append(b, table.PartitionBy...)
	}

	if table.Tablespace != "" {
		b = q.appendTablespace(b, table.Tablespace)
	}

	return b, q.q.stickyErr
}

func (q *CreateTableQuery) appendSQLType(b []byte, field *Field) []byte {
	if field.UserSQLType != "" {
		return append(b, field.UserSQLType...)
	}
	if q.opt != nil && q.opt.Varchar > 0 &&
		field.SQLType == "text" {
		b = append(b, "varchar("...)
		b = strconv.AppendInt(b, int64(q.opt.Varchar), 10)
		b = append(b, ")"...)
		return b
	}
	if field.hasFlag(PrimaryKeyFlag) {
		return append(b, pkSQLType(field.SQLType)...)
	}
	return append(b, field.SQLType...)
}

func pkSQLType(s string) string {
	switch s {
	case pgTypeSmallint:
		return pgTypeSmallserial
	case pgTypeInteger:
		return pgTypeSerial
	case pgTypeBigint:
		return pgTypeBigserial
	}
	return s
}

func appendPKConstraint(b []byte, pks []*Field) []byte {
	if len(pks) == 0 {
		return b
	}

	b = append(b, ", PRIMARY KEY ("...)
	b = appendColumns(b, "", pks)
	b = append(b, ")"...)
	return b
}

func appendUniqueConstraints(b []byte, table *Table) []byte {
	keys := make([]string, 0, len(table.Unique))
	for key := range table.Unique {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	for _, key := range keys {
		b = appendUnique(b, table.Unique[key])
	}

	return b
}

func appendUnique(b []byte, fields []*Field) []byte {
	b = append(b, ", UNIQUE ("...)
	b = appendColumns(b, "", fields)
	b = append(b, ")"...)
	return b
}

func (q *CreateTableQuery) appendFKConstraint(fmter QueryFormatter, b []byte, rel *Relation) []byte {
	if rel.Type != HasOneRelation {
		return b
	}

	b = append(b, ", FOREIGN KEY ("...)
	b = appendColumns(b, "", rel.BaseFKs)
	b = append(b, ")"...)

	b = append(b, " REFERENCES "...)
	b = fmter.FormatQuery(b, string(rel.JoinTable.SQLName))
	b = append(b, " ("...)
	b = appendColumns(b, "", rel.JoinFKs)
	b = append(b, ")"...)

	if s := onDelete(rel.BaseFKs); s != "" {
		b = append(b, " ON DELETE "...)
		b = append(b, s...)
	}

	if s := onUpdate(rel.BaseFKs); s != "" {
		b = append(b, " ON UPDATE "...)
		b = append(b, s...)
	}

	return b
}

func (q *CreateTableQuery) appendTablespace(b []byte, tableSpace types.Safe) []byte {
	b = append(b, " TABLESPACE "...)
	b = append(b, tableSpace...)
	return b
}

func onDelete(fks []*Field) string {
	var onDelete string
	for _, f := range fks {
		if f.OnDelete != "" {
			onDelete = f.OnDelete
			break
		}
	}
	return onDelete
}

func onUpdate(fks []*Field) string {
	var onUpdate string
	for _, f := range fks {
		if f.OnUpdate != "" {
			onUpdate = f.OnUpdate
			break
		}
	}
	return onUpdate
}
