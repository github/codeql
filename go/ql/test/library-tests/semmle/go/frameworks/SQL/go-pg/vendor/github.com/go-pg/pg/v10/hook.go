package pg

import (
	"context"
	"fmt"
	"time"

	"github.com/go-pg/pg/v10/orm"
)

type (
	BeforeScanHook   = orm.BeforeScanHook
	AfterScanHook    = orm.AfterScanHook
	AfterSelectHook  = orm.AfterSelectHook
	BeforeInsertHook = orm.BeforeInsertHook
	AfterInsertHook  = orm.AfterInsertHook
	BeforeUpdateHook = orm.BeforeUpdateHook
	AfterUpdateHook  = orm.AfterUpdateHook
	BeforeDeleteHook = orm.BeforeDeleteHook
	AfterDeleteHook  = orm.AfterDeleteHook
)

//------------------------------------------------------------------------------

type dummyFormatter struct{}

func (dummyFormatter) FormatQuery(b []byte, query string, params ...interface{}) []byte {
	return append(b, query...)
}

// QueryEvent ...
type QueryEvent struct {
	StartTime  time.Time
	DB         orm.DB
	Model      interface{}
	Query      interface{}
	Params     []interface{}
	fmtedQuery []byte
	Result     Result
	Err        error

	Stash map[interface{}]interface{}
}

// QueryHook ...
type QueryHook interface {
	BeforeQuery(context.Context, *QueryEvent) (context.Context, error)
	AfterQuery(context.Context, *QueryEvent) error
}

// UnformattedQuery returns the unformatted query of a query event.
// The query is only valid until the query Result is returned to the user.
func (e *QueryEvent) UnformattedQuery() ([]byte, error) {
	return queryString(e.Query)
}

func queryString(query interface{}) ([]byte, error) {
	switch query := query.(type) {
	case orm.TemplateAppender:
		return query.AppendTemplate(nil)
	case string:
		return dummyFormatter{}.FormatQuery(nil, query), nil
	default:
		return nil, fmt.Errorf("pg: can't append %T", query)
	}
}

// FormattedQuery returns the formatted query of a query event.
// The query is only valid until the query Result is returned to the user.
func (e *QueryEvent) FormattedQuery() ([]byte, error) {
	return e.fmtedQuery, nil
}

// AddQueryHook adds a hook into query processing.
func (db *baseDB) AddQueryHook(hook QueryHook) {
	db.queryHooks = append(db.queryHooks, hook)
}

func (db *baseDB) beforeQuery(
	ctx context.Context,
	ormDB orm.DB,
	model, query interface{},
	params []interface{},
	fmtedQuery []byte,
) (context.Context, *QueryEvent, error) {
	if len(db.queryHooks) == 0 {
		return ctx, nil, nil
	}

	event := &QueryEvent{
		StartTime:  time.Now(),
		DB:         ormDB,
		Model:      model,
		Query:      query,
		Params:     params,
		fmtedQuery: fmtedQuery,
	}

	for i, hook := range db.queryHooks {
		var err error
		ctx, err = hook.BeforeQuery(ctx, event)
		if err != nil {
			if err := db.afterQueryFromIndex(ctx, event, i); err != nil {
				return ctx, nil, err
			}
			return ctx, nil, err
		}
	}

	return ctx, event, nil
}

func (db *baseDB) afterQuery(
	ctx context.Context,
	event *QueryEvent,
	res Result,
	err error,
) error {
	if event == nil {
		return nil
	}

	event.Err = err
	event.Result = res
	return db.afterQueryFromIndex(ctx, event, len(db.queryHooks)-1)
}

func (db *baseDB) afterQueryFromIndex(ctx context.Context, event *QueryEvent, hookIndex int) error {
	for ; hookIndex >= 0; hookIndex-- {
		if err := db.queryHooks[hookIndex].AfterQuery(ctx, event); err != nil {
			return err
		}
	}
	return nil
}

func copyQueryHooks(s []QueryHook) []QueryHook {
	return s[:len(s):len(s)]
}
