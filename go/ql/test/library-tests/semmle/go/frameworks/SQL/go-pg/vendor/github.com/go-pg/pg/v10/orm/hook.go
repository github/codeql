package orm

import (
	"context"
	"reflect"
)

type hookStubs struct{}

var (
	_ AfterScanHook    = (*hookStubs)(nil)
	_ AfterSelectHook  = (*hookStubs)(nil)
	_ BeforeInsertHook = (*hookStubs)(nil)
	_ AfterInsertHook  = (*hookStubs)(nil)
	_ BeforeUpdateHook = (*hookStubs)(nil)
	_ AfterUpdateHook  = (*hookStubs)(nil)
	_ BeforeDeleteHook = (*hookStubs)(nil)
	_ AfterDeleteHook  = (*hookStubs)(nil)
)

func (hookStubs) AfterScan(ctx context.Context) error {
	return nil
}

func (hookStubs) AfterSelect(ctx context.Context) error {
	return nil
}

func (hookStubs) BeforeInsert(ctx context.Context) (context.Context, error) {
	return ctx, nil
}

func (hookStubs) AfterInsert(ctx context.Context) error {
	return nil
}

func (hookStubs) BeforeUpdate(ctx context.Context) (context.Context, error) {
	return ctx, nil
}

func (hookStubs) AfterUpdate(ctx context.Context) error {
	return nil
}

func (hookStubs) BeforeDelete(ctx context.Context) (context.Context, error) {
	return ctx, nil
}

func (hookStubs) AfterDelete(ctx context.Context) error {
	return nil
}

func callHookSlice(
	ctx context.Context,
	slice reflect.Value,
	ptr bool,
	hook func(context.Context, reflect.Value) (context.Context, error),
) (context.Context, error) {
	var firstErr error
	sliceLen := slice.Len()
	for i := 0; i < sliceLen; i++ {
		v := slice.Index(i)
		if !ptr {
			v = v.Addr()
		}

		var err error
		ctx, err = hook(ctx, v)
		if err != nil && firstErr == nil {
			firstErr = err
		}
	}
	return ctx, firstErr
}

func callHookSlice2(
	ctx context.Context,
	slice reflect.Value,
	ptr bool,
	hook func(context.Context, reflect.Value) error,
) error {
	var firstErr error
	if slice.IsValid() {
		sliceLen := slice.Len()
		for i := 0; i < sliceLen; i++ {
			v := slice.Index(i)
			if !ptr {
				v = v.Addr()
			}

			err := hook(ctx, v)
			if err != nil && firstErr == nil {
				firstErr = err
			}
		}
	}
	return firstErr
}

//------------------------------------------------------------------------------

type BeforeScanHook interface {
	BeforeScan(context.Context) error
}

var beforeScanHookType = reflect.TypeOf((*BeforeScanHook)(nil)).Elem()

func callBeforeScanHook(ctx context.Context, v reflect.Value) error {
	return v.Interface().(BeforeScanHook).BeforeScan(ctx)
}

//------------------------------------------------------------------------------

type AfterScanHook interface {
	AfterScan(context.Context) error
}

var afterScanHookType = reflect.TypeOf((*AfterScanHook)(nil)).Elem()

func callAfterScanHook(ctx context.Context, v reflect.Value) error {
	return v.Interface().(AfterScanHook).AfterScan(ctx)
}

//------------------------------------------------------------------------------

type AfterSelectHook interface {
	AfterSelect(context.Context) error
}

var afterSelectHookType = reflect.TypeOf((*AfterSelectHook)(nil)).Elem()

func callAfterSelectHook(ctx context.Context, v reflect.Value) error {
	return v.Interface().(AfterSelectHook).AfterSelect(ctx)
}

func callAfterSelectHookSlice(
	ctx context.Context, slice reflect.Value, ptr bool,
) error {
	return callHookSlice2(ctx, slice, ptr, callAfterSelectHook)
}

//------------------------------------------------------------------------------

type BeforeInsertHook interface {
	BeforeInsert(context.Context) (context.Context, error)
}

var beforeInsertHookType = reflect.TypeOf((*BeforeInsertHook)(nil)).Elem()

func callBeforeInsertHook(ctx context.Context, v reflect.Value) (context.Context, error) {
	return v.Interface().(BeforeInsertHook).BeforeInsert(ctx)
}

func callBeforeInsertHookSlice(
	ctx context.Context, slice reflect.Value, ptr bool,
) (context.Context, error) {
	return callHookSlice(ctx, slice, ptr, callBeforeInsertHook)
}

//------------------------------------------------------------------------------

type AfterInsertHook interface {
	AfterInsert(context.Context) error
}

var afterInsertHookType = reflect.TypeOf((*AfterInsertHook)(nil)).Elem()

func callAfterInsertHook(ctx context.Context, v reflect.Value) error {
	return v.Interface().(AfterInsertHook).AfterInsert(ctx)
}

func callAfterInsertHookSlice(
	ctx context.Context, slice reflect.Value, ptr bool,
) error {
	return callHookSlice2(ctx, slice, ptr, callAfterInsertHook)
}

//------------------------------------------------------------------------------

type BeforeUpdateHook interface {
	BeforeUpdate(context.Context) (context.Context, error)
}

var beforeUpdateHookType = reflect.TypeOf((*BeforeUpdateHook)(nil)).Elem()

func callBeforeUpdateHook(ctx context.Context, v reflect.Value) (context.Context, error) {
	return v.Interface().(BeforeUpdateHook).BeforeUpdate(ctx)
}

func callBeforeUpdateHookSlice(
	ctx context.Context, slice reflect.Value, ptr bool,
) (context.Context, error) {
	return callHookSlice(ctx, slice, ptr, callBeforeUpdateHook)
}

//------------------------------------------------------------------------------

type AfterUpdateHook interface {
	AfterUpdate(context.Context) error
}

var afterUpdateHookType = reflect.TypeOf((*AfterUpdateHook)(nil)).Elem()

func callAfterUpdateHook(ctx context.Context, v reflect.Value) error {
	return v.Interface().(AfterUpdateHook).AfterUpdate(ctx)
}

func callAfterUpdateHookSlice(
	ctx context.Context, slice reflect.Value, ptr bool,
) error {
	return callHookSlice2(ctx, slice, ptr, callAfterUpdateHook)
}

//------------------------------------------------------------------------------

type BeforeDeleteHook interface {
	BeforeDelete(context.Context) (context.Context, error)
}

var beforeDeleteHookType = reflect.TypeOf((*BeforeDeleteHook)(nil)).Elem()

func callBeforeDeleteHook(ctx context.Context, v reflect.Value) (context.Context, error) {
	return v.Interface().(BeforeDeleteHook).BeforeDelete(ctx)
}

func callBeforeDeleteHookSlice(
	ctx context.Context, slice reflect.Value, ptr bool,
) (context.Context, error) {
	return callHookSlice(ctx, slice, ptr, callBeforeDeleteHook)
}

//------------------------------------------------------------------------------

type AfterDeleteHook interface {
	AfterDelete(context.Context) error
}

var afterDeleteHookType = reflect.TypeOf((*AfterDeleteHook)(nil)).Elem()

func callAfterDeleteHook(ctx context.Context, v reflect.Value) error {
	return v.Interface().(AfterDeleteHook).AfterDelete(ctx)
}

func callAfterDeleteHookSlice(
	ctx context.Context, slice reflect.Value, ptr bool,
) error {
	return callHookSlice2(ctx, slice, ptr, callAfterDeleteHook)
}
