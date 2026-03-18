#!/usr/bin/env bash

go test -run="^$" -bench="Range" -benchmem -c -cpuprofile=./pprof.out
go test -run="^$" -bench="Range" -benchmem -cpuprofile=./pprof.out
go tool pprof --pdf --focus="$1" jet.test pprof.out >> out.pdf
rm jet.test
rm pprof.out
open out.pdf