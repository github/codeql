package util

// download from
// https://raw.githubusercontent.com/grpc-ecosystem/grpc-gateway/master/protoc-gen-grpc-gateway/httprule/types.go

import (
	"fmt"
	"strings"
)

type template struct {
	verb     string
	template string
	segments []segment
}

type segment interface {
	fmt.Stringer
	compile() (ops []op)
}

type wildcard struct{}

type deepWildcard struct{}

type literal string

type variable struct {
	path     string
	segments []segment
}

func (wildcard) String() string {
	return "*"
}

func (deepWildcard) String() string {
	return "**"
}

func (l literal) String() string {
	return string(l)
}

func (v variable) String() string {
	var segs []string
	for _, s := range v.segments {
		segs = append(segs, s.String())
	}

	return fmt.Sprintf("{%s=%s}", v.path, strings.Join(segs, "/"))
}

func (t template) String() string {
	var segs []string
	for _, s := range t.segments {
		segs = append(segs, s.String())
	}

	str := strings.Join(segs, "/")
	if t.verb != "" {
		str = fmt.Sprintf("%s:%s", str, t.verb)
	}

	return "/" + str
}
