//go:generate protoc -I=protos --go_out=. protos/query.proto
//go:generate depstubber -vendor github.com/golang/protobuf/proto Message Marshal,Unmarshal,ProtoPackageIsVersion4
//go:generate depstubber -vendor google.golang.org/protobuf/reflect/protoreflect EnumDescriptor,EnumType,EnumNumber,Message,FileDescriptor
// the following is done by hand due to limiations of depstubber
//#go:generate depstubber -vendor google.golang.org/protobuf/runtime/protoimpl MessageState,SizeCache,UnknownFields,Pointer,EnforceVersion MinVersion,MaxVersion,UnsafeEnabled,X
//go:generate depstubber -vendor google.golang.org/protobuf/runtime/protoiface MessageV1

package main

import (
	"fmt"
	"github.com/golang/protobuf/proto"

	"codeql-go-tests/protobuf/protos/query"
)

func main() {
	reflectedXSS := &query.Query{
		Description: "Writing user input directly to an HTTP response allows for a cross-site scripting vulnerability.",
		Id:          "go/reflected-xss",
		Alerts: []*query.Query_Alert{
			&query.Query_Alert{
				Msg: "Cross-site scripting vulnerability due to user-provided value.",
				Loc: 23425135,
			},
		},
	}

	desc := reflectedXSS.GetDescription()
	alerts := reflectedXSS.GetAlerts()

	serialized, err := proto.Marshal(reflectedXSS)
	if err != nil {
		// ...
	}

	deserialized := &query.Query{}
	err = proto.Unmarshal(serialized, deserialized)
	if err != nil {
		// error handling
	}

	fmt.Println(desc, alerts)

	fmt.Println(reflectedXSS.Clone())
}
