package tsparser

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// StandaloneParser implements the Parser interface by invoking the tsgo
// binary once per file (non-persistent). This is simpler but slower than
// the TsgoParser which keeps a persistent subprocess.
//
// This is intended as a fallback and for testing. For production use,
// prefer TsgoParser.
type StandaloneParser struct {
	config Config
}

// NewStandaloneParser creates a parser that invokes tsgo once per file.
func NewStandaloneParser(config Config) *StandaloneParser {
	return &StandaloneParser{config: config}
}

func (p *StandaloneParser) findBinary() (string, error) {
	if p.config.TsgoBinary != "" {
		return p.config.TsgoBinary, nil
	}
	path, err := exec.LookPath("tsgo")
	if err == nil {
		return path, nil
	}
	return "", fmt.Errorf("tsgo binary not found on PATH")
}

// Parse parses a single TypeScript file by running tsgo.
// Since tsgo doesn't have a direct "dump AST" mode, this uses a
// minimal tsconfig.json to parse the file and extract diagnostics.
//
// TODO: Replace with direct API call when the tsgo Go API is public.
func (p *StandaloneParser) Parse(filename string) (*ParseResult, error) {
	binary, err := p.findBinary()
	if err != nil {
		return nil, err
	}

	absPath, err := filepath.Abs(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to resolve path: %w", err)
	}

	// Create a temporary tsconfig to parse just this one file.
	tmpDir, err := os.MkdirTemp("", "tsparser-*")
	if err != nil {
		return nil, fmt.Errorf("failed to create temp dir: %w", err)
	}
	defer os.RemoveAll(tmpDir)

	tsconfig := map[string]interface{}{
		"compilerOptions": map[string]interface{}{
			"target":                 "ESNext",
			"module":                 "ESNext",
			"jsx":                    "preserve",
			"experimentalDecorators": true,
			"noResolve":              true,
			"noEmit":                 true,
		},
		"files": []string{absPath},
	}
	tsconfigData, _ := json.Marshal(tsconfig)
	tsconfigPath := filepath.Join(tmpDir, "tsconfig.json")
	if err := os.WriteFile(tsconfigPath, tsconfigData, 0644); err != nil {
		return nil, fmt.Errorf("failed to write tsconfig: %w", err)
	}

	cmd := exec.Command(binary, "--project", tsconfigPath, "--noEmit")
	var stderr strings.Builder
	cmd.Stderr = &stderr
	output, err := cmd.Output()
	if err != nil {
		// tsgo reports type errors via exit code, but the parse may still succeed.
		// We only care about parse errors, not type errors.
		_ = output
	}

	// tsgo doesn't dump the AST directly. For now, return a placeholder
	// indicating the file was processed. The actual AST extraction will
	// need the Go API or a custom tsgo build.
	return &ParseResult{
		AST: map[string]interface{}{
			"kind":   "SourceFile",
			"_note":  "placeholder: tsgo CLI does not support AST dump; awaiting Go API",
			"_file":  absPath,
			"_error": stderr.String(),
		},
	}, nil
}

// GetMetadata returns static TS7 metadata.
func (p *StandaloneParser) GetMetadata() (*Metadata, error) {
	return GetStaticTS7Metadata(), nil
}

// Reset is a no-op for the standalone parser.
func (p *StandaloneParser) Reset() error { return nil }

// Close is a no-op for the standalone parser.
func (p *StandaloneParser) Close() error { return nil }
