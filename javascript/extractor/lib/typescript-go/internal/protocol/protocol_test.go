package protocol

import (
	"bytes"
	"encoding/json"
	"strings"
	"testing"
)

// mockHandler implements Handler for testing.
type mockHandler struct {
	parseFunc         func(string) (interface{}, error)
	prepareFilesFunc  func([]string) error
	resetFunc         func() error
	getMetadataFunc   func() (*MetadataResponse, error)
}

func (h *mockHandler) HandleParse(filename string) (interface{}, error) {
	if h.parseFunc != nil {
		return h.parseFunc(filename)
	}
	return map[string]interface{}{"kind": "SourceFile"}, nil
}

func (h *mockHandler) HandlePrepareFiles(filenames []string) error {
	if h.prepareFilesFunc != nil {
		return h.prepareFilesFunc(filenames)
	}
	return nil
}

func (h *mockHandler) HandleReset() error {
	if h.resetFunc != nil {
		return h.resetFunc()
	}
	return nil
}

func (h *mockHandler) HandleGetMetadata() (*MetadataResponse, error) {
	if h.getMetadataFunc != nil {
		return h.getMetadataFunc()
	}
	return &MetadataResponse{
		Type:        "metadata",
		SyntaxKinds: map[string]int{"SourceFile": 316},
		NodeFlags:   map[string]int{"None": 0},
	}, nil
}

func TestServerGetMetadata(t *testing.T) {
	input := `{"command":"get-metadata"}` + "\n" + `{"command":"quit"}` + "\n"
	var output bytes.Buffer

	handler := &mockHandler{}
	server := NewServerWithIO(handler, strings.NewReader(input), &output)

	if err := server.Run(); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	var resp MetadataResponse
	if err := json.Unmarshal(output.Bytes()[:bytes.IndexByte(output.Bytes(), '\n')], &resp); err != nil {
		t.Fatalf("failed to parse response: %v", err)
	}

	if resp.Type != "metadata" {
		t.Errorf("expected type 'metadata', got %q", resp.Type)
	}
	if _, ok := resp.SyntaxKinds["SourceFile"]; !ok {
		t.Error("expected syntaxKinds to contain SourceFile")
	}
}

func TestServerParse(t *testing.T) {
	input := `{"command":"parse","filename":"test.ts"}` + "\n" + `{"command":"quit"}` + "\n"
	var output bytes.Buffer

	handler := &mockHandler{}
	server := NewServerWithIO(handler, strings.NewReader(input), &output)

	if err := server.Run(); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	var resp ASTResponse
	if err := json.Unmarshal(output.Bytes()[:bytes.IndexByte(output.Bytes(), '\n')], &resp); err != nil {
		t.Fatalf("failed to parse response: %v", err)
	}

	if resp.Type != "ast" {
		t.Errorf("expected type 'ast', got %q", resp.Type)
	}
}

func TestServerPrepareFiles(t *testing.T) {
	input := `{"command":"prepare-files","filenames":["a.ts","b.ts"]}` + "\n" + `{"command":"quit"}` + "\n"
	var output bytes.Buffer

	var receivedFiles []string
	handler := &mockHandler{
		prepareFilesFunc: func(files []string) error {
			receivedFiles = files
			return nil
		},
	}
	server := NewServerWithIO(handler, strings.NewReader(input), &output)

	if err := server.Run(); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if len(receivedFiles) != 2 || receivedFiles[0] != "a.ts" || receivedFiles[1] != "b.ts" {
		t.Errorf("expected [a.ts b.ts], got %v", receivedFiles)
	}
}

func TestServerReset(t *testing.T) {
	input := `{"command":"reset"}` + "\n" + `{"command":"quit"}` + "\n"
	var output bytes.Buffer

	resetCalled := false
	handler := &mockHandler{
		resetFunc: func() error {
			resetCalled = true
			return nil
		},
	}
	server := NewServerWithIO(handler, strings.NewReader(input), &output)

	if err := server.Run(); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if !resetCalled {
		t.Error("expected reset to be called")
	}

	var resp ResetDoneResponse
	if err := json.Unmarshal(output.Bytes()[:bytes.IndexByte(output.Bytes(), '\n')], &resp); err != nil {
		t.Fatalf("failed to parse response: %v", err)
	}

	if resp.Type != "reset-done" {
		t.Errorf("expected type 'reset-done', got %q", resp.Type)
	}
}

func TestServerQuit(t *testing.T) {
	input := `{"command":"quit"}` + "\n"
	var output bytes.Buffer

	handler := &mockHandler{}
	server := NewServerWithIO(handler, strings.NewReader(input), &output)

	if err := server.Run(); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	// No output expected for quit
	if output.Len() != 0 {
		t.Errorf("expected no output, got %q", output.String())
	}
}
