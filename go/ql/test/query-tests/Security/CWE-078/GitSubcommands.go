package main

import (
	"net/http"
	"os/exec"
	"strings"
)

// BAD: using git subcommands that are vulnerable to arbitrary remote command execution
func gitSubcommandsBad(req *http.Request) {
	tainted := req.URL.Query()["cmd"][0]

	exec.Command("git", "clone", tainted)
	exec.Command("git", "fetch", tainted)
	exec.Command("git", "pull", tainted)
	exec.Command("git", "ls-remote", tainted)
	exec.Command("git", "fetch-pack", tainted)
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
	tainted := req.URL.Query()["cmd"][0]

	if !strings.HasPrefix(tainted, "--") {
		exec.Command("git", "clone", tainted) // GOOD, `tainted` cannot start with "--"
	} else {
		exec.Command("git", "clone", tainted) // BAD, `tainted` can start with "--"
	}
}
