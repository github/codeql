package test

//go:generate depstubber -vendor github.com/aws/aws-lambda-go/lambda Handler,HandlerFunc,Option Start,StartHandler,StartHandlerFunc,StartHandlerWithContext,NewHandler
// FIXME: ^ this currently fails for generic types and functions, like HandlerFunc or StartHandlerFunc. Stubs have been manually created for now.

import (
	"context"

	"github.com/aws/aws-lambda-go/lambda"
)

type Event struct {
	Name string `json:""`
	Age  int    `json:""`
}

type Response struct {
	Message string `json:""`
}

func sink(sink interface{}) {}

// func (TIn)
func Handler0(event *Event) {
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
}

// func (TIn) error
func Handler1(event *Event) error {
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return nil
}

// func (TIn) (TOut, error)
func Handler2(event *Event) (*Response, error) {
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return &Response{Message: ""}, nil
}

// func (context.Context)
func Handler3(ctx context.Context) {
	sink(ctx) // safe
}

// func (context.Context) error
func Handler4(ctx context.Context) error {
	sink(ctx) // safe
	return nil
}

// func (context.Context) (TOut, error)
func Handler5(ctx context.Context) (*Response, error) {
	sink(ctx) // safe
	return &Response{Message: ""}, nil
}

// func (context.Context, TIn)
func Handler6(ctx context.Context, event Event) {
	sink(ctx)        // safe
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
}

// func (context.Context, TIn) error
func Handler7(ctx context.Context, event Event) error {
	sink(ctx)        // safe
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return nil
}

// func (context.Context, TIn) (TOut, error)
func Handler8(ctx context.Context, event Event) (*Response, error) {
	sink(ctx)        // safe
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return &Response{Message: ""}, nil
}

type MyHandlerFunc func(context.Context, []byte) ([]byte, error)

func (f MyHandlerFunc) Invoke(ctx context.Context, payload []byte) ([]byte, error) {
	return f(ctx, payload)
}

func Handler9(ctx context.Context, payload []byte) ([]byte, error) {
	sink(payload) // $ hasTaintFlow="payload"
	return payload, nil
}

type Handler10 struct{}

func (h *Handler10) Invoke(ctx context.Context, payload []byte) ([]byte, error) {
	sink(payload) // $ hasTaintFlow="payload"
	return payload, nil
}

func Handler11(ctx context.Context, event Event) (*Response, error) {
	sink(ctx)        // safe
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return &Response{Message: ""}, nil
}

func Handler12(ctx context.Context, payload []byte) ([]byte, error) {
	sink(payload) // $ hasTaintFlow="payload"
	return payload, nil
}

type Handler13 struct{}

func (h *Handler13) Invoke(ctx context.Context, payload []byte) ([]byte, error) {
	sink(payload) // $ hasTaintFlow="payload"
	return payload, nil
}

func Handler14(ctx context.Context, event Event) (*Response, error) {
	sink(ctx)        // safe
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return &Response{Message: ""}, nil
}

func Handler15(ctx context.Context, event Event) (*Response, error) {
	sink(ctx)        // safe
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return &Response{Message: ""}, nil
}

func Handler16(ctx context.Context, event Event) (*Response, error) {
	sink(ctx)        // safe
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return &Response{Message: ""}, nil
}

func Handler17(ctx context.Context, event Event) (*Response, error) {
	sink(ctx)        // safe
	sink(event.Name) // $ hasTaintFlow="selection of Name"
	sink(event.Age)  // $ hasTaintFlow="selection of Age"
	sink(event)      // $ hasTaintFlow="event"
	return &Response{Message: ""}, nil
}

func main() {
	lambda.Start(Handler0)
	lambda.Start(Handler1)
	lambda.Start(Handler2)
	lambda.Start(Handler3)
	lambda.Start(Handler4)
	lambda.Start(Handler5)
	lambda.Start(Handler6)
	lambda.Start(Handler7)
	lambda.Start(Handler8)
	lambda.Start(func(ctx context.Context, event Event) (*Response, error) {
		sink(ctx)        // safe
		sink(event.Name) // $ hasTaintFlow="selection of Name"
		sink(event.Age)  // $ hasTaintFlow="selection of Age"
		sink(event)      // $ hasTaintFlow="event"
		return &Response{Message: ""}, nil
	})
	lambda.StartHandler(MyHandlerFunc(Handler9))
	lambda.StartHandler(&Handler10{})
	lambda.StartHandlerFunc(Handler11)
	lambda.StartHandlerFunc(func(ctx context.Context, event Event) (*Response, error) {
		sink(ctx)        // safe
		sink(event.Name) // $ hasTaintFlow="selection of Name"
		sink(event.Age)  // $ hasTaintFlow="selection of Age"
		sink(event)      // $ hasTaintFlow="event"
		return &Response{Message: ""}, nil
	})
	lambda.StartHandlerWithContext(context.Background(), MyHandlerFunc(Handler12))
	lambda.StartHandlerWithContext(context.Background(), &Handler13{})
	lambda.StartWithContext(context.Background(), Handler14)
	lambda.StartWithContext(context.Background(), func(ctx context.Context, event Event) (*Response, error) {
		sink(ctx)        // safe
		sink(event.Name) // $ hasTaintFlow="selection of Name"
		sink(event.Age)  // $ hasTaintFlow="selection of Age"
		sink(event)      // $ hasTaintFlow="event"
		return &Response{Message: ""}, nil
	})
	lambda.StartWithOptions(Handler15)
	lambda.StartWithOptions(func(ctx context.Context, event Event) (*Response, error) {
		sink(ctx)        // safe
		sink(event.Name) // $ hasTaintFlow="selection of Name"
		sink(event.Age)  // $ hasTaintFlow="selection of Age"
		sink(event)      // $ hasTaintFlow="event"
		return &Response{Message: ""}, nil
	})
	lambda.NewHandler(Handler16)
	lambda.NewHandler(func(ctx context.Context, event Event) (*Response, error) {
		sink(ctx)        // safe
		sink(event.Name) // $ hasTaintFlow="selection of Name"
		sink(event.Age)  // $ hasTaintFlow="selection of Age"
		sink(event)      // $ hasTaintFlow="event"
		return &Response{Message: ""}, nil
	})
	lambda.NewHandlerWithOptions(Handler17)
	lambda.NewHandlerWithOptions(func(ctx context.Context, event Event) (*Response, error) {
		sink(ctx)        // safe
		sink(event.Name) // $ hasTaintFlow="selection of Name"
		sink(event.Age)  // $ hasTaintFlow="selection of Age"
		sink(event)      // $ hasTaintFlow="event"
		return &Response{Message: ""}, nil
	})
}
