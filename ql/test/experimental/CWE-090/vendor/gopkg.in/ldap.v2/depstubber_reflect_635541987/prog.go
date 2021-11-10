
package main

import (
	"encoding/gob"
	"flag"
	"fmt"
	"os"
	"reflect"

	"github.com/github/depstubber/model"

	pkg_ "gopkg.in/ldap.v2"
)

var output = flag.String("output", "", "The output file name, or empty to use stdout.")

func main() {
	flag.Parse()

	types := []struct{
		sym string
		typ reflect.Type
	}{
		
	}

	values := []struct{
		sym string
		val reflect.Value
	}{
		
		{ "Authenticate", reflect.ValueOf(pkg_.Authenticate) },
		
		{ "GetGroupsOfUser", reflect.ValueOf(pkg_.GetGroupsOfUser) },
		
	}

	// NOTE: This behaves contrary to documented behaviour if the
	// package name is not the final component of the import path.
	// The reflect package doesn't expose the package name, though.
	pkg := model.NewPackage("gopkg.in/ldap.v2", false)

	for _, t := range types {
		err := pkg.AddType(t.sym, t.typ)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Reflection: %v\n", err)
			os.Exit(1)
		}
	}

	for _, v := range values {
		err := pkg.AddValue(v.sym, v.val)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Reflection: %v\n", err)
			os.Exit(1)
		}
	}

	outfile := os.Stdout
	if len(*output) != 0 {
		var err error
		outfile, err = os.Create(*output)
		if err != nil {
			fmt.Fprintf(os.Stderr, "failed to open output file %q", *output)
		}
		defer func() {
			if err := outfile.Close(); err != nil {
				fmt.Fprintf(os.Stderr, "failed to close output file %q", *output)
				os.Exit(1)
			}
		}()
	}

	if err := gob.NewEncoder(outfile).Encode(model.PackPkg(pkg)); err != nil {
		fmt.Fprintf(os.Stderr, "gob encode: %v\n", err)
		os.Exit(1)
	}
}
