package test

type A struct {
	Field string
}

func FunctionWithParameter(s string) string {
	return ""
}

func FunctionWithSliceParameter(s []string) string {
	return ""
}

func FunctionWithVarArgsParameter(s ...string) string {
	return ""
}
func FunctionWithVarArgsOutParameter(in string, out ...*string) {
}

func FunctionWithSliceOfStructsParameter(s []A) string {
	return ""
}

func FunctionWithVarArgsOfStructsParameter(s ...A) string {
	return ""
}

func VariadicSource(s ...*string) {}

func VariadicSink(s ...string) {}
