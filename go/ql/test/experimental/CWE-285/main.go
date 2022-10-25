package main

//go:generate depstubber -vendor github.com/msteinert/pam Style,Transaction StartFunc

import (
	"github.com/msteinert/pam"
)

func bad() error {
	t, _ := pam.StartFunc("", "", func(s pam.Style, msg string) (string, error) {
		return "", nil
	})
	return t.Authenticate(0)

}

func good() error {
	t, err := pam.StartFunc("", "", func(s pam.Style, msg string) (string, error) {
		return "", nil
	})
	err = t.Authenticate(0)
	if err != nil {
		return err
	}
	return t.AcctMgmt(0)
}

func main() {}
