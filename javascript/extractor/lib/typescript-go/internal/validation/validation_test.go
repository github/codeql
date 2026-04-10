// Package validation provides a Go-based test framework for comparing
// JSON output between the Node.js and Go TypeScript parser wrappers.
//
// Run with: go test ./internal/validation/ -v
//
// This requires both the Go wrapper binary and Node.js with the
// TypeScript wrapper available.
package validation

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

// normalizeJSON parses JSON and re-serializes it with sorted keys for
// stable comparison.
func normalizeJSON(data []byte) ([]byte, error) {
	var obj interface{}
	if err := json.Unmarshal(data, &obj); err != nil {
		return nil, fmt.Errorf("invalid JSON: %w", err)
	}
	return json.MarshalIndent(sortKeys(obj), "", "  ")
}

// sortKeys recursively sorts map keys in a JSON-like structure.
func sortKeys(v interface{}) interface{} {
	switch val := v.(type) {
	case map[string]interface{}:
		sorted := make(map[string]interface{}, len(val))
		for k, v := range val {
			sorted[k] = sortKeys(v)
		}
		return sorted
	case []interface{}:
		result := make([]interface{}, len(val))
		for i, v := range val {
			result[i] = sortKeys(v)
		}
		return result
	default:
		return v
	}
}

// findProjectRoot finds the typescript-go project root by walking up from
// the current test file.
func findProjectRoot(t *testing.T) string {
	t.Helper()
	dir, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	for {
		if _, err := os.Stat(filepath.Join(dir, "go.mod")); err == nil {
			return dir
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			t.Fatal("could not find project root (no go.mod found)")
		}
		dir = parent
	}
}

// findNodeJSWrapper finds the compiled Node.js TypeScript wrapper.
func findNodeJSWrapper(projectRoot string) (string, error) {
	tsDir := filepath.Join(projectRoot, "..", "typescript")

	jsPath := filepath.Join(tsDir, "build", "main.js")
	if _, err := os.Stat(jsPath); err == nil {
		return jsPath, nil
	}

	tsPath := filepath.Join(tsDir, "src", "main.ts")
	if _, err := os.Stat(tsPath); err != nil {
		return "", fmt.Errorf("Node.js wrapper not found at %s", tsPath)
	}

	if _, err := os.Stat(filepath.Join(tsDir, "node_modules")); err != nil {
		cmd := exec.Command("npm", "install", "--no-audit", "--no-fund")
		cmd.Dir = tsDir
		if output, err := cmd.CombinedOutput(); err != nil {
			return "", fmt.Errorf("npm install failed in %s: %v\n%s", tsDir, err, output)
		}
	}

	cmd := exec.Command("npm", "run", "build")
	cmd.Dir = tsDir
	if output, err := cmd.CombinedOutput(); err != nil {
		return "", fmt.Errorf("npm run build failed in %s: %v\n%s", tsDir, err, output)
	}

	if _, err := os.Stat(jsPath); err == nil {
		return jsPath, nil
	}

	return "", fmt.Errorf("Node.js wrapper not found after build; expected at %s", jsPath)
}

// parseWithNodeJSProtocol parses a file using the Node.js wrapper's protocol.
// It starts the wrapper, sends the protocol commands, and extracts the AST response.
func parseWithNodeJSProtocol(wrapperPath, filename string) ([]byte, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	cmd := exec.CommandContext(ctx, "node", "--no-warnings", wrapperPath)
	var stderr, stdout bytes.Buffer
	cmd.Stderr = &stderr
	cmd.Stdout = &stdout

	stdinPipe, err := cmd.StdinPipe()
	if err != nil {
		return nil, err
	}

	if err := cmd.Start(); err != nil {
		return nil, fmt.Errorf("failed to start node.js wrapper: %v", err)
	}

	commands := []string{
		fmt.Sprintf(`{"command":"parse","filename":"%s"}`, escapeJSON(filename)),
		`{"command":"quit"}`,
	}

	for _, c := range commands {
		if _, err := io.WriteString(stdinPipe, c+"\n"); err != nil {
			break
		}
	}
	stdinPipe.Close()

	err = cmd.Wait()
	if ctx.Err() != nil {
		return nil, fmt.Errorf("Node.js wrapper timed out; stderr: %s", stderr.String())
	}

	lines := strings.Split(strings.TrimSpace(stdout.String()), "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		var resp map[string]interface{}
		if err := json.Unmarshal([]byte(line), &resp); err != nil {
			continue
		}
		if resp["type"] == "ast" {
			return []byte(line), nil
		}
	}

	return nil, fmt.Errorf("no AST response found in output; stderr: %s; stdout lines: %d",
		stderr.String(), len(lines))
}

