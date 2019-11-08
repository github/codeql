package main

import (
	"context"
	"fmt"
	"os"
	"os/exec"
)

func main() {
	fmt.Println("Running command...")
	cmd := exec.Command("gcc", "-o", "hello", "hello.c")
	cmd.Run()

	cmd = exec.CommandContext(context.Background(), "sleep", "10000000")
	cmd.Start()

	unusedcmd := exec.Command("example", "of a use of this command")
	fmt.Println(unusedcmd)

	os.StartProcess("go", []string{"version"}, nil)
}
