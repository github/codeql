package schema

import (
	"context"
	"database/sql"
	"reflect"
)

type Model interface {
	ScanRows(ctx context.Context, rows *sql.Rows) (int, error)
	Value() interface{}
}

type Query interface {
	QueryAppender
	Operation() string
	GetModel() Model
	GetTableName() string
}

//------------------------------------------------------------------------------

type BeforeAppendModelHook interface {
	BeforeAppendModel(ctx context.Context, query Query) error
}

var beforeAppendModelHookType = reflect.TypeOf((*BeforeAppendModelHook)(nil)).Elem()

//------------------------------------------------------------------------------

type BeforeScanHook interface {
	BeforeScan(context.Context) error
}

var beforeScanHookType = reflect.TypeOf((*BeforeScanHook)(nil)).Elem()

//------------------------------------------------------------------------------

type AfterScanHook interface {
	AfterScan(context.Context) error
}

var afterScanHookType = reflect.TypeOf((*AfterScanHook)(nil)).Elem()

//------------------------------------------------------------------------------

type BeforeScanRowHook interface {
	BeforeScanRow(context.Context) error
}

var beforeScanRowHookType = reflect.TypeOf((*BeforeScanRowHook)(nil)).Elem()

//------------------------------------------------------------------------------

type AfterScanRowHook interface {
	AfterScanRow(context.Context) error
}

var afterScanRowHookType = reflect.TypeOf((*AfterScanRowHook)(nil)).Elem()
