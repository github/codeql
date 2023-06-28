package orm

import (
	"reflect"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/types"
)

type join struct {
	Parent    *join
	BaseModel TableModel
	JoinModel TableModel
	Rel       *Relation

	ApplyQuery func(*Query) (*Query, error)
	Columns    []string
	on         []*condAppender
}

func (j *join) AppendOn(app *condAppender) {
	j.on = append(j.on, app)
}

func (j *join) Select(fmter QueryFormatter, q *Query) error {
	switch j.Rel.Type {
	case HasManyRelation:
		return j.selectMany(fmter, q)
	case Many2ManyRelation:
		return j.selectM2M(fmter, q)
	}
	panic("not reached")
}

func (j *join) selectMany(_ QueryFormatter, q *Query) error {
	q, err := j.manyQuery(q)
	if err != nil {
		return err
	}
	if q == nil {
		return nil
	}
	return q.Select()
}

func (j *join) manyQuery(q *Query) (*Query, error) {
	manyModel := newManyModel(j)
	if manyModel == nil {
		return nil, nil
	}

	q = q.Model(manyModel)
	if j.ApplyQuery != nil {
		var err error
		q, err = j.ApplyQuery(q)
		if err != nil {
			return nil, err
		}
	}

	if len(q.columns) == 0 {
		q.columns = append(q.columns, &hasManyColumnsAppender{j})
	}

	baseTable := j.BaseModel.Table()
	var where []byte
	if len(j.Rel.JoinFKs) > 1 {
		where = append(where, '(')
	}
	where = appendColumns(where, j.JoinModel.Table().Alias, j.Rel.JoinFKs)
	if len(j.Rel.JoinFKs) > 1 {
		where = append(where, ')')
	}
	where = append(where, " IN ("...)
	where = appendChildValues(
		where, j.JoinModel.Root(), j.JoinModel.ParentIndex(), j.Rel.BaseFKs)
	where = append(where, ")"...)
	q = q.Where(internal.BytesToString(where))

	if j.Rel.Polymorphic != nil {
		q = q.Where(`? IN (?, ?)`,
			j.Rel.Polymorphic.Column,
			baseTable.ModelName, baseTable.TypeName)
	}

	return q, nil
}

func (j *join) selectM2M(fmter QueryFormatter, q *Query) error {
	q, err := j.m2mQuery(fmter, q)
	if err != nil {
		return err
	}
	if q == nil {
		return nil
	}
	return q.Select()
}

func (j *join) m2mQuery(fmter QueryFormatter, q *Query) (*Query, error) {
	m2mModel := newM2MModel(j)
	if m2mModel == nil {
		return nil, nil
	}

	q = q.Model(m2mModel)
	if j.ApplyQuery != nil {
		var err error
		q, err = j.ApplyQuery(q)
		if err != nil {
			return nil, err
		}
	}

	if len(q.columns) == 0 {
		q.columns = append(q.columns, &hasManyColumnsAppender{j})
	}

	index := j.JoinModel.ParentIndex()
	baseTable := j.BaseModel.Table()

	//nolint
	var join []byte
	join = append(join, "JOIN "...)
	join = fmter.FormatQuery(join, string(j.Rel.M2MTableName))
	join = append(join, " AS "...)
	join = append(join, j.Rel.M2MTableAlias...)
	join = append(join, " ON ("...)
	for i, col := range j.Rel.M2MBaseFKs {
		if i > 0 {
			join = append(join, ", "...)
		}
		join = append(join, j.Rel.M2MTableAlias...)
		join = append(join, '.')
		join = types.AppendIdent(join, col, 1)
	}
	join = append(join, ") IN ("...)
	join = appendChildValues(join, j.BaseModel.Root(), index, baseTable.PKs)
	join = append(join, ")"...)
	q = q.Join(internal.BytesToString(join))

	joinTable := j.JoinModel.Table()
	for i, col := range j.Rel.M2MJoinFKs {
		pk := joinTable.PKs[i]
		q = q.Where("?.? = ?.?",
			joinTable.Alias, pk.Column,
			j.Rel.M2MTableAlias, types.Ident(col))
	}

	return q, nil
}

func (j *join) hasParent() bool {
	if j.Parent != nil {
		switch j.Parent.Rel.Type {
		case HasOneRelation, BelongsToRelation:
			return true
		}
	}
	return false
}

func (j *join) appendAlias(b []byte) []byte {
	b = append(b, '"')
	b = appendAlias(b, j)
	b = append(b, '"')
	return b
}

func (j *join) appendAliasColumn(b []byte, column string) []byte {
	b = append(b, '"')
	b = appendAlias(b, j)
	b = append(b, "__"...)
	b = append(b, column...)
	b = append(b, '"')
	return b
}

