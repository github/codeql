package tsparser

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"net/textproto"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"sync"
)

// TsgoParser implements the Parser interface by running the tsgo binary
// as a subprocess using its --api --async (JSON-RPC) mode.
//
// The tsgo API uses LSP-style Content-Length framing with JSON-RPC 2.0.
// The API is project-based: you initialize, create a snapshot (optionally
// opening a project/tsconfig), then query source files from that snapshot.
// Source files are returned as a custom binary encoding (not JSON).
//
// This is a transitional implementation. When the typescript-go project
// exposes a public Go API, this should be replaced with direct in-process
// calls for better performance.
type TsgoParser struct {
	config  Config
	mu      sync.Mutex
	cmd     *exec.Cmd
	stdin   io.WriteCloser
	stdout  *bufio.Reader
	started bool
	nextID  int

	// Cached handles from the API session
	snapshotHandle string
	projectHandle  string
}

// NewTsgoParser creates a parser backed by the tsgo binary.
func NewTsgoParser(config Config) *TsgoParser {
	return &TsgoParser{
		config: config,
		nextID: 1,
	}
}

func (p *TsgoParser) findBinary() (string, error) {
	if p.config.TsgoBinary != "" {
		return p.config.TsgoBinary, nil
	}
	// Look for tsgo on PATH (installed via: npm install -g @typescript/native-preview)
	path, err := exec.LookPath("tsgo")
	if err == nil {
		return path, nil
	}
	return "", fmt.Errorf("tsgo binary not found on PATH; install with: npm install -g @typescript/native-preview")
}

// startProcess starts the tsgo subprocess without sending any API requests.
func (p *TsgoParser) startProcess() error {
	if p.started {
		return nil
	}

	binary, err := p.findBinary()
	if err != nil {
		return err
	}

	p.cmd = exec.Command(binary, "--api", "--async")
	p.cmd.Stderr = p.config.Stderr
	if p.cmd.Stderr == nil {
		p.cmd.Stderr = os.Stderr
	}

	stdin, err := p.cmd.StdinPipe()
	if err != nil {
		return fmt.Errorf("failed to create stdin pipe: %w", err)
	}
	p.stdin = stdin

	stdout, err := p.cmd.StdoutPipe()
	if err != nil {
		return fmt.Errorf("failed to create stdout pipe: %w", err)
	}
	p.stdout = bufio.NewReaderSize(stdout, 10*1024*1024)

	if err := p.cmd.Start(); err != nil {
		return fmt.Errorf("failed to start tsgo: %w", err)
	}

	p.started = true
	return nil
}

// ensureInitialized starts the process and sends the initialize request.
func (p *TsgoParser) ensureInitialized() error {
	if err := p.startProcess(); err != nil {
		return err
	}
	if p.snapshotHandle != "" {
		return nil // Already initialized
	}

	// Send initialize request
	_, err := p.sendRequest("initialize", map[string]interface{}{})
	if err != nil {
		return fmt.Errorf("failed to initialize tsgo API: %w", err)
	}

	return nil
}

// jsonRPCRequest is a JSON-RPC 2.0 request.
type jsonRPCRequest struct {
	JSONRPC string      `json:"jsonrpc"`
	ID      int         `json:"id"`
	Method  string      `json:"method"`
	Params  interface{} `json:"params,omitempty"`
}

// jsonRPCResponse is a JSON-RPC 2.0 response.
type jsonRPCResponse struct {
	JSONRPC string          `json:"jsonrpc"`
	ID      int             `json:"id"`
	Result  json.RawMessage `json:"result,omitempty"`
	Error   *jsonRPCError   `json:"error,omitempty"`
}

type jsonRPCError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

// writeMessage writes an LSP-framed message (Content-Length header + body).
func (p *TsgoParser) writeMessage(data []byte) error {
	header := fmt.Sprintf("Content-Length: %d\r\n\r\n", len(data))
	if _, err := io.WriteString(p.stdin, header); err != nil {
		return err
	}
	_, err := p.stdin.Write(data)
	return err
}

// readMessage reads an LSP-framed message (Content-Length header + body).
func (p *TsgoParser) readMessage() ([]byte, error) {
	tp := textproto.NewReader(p.stdout)
	header, err := tp.ReadMIMEHeader()
	if err != nil {
		return nil, fmt.Errorf("failed to read message header: %w", err)
	}

	lengthStr := header.Get("Content-Length")
	if lengthStr == "" {
		return nil, fmt.Errorf("missing Content-Length header")
	}
	length, err := strconv.Atoi(lengthStr)
	if err != nil {
		return nil, fmt.Errorf("invalid Content-Length: %w", err)
	}

	body := make([]byte, length)
	if _, err := io.ReadFull(p.stdout, body); err != nil {
		return nil, fmt.Errorf("failed to read message body: %w", err)
	}

	return body, nil
}

