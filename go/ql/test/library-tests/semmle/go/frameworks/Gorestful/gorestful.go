package gorestfultest

//go:generate depstubber -vendor github.com/emicklei/go-restful/v3 Request,Response

import (
	restful "github.com/emicklei/go-restful/v3"
	"os/exec"
)

type myObject struct {
	cmd string
}

func requestHandler(request *restful.Request, response *restful.Response) {
	exec.Command(request.QueryParameters("xyz")[0]) // BAD
	exec.Command(request.QueryParameter("xyz"))     // BAD
	val, _ := request.BodyParameter("xyz")
	exec.Command(val)                             // BAD
	exec.Command(request.HeaderParameter("xyz"))  // BAD
	exec.Command(request.PathParameter("xyz"))    // BAD
	exec.Command(request.PathParameters()["xyz"]) // BAD
	obj := myObject{}
	request.ReadEntity(&obj)
	exec.Command(obj.cmd) // BAD
}
