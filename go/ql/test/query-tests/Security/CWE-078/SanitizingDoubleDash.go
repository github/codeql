package main

import (
	"net/http"
	"os/exec"
)

func testDoubleDashSanitizes(req *http.Request) {
	tainted := req.URL.Query()["cmd"][0]

	// BAD: no sanitizing "--" preceding tainted data
	{
		arrayLit := [1]string{tainted}
		exec.Command("git", arrayLit[:]...)
	}

	// GOOD: sanitizing "--" preceding tainted data
	{
		arrayLit := [2]string{"--", tainted}
		exec.Command("git", arrayLit[:]...)
	}

	// GOOD: sanitizing "--" preceding tainted data, as a slice
	{
		arrayLit := []string{"--", tainted}
		exec.Command("git", arrayLit...)
	}

	// GOOD: sanitizing "--" preceding tainted data, added during an append
	{
		arrayLit := []string{}
		arrayLit = append(arrayLit, "--", tainted)
		exec.Command("git", arrayLit...)
	}

	// BAD: sanitizing "--" comes after tainted data, added during an append
	{
		arrayLit := []string{}
		arrayLit = append(arrayLit, tainted, "--")
		exec.Command("git", arrayLit...)
	}

	// GOOD: sanitizing "--" preceding tainted data, built in two steps
	{
		arrayLit := []string{"--"}
		arrayLit = append(arrayLit, tainted)
		exec.Command("git", arrayLit...)
	}

	// BAD: sanitizing "--" comes after tainted data, built in two steps
	{
		arrayLit := []string{tainted}
		arrayLit = append(arrayLit, "--")
		exec.Command("git", arrayLit...)
	}

	// GOOD: sanitizing "--" preceding tainted data, built in three steps
	{
		arrayLit := []string{"--"}
		arrayLit = append(arrayLit, "something else")
		arrayLit = append(arrayLit, tainted)
		exec.Command("git", arrayLit...)
	}

	// BAD: sanitizing "--" preceding tainted data, built in three steps
	{
		arrayLit := []string{"something else"}
		arrayLit = append(arrayLit, tainted)
		arrayLit = append(arrayLit, "--")
		exec.Command("git", arrayLit...)
	}

	// GOOD: sanitizing "--" preceding tainted data, used directly in a Command
	{
		exec.Command("git", "--", tainted)
	}

	// BAD: sanitizing "--" comes after tainted data, used directly in a Command
	{
		exec.Command("git", tainted, "--")
	}

	// GOOD: sanitizing "--" preceding tainted data, used directly in a Command, after several other arguments
	{
		exec.Command("git", "--arg1", "--arg2", "--", tainted)
	}
}

// This test mirrors testDoubleDashSanitizes above, but uses sudo instead of git, where "--" is not sanitizing.
// All cases are therefore BAD.
func testDoubleDashIrrelevant(req *http.Request) {
	tainted := req.URL.Query()["cmd"][0]

	{
		arrayLit := [1]string{tainted}
		exec.Command("sudo", arrayLit[:]...)
	}

	{
		arrayLit := [2]string{"--", tainted}
		exec.Command("sudo", arrayLit[:]...)
	}

	{
		arrayLit := []string{"--", tainted}
		exec.Command("sudo", arrayLit...)
	}

	{
		arrayLit := []string{}
		arrayLit = append(arrayLit, "--", tainted)
		exec.Command("sudo", arrayLit...)
	}

	{
		arrayLit := []string{}
		arrayLit = append(arrayLit, tainted, "--")
		exec.Command("sudo", arrayLit...)
	}

	{
		arrayLit := []string{"--"}
		arrayLit = append(arrayLit, tainted)
		exec.Command("sudo", arrayLit...)
	}

	{
		arrayLit := []string{tainted}
		arrayLit = append(arrayLit, "--")
		exec.Command("sudo", arrayLit...)
	}

	{
		arrayLit := []string{"--"}
		arrayLit = append(arrayLit, "something else")
		arrayLit = append(arrayLit, tainted)
		exec.Command("sudo", arrayLit...)
	}

	{
		arrayLit := []string{"something else"}
		arrayLit = append(arrayLit, tainted)
		arrayLit = append(arrayLit, "--")
		exec.Command("sudo", arrayLit...)
	}

	{
		exec.Command("sudo", "--", tainted)
	}

	{
		exec.Command("sudo", tainted, "--")
	}
}
