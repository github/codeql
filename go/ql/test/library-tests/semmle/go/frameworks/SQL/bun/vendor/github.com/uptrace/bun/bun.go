package bun

import (
	"context"

	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

type (
	Safe  = schema.Safe
	Ident = schema.Ident

	NullTime  = schema.NullTime
	BaseModel = schema.BaseModel
	Query     = schema.Query

	BeforeAppendModelHook = schema.BeforeAppendModelHook

	BeforeScanRowHook = schema.BeforeScanRowHook
	AfterScanRowHook  = schema.AfterScanRowHook

	// DEPRECATED. Use BeforeScanRowHook instead.
	BeforeScanHook = schema.BeforeScanHook
	// DEPRECATED. Use AfterScanRowHook instead.
	AfterScanHook = schema.AfterScanHook
)

type BeforeSelectHook interface {
	BeforeSelect(ctx context.Context, query *SelectQuery) error
}

type AfterSelectHook interface {
	AfterSelect(ctx context.Context, query *SelectQuery) error
}

type BeforeInsertHook interface {
	BeforeInsert(ctx context.Context, query *InsertQuery) error
}

type AfterInsertHook interface {
	AfterInsert(ctx context.Context, query *InsertQuery) error
}

type BeforeUpdateHook interface {
	BeforeUpdate(ctx context.Context, query *UpdateQuery) error
}

type AfterUpdateHook interface {
	AfterUpdate(ctx context.Context, query *UpdateQuery) error
}

type BeforeDeleteHook interface {
	BeforeDelete(ctx context.Context, query *DeleteQuery) error
}

type AfterDeleteHook interface {
	AfterDelete(ctx context.Context, query *DeleteQuery) error
}

type BeforeCreateTableHook interface {
	BeforeCreateTable(ctx context.Context, query *CreateTableQuery) error
}

type AfterCreateTableHook interface {
	AfterCreateTable(ctx context.Context, query *CreateTableQuery) error
}

type BeforeDropTableHook interface {
	BeforeDropTable(ctx context.Context, query *DropTableQuery) error
}

type AfterDropTableHook interface {
	AfterDropTable(ctx context.Context, query *DropTableQuery) error
}

// SetLogger overwriters default Bun logger.
func SetLogger(logger internal.Logging) {
	internal.Logger = logger
}

func In(slice interface{}) schema.QueryAppender {
	return schema.In(slice)
}
