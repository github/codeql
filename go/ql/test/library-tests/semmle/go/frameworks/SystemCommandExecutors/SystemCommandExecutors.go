package main

//go:generate depstubber -vendor github.com/codeskyblue/go-sh "" Command,InteractiveSession
//go:generate depstubber -vendor golang.org/x/crypto/ssh Session

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"syscall"

	sh "github.com/codeskyblue/go-sh"
	"golang.org/x/crypto/ssh"
)

func main() {}

func handler(w http.ResponseWriter, req *http.Request) {
	sudo := "sudo"
	shell := "/bin/bash"
	assumedNonShell := "ls"
	args := []string{}

	source := req.URL.Query()["cmd"][0]

	// os.StartProcess: these MUST be caught.
	{
		// `source` is used directly as command:
		os.StartProcess(source, args, nil)

		// `source` flows into a composite literal which is used
		// as arguments, and the command is a shell:
		os.StartProcess(shell, []string{source}, nil)

		// `source` flows into a composite literal as first argument to append:
		os.StartProcess(shell, append([]string{source}, args...), nil)

		// `source` flows into a composite literal as Nth argument to append:
		os.StartProcess(shell, append([]string{sudo}, source), nil)
	}

	// os.StartProcess: `source` MUST NOT be caught here because the first argument is not a ShellOrSudoExecution.
	{
		// `source` is an argument to a non-shell command that does not execute
		// the `source` as a command, i.e. the source is just an argument to a command
		// that will not execute it.
		os.StartProcess(assumedNonShell, []string{source}, nil)

		// as above, except the source is inside a composite literal inside an append:
		os.StartProcess(assumedNonShell, append([]string{source}, args...), nil)

		// source is used inside append as nth argument:
		os.StartProcess(assumedNonShell, append([]string{assumedNonShell}, source), nil)
	}

	// exec.Command: these MUST be caught.
	{
		// source is used directly as command:
		exec.Command(source, args...).Run()

		// source comes as nth arg to a shell:
		exec.Command(shell, "a0", "a1", source)

		// source flows into a composite literal as Nth argument to append:
		exec.Command(shell, append([]string{sudo}, source)...)

		// other ways to compose a command:
		exec.Command("sh", "-c", "GOOS=windows GOARCH=386 go build -ldflags \"-s -w -H=windowsgui\" -o \""+source+".go")
		exec.Command("sudo", "sh", "-c", source)

		// programming-language interpreters:
		exec.Command("ruby", "-e", fmt.Sprintf(`system("ls %s")`, source))
		exec.Command("perl", "-e", fmt.Sprintf(`system("sh sudo cp %s dst")`, source))
		exec.Command("python2.7", "-c", fmt.Sprintf(`import os;os.system("ls %s")`, source))
		exec.Command("python3.6m", "-c", fmt.Sprintf(`import os;os.system("ls %s")`, source))
		// negative examples (args should not be caught):
		exec.Command("python3.7-config", "--includes", source)
		exec.Command("python3-pbr", "sha", source)

		// ssh:
		exec.Command("ssh", "-t", "user@host", "ping "+source)
	}
	// golang.org/x/crypto/ssh
	{
		session := &ssh.Session{}
		session.CombinedOutput(source)
		session.Output(source)
		session.Run(source)
		session.Start(source)
	}
	// github.com/codeskyblue/go-sh
	{
		sh.Command(shell, toInterfaceArray(append([]string{assumedNonShell}, source))...)
		sh.InteractiveSession().Call(shell, toInterfaceArray(append([]string{assumedNonShell}, source))...)
		sh.InteractiveSession().Command(shell, toInterfaceArray(append([]string{assumedNonShell}, source))...)
	}
	// syscall
	{
		syscall.Exec(source, []string{"arg1", "arg2"}, []string{})
		syscall.StartProcess(source, []string{"arg1", "arg2"}, &syscall.ProcAttr{})

		syscall.StartProcess(shell, []string{source, "arg2"}, &syscall.ProcAttr{})
	}
}
func toInterfaceArray(strs []string) []interface{} {
	res := make([]interface{}, 0)
	for _, str := range strs {
		res = append(res, str)
	}
	return res
}
