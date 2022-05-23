package jsonittest

import (
	jsoniter "github.com/json-iterator/go"
	"os/exec"
)

func getUntrustedString() string {
	return "trouble"
}

func getUntrustedBytes() []byte {
	return []byte{}
}

type myData struct {
	field string
}

func main() {

	var json = jsoniter.ExampleConfig{}
	untrustedInput := getUntrustedBytes()
	untrustedString := getUntrustedString()

	data := myData{}
	json.Unmarshal(untrustedInput, &data)
	exec.Command(data.field)

	data2 := myData{}
	jsoniter.Unmarshal(untrustedInput, &data2)
	exec.Command(data2.field)

	data3 := myData{}
	json.UnmarshalFromString(untrustedString, &data3)
	exec.Command(data3.field)

	data4 := myData{}
	jsoniter.UnmarshalFromString(untrustedString, &data4)
	exec.Command(data4.field)

}
