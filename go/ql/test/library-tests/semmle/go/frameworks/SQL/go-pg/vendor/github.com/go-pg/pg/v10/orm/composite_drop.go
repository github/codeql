package orm

type DropCompositeOptions struct {
	IfExists bool
	Cascade  bool
}

type DropCompositeQuery struct {
	q   *Query
	opt *DropCompositeOptions
}

var (
	_ QueryAppender = (*DropCompositeQuery)(nil)
	_ QueryCommand  = (*DropCompositeQuery)(nil)
)

func NewDropCompositeQuery(q *Query, opt *DropCompositeOptions) *DropCompositeQuery {
	return &DropCompositeQuery{
		q:   q,
		opt: opt,
	}
}

func (q *DropCompositeQuery) String() string {
	b, err := q.AppendQuery(defaultFmter, nil)
	if err != nil {
		panic(err)
	}
	return string(b)
}

func (q *DropCompositeQuery) Operation() QueryOp {
	return DropCompositeOp
}

func (q *DropCompositeQuery) Clone() QueryCommand {
	return &DropCompositeQuery{
		q:   q.q.Clone(),
		opt: q.opt,
	}
}

func (q *DropCompositeQuery) Query() *Query {
	return q.q
}

func (q *DropCompositeQuery) AppendTemplate(b []byte) ([]byte, error) {
	return q.AppendQuery(dummyFormatter{}, b)
}

func (q *DropCompositeQuery) AppendQuery(fmter QueryFormatter, b []byte) ([]byte, error) {
	if q.q.stickyErr != nil {
		return nil, q.q.stickyErr
	}
	if q.q.tableModel == nil {
		return nil, errModelNil
	}

	b = append(b, "DROP TYPE "...)
	if q.opt != nil && q.opt.IfExists {
		b = append(b, "IF EXISTS "...)
	}
	b = append(b, q.q.tableModel.Table().Alias...)
	if q.opt != nil && q.opt.Cascade {
		b = append(b, " CASCADE"...)
	}

	return b, q.q.stickyErr
}