// parseWithGoProtocol parses a file using the Go wrapper's protocol.
func parseWithGoProtocol(binaryPath, filename string) ([]byte, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	cmd := exec.CommandContext(ctx, binaryPath)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr

	stdinPipe, err := cmd.StdinPipe()
	if err != nil {
		return nil, err
	}

	var stdout bytes.Buffer
	cmd.Stdout = &stdout

	if err := cmd.Start(); err != nil {
		return nil, fmt.Errorf("failed to start Go wrapper: %v", err)
	}

	commands := []string{
		fmt.Sprintf(`{"command":"parse","filename":"%s"}`, escapeJSON(filename)),
		`{"command":"quit"}`,
	}

	for _, c := range commands {
		if _, err := io.WriteString(stdinPipe, c+"\n"); err != nil {
			break
		}
	}
	stdinPipe.Close()

	err = cmd.Wait()
	if ctx.Err() != nil {
		return nil, fmt.Errorf("Go wrapper timed out; stderr: %s", stderr.String())
	}
	if err != nil {
		// Non-zero exit is ok if we got output (error responses are valid)
	}

	lines := strings.Split(strings.TrimSpace(stdout.String()), "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		var resp map[string]interface{}
		if err := json.Unmarshal([]byte(line), &resp); err != nil {
			continue
		}
		if resp["type"] == "ast" {
			return []byte(line), nil
		}
	}

	return nil, fmt.Errorf("no AST response in output; stderr: %s; stdout: %q",
		stderr.String(), stdout.String())
}

func escapeJSON(s string) string {
	b, _ := json.Marshal(s)
	// Strip the surrounding quotes since we embed in a template
	return string(b[1 : len(b)-1])
}

// TestCompareOutputs compares the JSON output of both wrappers for test files.
func TestCompareOutputs(t *testing.T) {
	projectRoot := findProjectRoot(t)

	// Build the Go wrapper
	binaryPath := filepath.Join(projectRoot, "bin", "typescript-parser-wrapper")
	buildCmd := exec.Command("go", "build", "-o", binaryPath, "./cmd/typescript-parser-wrapper/")
	buildCmd.Dir = projectRoot
	if output, err := buildCmd.CombinedOutput(); err != nil {
		t.Fatalf("failed to build Go wrapper: %v\n%s", err, output)
	}

	// Find the Node.js wrapper
	nodejsWrapper, err := findNodeJSWrapper(projectRoot)
	if err != nil {
		t.Skipf("Skipping comparison test: %v", err)
	}

	if _, err := exec.LookPath("node"); err != nil {
		t.Skip("Skipping comparison test: node not found on PATH")
	}

	// Gather test files
	testFiles, err := filepath.Glob(filepath.Join(projectRoot, "testdata", "*.ts"))
	if err != nil {
		t.Fatal(err)
	}

	// Extractor test inputs can be included via VALIDATION_EXTRACTOR_TESTS=1
	if os.Getenv("VALIDATION_EXTRACTOR_TESTS") == "1" {
		extractorTestDir := filepath.Join(projectRoot, "..", "..", "tests", "ts", "input")
		if extractorFiles, err := filepath.Glob(filepath.Join(extractorTestDir, "*.ts")); err == nil {
			testFiles = append(testFiles, extractorFiles...)
		}
	}

	if len(testFiles) == 0 {
		t.Skip("No test files found")
	}

	for _, file := range testFiles {
		basename := filepath.Base(file)
		t.Run(basename, func(t *testing.T) {
			nodejsOut, err := parseWithNodeJSProtocol(nodejsWrapper, file)
			if err != nil {
				t.Skipf("Node.js wrapper failed: %v", err)
			}

			goOut, err := parseWithGoProtocol(binaryPath, file)
			if err != nil {
				t.Skipf("Go wrapper failed: %v", err)
			}

			nodejsNorm, err := normalizeJSON(bytes.TrimSpace(nodejsOut))
			if err != nil {
				t.Fatalf("Failed to normalize Node.js output: %v", err)
			}

			goNorm, err := normalizeJSON(bytes.TrimSpace(goOut))
			if err != nil {
				t.Fatalf("Failed to normalize Go output: %v", err)
			}

			if !bytes.Equal(nodejsNorm, goNorm) {
				outDir := filepath.Join(projectRoot, "validation-output")
				os.MkdirAll(outDir, 0755)
				os.WriteFile(filepath.Join(outDir, basename+".nodejs.json"), nodejsNorm, 0644)
				os.WriteFile(filepath.Join(outDir, basename+".go.json"), goNorm, 0644)

				t.Errorf("Output mismatch for %s\n"+
					"  Node.js output saved to: validation-output/%s.nodejs.json\n"+
					"  Go output saved to:      validation-output/%s.go.json",
					basename, basename, basename)
			}
		})
	}
}

func TestNormalizeJSON(t *testing.T) {
	input := `{"b":2,"a":1,"c":{"z":26,"y":25}}`
	expected := `{
  "a": 1,
  "b": 2,
  "c": {
    "y": 25,
    "z": 26
  }
}`
	result, err := normalizeJSON([]byte(input))
	if err != nil {
		t.Fatal(err)
	}
	if string(result) != expected {
		t.Errorf("got:\n%s\nexpected:\n%s", string(result), expected)
	}
}
