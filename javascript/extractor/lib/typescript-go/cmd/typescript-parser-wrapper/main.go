// typescript-parser-wrapper is a drop-in replacement for the Node.js
// TypeScript parser wrapper (lib/typescript/src/main.ts).
//
// It implements the same stdin/stdout JSON protocol, allowing the Java
// extractor to use the TypeScript 7 (Go-based) compiler for parsing
// TypeScript files.
//
// Usage:
//
//	# Server mode (reads commands from stdin):
//	typescript-parser-wrapper
//
//	# Parse a single file:
//	typescript-parser-wrapper file.ts
//
//	# Print version:
//	typescript-parser-wrapper --version
package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/github/codeql/javascript/extractor/lib/typescript-go/internal/protocol"
	"github.com/github/codeql/javascript/extractor/lib/typescript-go/internal/tsparser"
)

const version = "0.1.0"

func main() {
	if len(os.Args) > 1 {
		arg := os.Args[1]
		switch {
		case arg == "--version":
			fmt.Println("typescript-parser-wrapper (Go) version " + version + " with TypeScript 7")
			os.Exit(0)
		case filepath.Ext(arg) == ".ts" || filepath.Ext(arg) == ".tsx":
			if err := parseSingleFile(arg); err != nil {
				fmt.Fprintf(os.Stderr, "Error: %v\n", err)
				os.Exit(1)
			}
			os.Exit(0)
		default:
			fmt.Fprintf(os.Stderr, "Unrecognized file or flag: %s\n", arg)
			os.Exit(1)
		}
	}

	// Server mode
	if err := runServer(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}

func parseSingleFile(filename string) error {
	parser := createParser()
	defer parser.Close()

	result, err := parser.Parse(filename)
	if err != nil {
		return err
	}

	resp := &protocol.ASTResponse{
		Type: "ast",
		AST:  result.AST,
	}

	data, err := marshalJSON(resp)
	if err != nil {
		return err
	}

	os.Stdout.Write(data)
	os.Stdout.Write([]byte("\n"))
	return nil
}

func runServer() error {
	parser := createParser()
	defer parser.Close()

	handler := NewHandler(parser)
	server := protocol.NewServer(handler)
	return server.Run()
}

func createParser() tsparser.Parser {
	config := tsparser.Config{
		TsgoBinary: os.Getenv("SEMMLE_TYPESCRIPT_TSGO_BINARY"),
		Stderr:     os.Stderr,
	}
	return tsparser.NewTsgoParser(config)
}