func (j *join) appendBaseAlias(b []byte) []byte {
	if j.hasParent() {
		b = append(b, '"')
		b = appendAlias(b, j.Parent)
		b = append(b, '"')
		return b
	}
	return append(b, j.BaseModel.Table().Alias...)
}

func (j *join) appendSoftDelete(b []byte, flags queryFlag) []byte {
	b = append(b, '.')
	b = append(b, j.JoinModel.Table().SoftDeleteField.Column...)
	if hasFlag(flags, deletedFlag) {
		b = append(b, " IS NOT NULL"...)
	} else {
		b = append(b, " IS NULL"...)
	}
	return b
}

func appendAlias(b []byte, j *join) []byte {
	if j.hasParent() {
		b = appendAlias(b, j.Parent)
		b = append(b, "__"...)
	}
	b = append(b, j.Rel.Field.SQLName...)
	return b
}

func (j *join) appendHasOneColumns(b []byte) []byte {
	if j.Columns == nil {
		for i, f := range j.JoinModel.Table().Fields {
			if i > 0 {
				b = append(b, ", "...)
			}
			b = j.appendAlias(b)
			b = append(b, '.')
			b = append(b, f.Column...)
			b = append(b, " AS "...)
			b = j.appendAliasColumn(b, f.SQLName)
		}
		return b
	}

	for i, column := range j.Columns {
		if i > 0 {
			b = append(b, ", "...)
		}
		b = j.appendAlias(b)
		b = append(b, '.')
		b = types.AppendIdent(b, column, 1)
		b = append(b, " AS "...)
		b = j.appendAliasColumn(b, column)
	}

	return b
}

func (j *join) appendHasOneJoin(fmter QueryFormatter, b []byte, q *Query) (_ []byte, err error) {
	isSoftDelete := j.JoinModel.Table().SoftDeleteField != nil && !q.hasFlag(allWithDeletedFlag)

	b = append(b, "LEFT JOIN "...)
	b = fmter.FormatQuery(b, string(j.JoinModel.Table().SQLNameForSelects))
	b = append(b, " AS "...)
	b = j.appendAlias(b)

	b = append(b, " ON "...)

	if isSoftDelete {
		b = append(b, '(')
	}

	if len(j.Rel.BaseFKs) > 1 {
		b = append(b, '(')
	}
	for i, baseFK := range j.Rel.BaseFKs {
		if i > 0 {
			b = append(b, " AND "...)
		}
		b = j.appendAlias(b)
		b = append(b, '.')
		b = append(b, j.Rel.JoinFKs[i].Column...)
		b = append(b, " = "...)
		b = j.appendBaseAlias(b)
		b = append(b, '.')
		b = append(b, baseFK.Column...)
	}
	if len(j.Rel.BaseFKs) > 1 {
		b = append(b, ')')
	}

	for _, on := range j.on {
		b = on.AppendSep(b)
		b, err = on.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	if isSoftDelete {
		b = append(b, ')')
	}

	if isSoftDelete {
		b = append(b, " AND "...)
		b = j.appendAlias(b)
		b = j.appendSoftDelete(b, q.flags)
	}

	return b, nil
}

type hasManyColumnsAppender struct {
	*join
}

var _ QueryAppender = (*hasManyColumnsAppender)(nil)

func (q *hasManyColumnsAppender) AppendQuery(fmter QueryFormatter, b []byte) ([]byte, error) {
	if q.Rel.M2MTableAlias != "" {
		b = append(b, q.Rel.M2MTableAlias...)
		b = append(b, ".*, "...)
	}

	joinTable := q.JoinModel.Table()

	if q.Columns != nil {
		for i, column := range q.Columns {
			if i > 0 {
				b = append(b, ", "...)
			}
			b = append(b, joinTable.Alias...)
			b = append(b, '.')
			b = types.AppendIdent(b, column, 1)
		}
		return b, nil
	}

	b = appendColumns(b, joinTable.Alias, joinTable.Fields)
	return b, nil
}

func appendChildValues(b []byte, v reflect.Value, index []int, fields []*Field) []byte {
	seen := make(map[string]struct{})
	walk(v, index, func(v reflect.Value) {
		start := len(b)

		if len(fields) > 1 {
			b = append(b, '(')
		}
		for i, f := range fields {
			if i > 0 {
				b = append(b, ", "...)
			}
			b = f.AppendValue(b, v, 1)
		}
		if len(fields) > 1 {
			b = append(b, ')')
		}
		b = append(b, ", "...)

		if _, ok := seen[string(b[start:])]; ok {
			b = b[:start]
		} else {
			seen[string(b[start:])] = struct{}{}
		}
	})
	if len(seen) > 0 {
		b = b[:len(b)-2] // trim ", "
	}
	return b
}
