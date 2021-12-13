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

func FunctionWithSliceOfStructsParameter(s []A) string {
	return ""
}

func FunctionWithVarArgsOfStructsParameter(s ...A) string {
	return ""
}
