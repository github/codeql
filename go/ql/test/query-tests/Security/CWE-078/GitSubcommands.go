package main

import (
	"net/http"
	"os/exec"
	"strings"
)

// BAD: using git subcommands that are vulnerable to arbitrary remote command execution
func gitSubcommandsBad(req *http.Request) {
	tainted := req.URL.Query()["cmd"][0] // $ Source[go/command-injection]

	exec.Command("git", "clone", tainted)      // $ Alert[go/command-injection]
	exec.Command("git", "fetch", tainted)      // $ Alert[go/command-injection]
	exec.Command("git", "pull", tainted)       // $ Alert[go/command-injection]
	exec.Command("git", "ls-remote", tainted)  // $ Alert[go/command-injection]
	exec.Command("git", "fetch-pack", tainted) // $ Alert[go/command-injection]
}

// GOOD: using a sampling of git subcommands that are not vulnerable to arbitrary remote command execution
func gitSubcommandsGood(req *http.Request) {
	tainted := req.URL.Query()["cmd"][0]

	exec.Command("git", "checkout", tainted)
	exec.Command("git", "branch", tainted)
	exec.Command("git", "diff", tainted)
	exec.Command("git", "merge", tainted)
	exec.Command("git", "add", tainted)
}

// BAD: using git subcommands that are vulnerable to arbitrary remote command execution
func gitSubcommandsGood2(req *http.Request) {
	tainted := req.URL.Query()["cmd"][0] // $ Source[go/command-injection]

	if !strings.HasPrefix(tainted, "--") {
		exec.Command("git", "clone", tainted) // GOOD, `tainted` cannot start with "--"
	} else {
		exec.Command("git", "clone", tainted) // $ Alert[go/command-injection] // BAD, `tainted` can start with "--"
	}
}