// sendRequest sends a JSON-RPC request and returns the response. Not locked.
func (p *TsgoParser) sendRequest(method string, params interface{}) (json.RawMessage, error) {
	id := p.nextID
	p.nextID++

	req := jsonRPCRequest{
		JSONRPC: "2.0",
		ID:      id,
		Method:  method,
		Params:  params,
	}

	data, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal request: %w", err)
	}

	if err := p.writeMessage(data); err != nil {
		return nil, fmt.Errorf("failed to write request: %w", err)
	}

	// Read the response
	respData, err := p.readMessage()
	if err != nil {
		return nil, fmt.Errorf("failed to read response: %w", err)
	}

	var resp jsonRPCResponse
	if err := json.Unmarshal(respData, &resp); err != nil {
		return nil, fmt.Errorf("failed to parse response: %w", err)
	}

	if resp.Error != nil {
		return nil, fmt.Errorf("tsgo API error %d: %s", resp.Error.Code, resp.Error.Message)
	}

	return resp.Result, nil
}

// call sends a request with proper locking and initialization.
func (p *TsgoParser) call(method string, params interface{}) (json.RawMessage, error) {
	p.mu.Lock()
	defer p.mu.Unlock()

	if err := p.ensureInitialized(); err != nil {
		return nil, err
	}

	return p.sendRequest(method, params)
}

// updateSnapshotResponse is the response from the updateSnapshot API call.
type updateSnapshotResponse struct {
	Snapshot string `json:"snapshot"`
	Projects []struct {
		ID             string `json:"id"`
		ConfigFileName string `json:"configFileName"`
	} `json:"projects"`
}

// ensureProjectOpen opens a project for the given file's directory using
// a temporary tsconfig, or uses the existing snapshot if already open.
func (p *TsgoParser) ensureProjectOpen(filename string) error {
	if p.snapshotHandle != "" && p.projectHandle != "" {
		return nil
	}

	// Create a snapshot by opening a project.
	// For single-file parsing without a tsconfig, we ask tsgo to open
	// the file's directory as a project. The tsgo API requires a
	// tsconfig path for OpenProject.
	dir := filepath.Dir(filename)
	tsconfigPath := filepath.Join(dir, "tsconfig.json")

	// First try: updateSnapshot with the file's directory tsconfig
	result, err := p.sendRequest("updateSnapshot", map[string]interface{}{
		"openProject": tsconfigPath,
	})
	if err != nil {
		// If no tsconfig exists, try without a project
		result, err = p.sendRequest("updateSnapshot", map[string]interface{}{})
		if err != nil {
			return fmt.Errorf("failed to create snapshot: %w", err)
		}
	}

	var resp updateSnapshotResponse
	if err := json.Unmarshal(result, &resp); err != nil {
		return fmt.Errorf("failed to parse updateSnapshot response: %w", err)
	}

	p.snapshotHandle = resp.Snapshot
	if len(resp.Projects) > 0 {
		p.projectHandle = resp.Projects[0].ID
	}

	return nil
}

// Parse parses the given file using the tsgo API.
//
// The tsgo API is project-based, so for each parse request we ensure
// a project is open, then call getSourceFile. The response is a custom
// binary encoding of the AST (not JSON).
//
// When the public Go API becomes available, this should be replaced
// with direct parser.ParseSourceFile() calls.
func (p *TsgoParser) Parse(filename string) (*ParseResult, error) {
	p.mu.Lock()
	defer p.mu.Unlock()

	if err := p.ensureInitialized(); err != nil {
		return nil, fmt.Errorf("parse %s: %w", filename, err)
	}

	if err := p.ensureProjectOpen(filename); err != nil {
		return nil, fmt.Errorf("parse %s: %w", filename, err)
	}

	params := map[string]interface{}{
		"file": filename,
	}
	if p.snapshotHandle != "" {
		params["snapshot"] = p.snapshotHandle
	}
	if p.projectHandle != "" {
		params["project"] = p.projectHandle
	}

	result, err := p.sendRequest("getSourceFile", params)
	if err != nil {
		return nil, fmt.Errorf("parse %s: %w", filename, err)
	}

	// The result is the binary-encoded source file data (base64 when
	// using JSON protocol). For now, store the raw response.
	// TODO: Decode the binary format into a JSON AST.
	return &ParseResult{
		AST:     result,
		RawData: []byte(result),
	}, nil
}

// GetMetadata returns the syntax kinds and node flags.
func (p *TsgoParser) GetMetadata() (*Metadata, error) {
	return getStaticTS7Metadata(), nil
}

// Reset resets the parser state, killing and restarting the subprocess.
func (p *TsgoParser) Reset() error {
	p.mu.Lock()
	defer p.mu.Unlock()

	p.killProcess()
	p.started = false
	p.nextID = 1
	p.snapshotHandle = ""
	p.projectHandle = ""
	return nil
}

// Close shuts down the tsgo subprocess.
func (p *TsgoParser) Close() error {
	p.mu.Lock()
	defer p.mu.Unlock()

	p.killProcess()
	return nil
}

func (p *TsgoParser) killProcess() {
	if !p.started {
		return
	}

	if p.stdin != nil {
		p.stdin.Close()
	}
	if p.cmd != nil && p.cmd.Process != nil {
		p.cmd.Process.Kill()
		p.cmd.Wait() //nolint:errcheck
	}
	p.started = false
}
