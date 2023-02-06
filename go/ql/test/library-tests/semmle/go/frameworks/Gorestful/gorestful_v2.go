package gorestfultest

//go:generate depstubber -vendor github.com/emicklei/go-restful Request,Response

import (
	restful "github.com/emicklei/go-restful"
	"os/exec"
)

type myObjectV2 struct {
	cmd string
}

func requestHandlerV2(request *restful.Request, response *restful.Response) {
	exec.Command(request.QueryParameters("xyz")[0]) // BAD
	exec.Command(request.QueryParameter("xyz"))     // BAD
	val, _ := request.BodyParameter("xyz")
	exec.Command(val)                             // BAD
	exec.Command(request.HeaderParameter("xyz"))  // BAD
	exec.Command(request.PathParameter("xyz"))    // BAD
	exec.Command(request.PathParameters()["xyz"]) // BAD
	obj := myObjectV2{}
	request.ReadEntity(&obj)
	exec.Command(obj.cmd) // BAD
}
