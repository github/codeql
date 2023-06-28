package orm

type DropTableOptions struct {
	IfExists bool
	Cascade  bool
}

type DropTableQuery struct {
	q   *Query
	opt *DropTableOptions
}

var (
	_ QueryAppender = (*DropTableQuery)(nil)
	_ QueryCommand  = (*DropTableQuery)(nil)
)

func NewDropTableQuery(q *Query, opt *DropTableOptions) *DropTableQuery {
	return &DropTableQuery{
		q:   q,
		opt: opt,
	}
}

func (q *DropTableQuery) String() string {
	b, err := q.AppendQuery(defaultFmter, nil)
	if err != nil {
		panic(err)
	}
	return string(b)
}

func (q *DropTableQuery) Operation() QueryOp {
	return DropTableOp
}

func (q *DropTableQuery) Clone() QueryCommand {
	return &DropTableQuery{
		q:   q.q.Clone(),
		opt: q.opt,
	}
}

func (q *DropTableQuery) Query() *Query {
	return q.q
}

func (q *DropTableQuery) AppendTemplate(b []byte) ([]byte, error) {
	return q.AppendQuery(dummyFormatter{}, b)
}

func (q *DropTableQuery) AppendQuery(fmter QueryFormatter, b []byte) (_ []byte, err error) {
	if q.q.stickyErr != nil {
		return nil, q.q.stickyErr
	}
	if q.q.tableModel == nil {
		return nil, errModelNil
	}

	b = append(b, "DROP TABLE "...)
	if q.opt != nil && q.opt.IfExists {
		b = append(b, "IF EXISTS "...)
	}
	b, err = q.q.appendFirstTable(fmter, b)
	if err != nil {
		return nil, err
	}
	if q.opt != nil && q.opt.Cascade {
		b = append(b, " CASCADE"...)
	}

	return b, q.q.stickyErr
}
