package internal

import (
	"context"
	"time"
)

type UndoneContext struct {
	context.Context
}

func UndoContext(ctx context.Context) UndoneContext {
	return UndoneContext{Context: ctx}
}

func (UndoneContext) Deadline() (deadline time.Time, ok bool) {
	return time.Time{}, false
}

func (UndoneContext) Done() <-chan struct{} {
	return nil
}

func (UndoneContext) Err() error {
	return nil
}
