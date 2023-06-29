package main

import (
	pb "codeql-go-tests/frameworks/GoMicro/proto"
	"context"
	"fmt"
	"log"

	"go-micro.dev/v4"
)

type Greeter struct{}

func (g *Greeter) Hello(ctx context.Context, req *pb.Request, rsp *pb.Response) error {
	// var access
	name := req.Name
	fmt.Println("Name :: %s", name)
	return nil
}

func main() {
	// service
	service := micro.NewService(
		micro.Name("helloworld"),
		micro.Handle(":8080"),
	)

	service.Init()

	pb.RegisterGreeterHandler(service.Server(), new(Greeter))

	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
