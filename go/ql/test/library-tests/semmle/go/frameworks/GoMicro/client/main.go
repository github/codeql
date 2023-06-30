package main

import (
	pb "codeql-go-tests/frameworks/GoMicro/proto"
	"context"
	"fmt"
	"log"

	"go-micro.dev/v4"
)

func main() {
	// service
	service := micro.NewService()
	service.Init()
	// context
	ctx := context.Background()

	greeterService := pb.NewGreeterService("http://localhost:8000", service.Client())
	// request
	req := pb.Request{Name: "Mona"}
	resp, err := greeterService.Hello(ctx, &req)

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Hello :: %s", resp.Greeting)
}
