package main

import (
	"context"

	"github.com/go-kit/kit/endpoint"
)

type MyService interface {
	Lit(string) string
	Func(string) string
}

func makeEndpointLit(svc MyService) endpoint.Endpoint {
	return func(_ context.Context, request interface{}) (interface{}, error) { // $ source="definition of request"
		return request, nil
	}
}

func endpointfn(_ context.Context, request interface{}) (interface{}, error) { // $ source="definition of request"
	return request, nil
}

func makeEndpointFn(svc MyService) endpoint.Endpoint {
	return endpointfn
}

func main() {}
