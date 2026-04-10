// Package tsparser provides an interface for parsing TypeScript files and
// implementations backed by different TypeScript compiler versions.
//
// The primary implementation uses the tsgo binary (TypeScript 7's Go-based
// compiler) as a subprocess via its --api mode.
package tsparser

import "io"

// ParseResult holds the parsed AST for a single file.
type ParseResult struct {
	// AST is the parsed AST tree, ready for JSON serialization.
	AST interface{}

	// RawData holds the raw binary-encoded source file data from tsgo.
	// This is present when using the tsgo API backend and needs to be
	// decoded into the AST format expected by the Java extractor.
	RawData []byte
}

// Metadata holds the compiler metadata (syntax kind and node flag mappings).
type Metadata struct {
	SyntaxKinds map[string]int
	NodeFlags   map[string]int
}

// Parser is the interface for TypeScript parsing backends.
type Parser interface {
	// Parse parses the given file and returns the AST.
	Parse(filename string) (*ParseResult, error)

	// GetMetadata returns the syntax kind and node flag mappings for
	// the underlying TypeScript compiler.
	GetMetadata() (*Metadata, error)

	// Reset discards any cached state and returns the parser to a fresh state.
	Reset() error

	// Close shuts down the parser, releasing any resources.
	Close() error
}

// TsgoBinaryFinder locates the tsgo binary. This is separated to allow
// different search strategies (PATH, npm package, env var, etc.).
type TsgoBinaryFinder interface {
	// FindBinary returns the path to the tsgo binary.
	FindBinary() (string, error)
}

// Config configures the parser backend.
type Config struct {
	// TsgoBinary is the explicit path to the tsgo binary.
	// If empty, the binary is found via TsgoBinaryFinder or PATH.
	TsgoBinary string

	// Stderr is where to redirect the tsgo process's stderr.
	// If nil, stderr is discarded.
	Stderr io.Writer
}
