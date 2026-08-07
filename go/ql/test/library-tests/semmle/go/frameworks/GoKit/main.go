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
	return func(_ context.Context, request interface{}) (interface{}, error) {
		return request, nil
	} // $ source="SSA def(request)"
}

func endpointfn(_ context.Context, request interface{}) (interface{}, error) {
	return request, nil
} // $ source="SSA def(request)"

func makeEndpointFn(svc MyService) endpoint.Endpoint {
	return endpointfn
}

func main() {}
