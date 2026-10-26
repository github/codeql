package test

import "os"

func loopThroughCommandArgs() {
	for _, arg := range os.Args { // $ source
		_ = arg
	}
}
