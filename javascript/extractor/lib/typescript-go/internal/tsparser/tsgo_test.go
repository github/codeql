package tsparser

import (
	"bytes"
	"encoding/json"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

func TestTsgoInitialize(t *testing.T) {
	if _, err := exec.LookPath("tsgo"); err != nil {
		t.Skip("tsgo not found on PATH; install with: npm install -g @typescript/native-preview")
	}

	parser := NewTsgoParser(Config{Stderr: os.Stderr})
	defer parser.Close()

	// Test that we can start the process and send the initialize request
	parser.mu.Lock()
	err := parser.startProcess()
	if err != nil {
		parser.mu.Unlock()
		t.Fatalf("Failed to start tsgo process: %v", err)
	}

	result, err := parser.sendRequest("initialize", map[string]interface{}{})
	parser.mu.Unlock()
	if err != nil {
		t.Fatalf("Failed to send initialize request: %v", err)
	}

	t.Logf("Initialize response: %s", string(result))

	// Parse the response
	var initResp struct {
		UseCaseSensitiveFileNames bool   `json:"useCaseSensitiveFileNames"`
		CurrentDirectory          string `json:"currentDirectory"`
	}
	if err := json.Unmarshal(result, &initResp); err != nil {
		t.Fatalf("Failed to parse initialize response: %v", err)
	}

	if initResp.CurrentDirectory == "" {
		t.Error("Expected non-empty CurrentDirectory in initialize response")
	}
	t.Logf("Initialized: caseSensitive=%v, cwd=%s",
		initResp.UseCaseSensitiveFileNames, initResp.CurrentDirectory)
}

func TestTsgoPing(t *testing.T) {
	if _, err := exec.LookPath("tsgo"); err != nil {
		t.Skip("tsgo not found on PATH")
	}

	parser := NewTsgoParser(Config{Stderr: os.Stderr})
	defer parser.Close()

	parser.mu.Lock()
	if err := parser.startProcess(); err != nil {
		parser.mu.Unlock()
		t.Fatalf("Failed to start tsgo: %v", err)
	}

	result, err := parser.sendRequest("ping", nil)
	parser.mu.Unlock()
	if err != nil {
		t.Fatalf("Ping failed: %v", err)
	}

	t.Logf("Ping response: %s", string(result))
}

func TestTsgoUpdateSnapshotAndGetSourceFile(t *testing.T) {
	if _, err := exec.LookPath("tsgo"); err != nil {
		t.Skip("tsgo not found on PATH")
	}

	// Find the sample test file
	testFile := findTestFile(t)
	testDir := filepath.Dir(testFile)

	// Create a minimal tsconfig.json for the test file
	tsconfigPath := filepath.Join(testDir, "tsconfig.json")
	tsconfig := []byte(`{
		"compilerOptions": {
			"target": "esnext",
			"module": "esnext",
			"noEmit": true,
			"strict": false
		},
		"files": ["sample.ts"]
	}`)
	if err := os.WriteFile(tsconfigPath, tsconfig, 0644); err != nil {
		t.Fatalf("Failed to create tsconfig.json: %v", err)
	}
	defer os.Remove(tsconfigPath)

	var stderr bytes.Buffer
	parser := NewTsgoParser(Config{Stderr: &stderr})
	defer parser.Close()

	parser.mu.Lock()
	defer parser.mu.Unlock()

	// Step 1: Start and initialize
	if err := parser.startProcess(); err != nil {
		t.Fatalf("Failed to start tsgo: %v", err)
	}

	initResult, err := parser.sendRequest("initialize", map[string]interface{}{})
	if err != nil {
		t.Fatalf("Initialize failed: %v", err)
	}
	t.Logf("Initialize: %s", string(initResult))

	// Step 2: Update snapshot with project
	snapResult, err := parser.sendRequest("updateSnapshot", map[string]interface{}{
		"openProject": tsconfigPath,
	})
	if err != nil {
		t.Logf("Stderr output: %s", stderr.String())
		t.Fatalf("updateSnapshot failed: %v", err)
	}
	t.Logf("UpdateSnapshot: %s", string(snapResult))

	var snapResp updateSnapshotResponse
	if err := json.Unmarshal(snapResult, &snapResp); err != nil {
		t.Fatalf("Failed to parse updateSnapshot response: %v", err)
	}

	if snapResp.Snapshot == "" {
		t.Fatal("Expected non-empty snapshot handle")
	}
	t.Logf("Got snapshot: %s, %d projects", snapResp.Snapshot, len(snapResp.Projects))
	for i, p := range snapResp.Projects {
		t.Logf("  Project %d: id=%s config=%s", i, p.ID, p.ConfigFileName)
	}

	if len(snapResp.Projects) == 0 {
		t.Fatal("Expected at least one project in snapshot")
	}

	// Step 3: Get source file
	sfResult, err := parser.sendRequest("getSourceFile", map[string]interface{}{
		"snapshot": snapResp.Snapshot,
		"project":  snapResp.Projects[0].ID,
		"file":     testFile,
	})
	if err != nil {
		t.Logf("Stderr output: %s", stderr.String())
		t.Fatalf("getSourceFile failed: %v", err)
	}

	// The response should contain base64-encoded binary data
	t.Logf("getSourceFile response length: %d bytes", len(sfResult))
	if len(sfResult) < 10 {
		t.Logf("getSourceFile response: %s", string(sfResult))
	} else {
		t.Logf("getSourceFile response (first 200 chars): %s", string(sfResult[:min(200, len(sfResult))]))
	}

	if len(sfResult) == 0 || string(sfResult) == "null" {
		t.Error("Expected non-empty source file response")
	} else {
		t.Logf("Successfully retrieved source file data from tsgo API!")
	}
}

func TestTsgoGetMetadata(t *testing.T) {
	if _, err := exec.LookPath("tsgo"); err != nil {
		t.Skip("tsgo not found on PATH")
	}

	parser := NewTsgoParser(Config{Stderr: os.Stderr})
	defer parser.Close()

	meta, err := parser.GetMetadata()
	if err != nil {
		t.Fatalf("GetMetadata failed: %v", err)
	}

	if len(meta.SyntaxKinds) == 0 {
		t.Error("Expected non-empty SyntaxKinds")
	}
	if _, ok := meta.SyntaxKinds["SourceFile"]; !ok {
		t.Error("Expected SyntaxKinds to contain 'SourceFile'")
	}
	if len(meta.NodeFlags) == 0 {
		t.Error("Expected non-empty NodeFlags")
	}
}

func TestStaticMetadata(t *testing.T) {
	meta := getStaticTS7Metadata()

	required := []string{"SourceFile", "Identifier", "Block", "VariableStatement",
		"FunctionDeclaration", "ClassDeclaration", "InterfaceDeclaration"}
	for _, kind := range required {
		if _, ok := meta.SyntaxKinds[kind]; !ok {
			t.Errorf("Missing required SyntaxKind: %s", kind)
		}
	}

	requiredFlags := []string{"None", "Let", "Const", "Namespace"}
	for _, flag := range requiredFlags {
		if _, ok := meta.NodeFlags[flag]; !ok {
			t.Errorf("Missing required NodeFlag: %s", flag)
		}
	}
}

func findTestFile(t *testing.T) string {
	t.Helper()
	dir, _ := os.Getwd()
	for {
		candidate := filepath.Join(dir, "testdata", "sample.ts")
		if _, err := os.Stat(candidate); err == nil {
			return candidate
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}
	t.Fatal("Could not find testdata/sample.ts")
	return ""
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
