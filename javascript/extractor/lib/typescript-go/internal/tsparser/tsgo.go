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
	"runtime"
	"strconv"
	"sync"

	"github.com/github/codeql/javascript/extractor/lib/typescript-go/internal/astconv"
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
		// The npm-installed tsgo is a Node.js wrapper script that invokes the native binary.
		// Try to resolve the native binary directly so we don't need Node.js at runtime.
		if native := resolveNativeTsgo(path); native != "" {
			return native, nil
		}
		return path, nil
	}
	return "", fmt.Errorf("tsgo binary not found on PATH; install with: npm install -g @typescript/native-preview")
}

// resolveNativeTsgo attempts to find the native tsgo binary inside an npm installation.
// The npm package @typescript/native-preview installs a Node.js wrapper at bin/tsgo
// which delegates to a platform-specific native binary at:
//   node_modules/@typescript/native-preview-<platform>-<arch>/lib/tsgo
func resolveNativeTsgo(wrapperPath string) string {
	// Follow symlinks to find the real wrapper location
	resolved, err := filepath.EvalSymlinks(wrapperPath)
	if err != nil {
		return ""
	}
	// The wrapper is at <prefix>/bin/tsgo.js or <prefix>/bin/tsgo
	// The native binary is at <prefix>/node_modules/@typescript/native-preview-<os>-<arch>/lib/tsgo
	pkgDir := filepath.Dir(filepath.Dir(resolved))
	platformPkg := fmt.Sprintf("@typescript/native-preview-%s-%s", runtime.GOOS, runtime.GOARCH)
	native := filepath.Join(pkgDir, "node_modules", platformPkg, "lib", "tsgo")
	if info, err := os.Stat(native); err == nil && !info.IsDir() {
		return native
	}
	return ""
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

	fmt.Fprintf(os.Stderr, "[tsgo] >>> %s id=%d\n", method, id)

	if err := p.writeMessage(data); err != nil {
		return nil, fmt.Errorf("failed to write request: %w", err)
	}

	// Read responses, skipping notifications (messages without a matching id).
	// In --async mode, tsgo may send diagnostic notifications between responses.
	for {
		respData, err := p.readMessage()
		if err != nil {
			return nil, fmt.Errorf("failed to read response: %w", err)
		}

		var resp jsonRPCResponse
		if err := json.Unmarshal(respData, &resp); err != nil {
			return nil, fmt.Errorf("failed to parse response: %w", err)
		}

		// Skip notifications (id=0 means no id field was present in JSON)
		if resp.ID != id {
			continue
		}

		if resp.Error != nil {
			return nil, fmt.Errorf("tsgo API error %d: %s", resp.Error.Code, resp.Error.Message)
		}

		return resp.Result, nil
	}
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

// ensureProjectOpen opens a project for the given file.
// The tsgo API requires a tsconfig for project opening, so if none exists
// in the file's directory, we create a temporary one.
func (p *TsgoParser) ensureProjectOpen(filename string) error {
	if p.snapshotHandle != "" && p.projectHandle != "" {
		return nil
	}

	dir := filepath.Dir(filename)
	base := filepath.Base(filename)
	tsconfigPath := filepath.Join(dir, "tsconfig.json")

	// If no tsconfig exists, create a temporary one
	createdTsconfig := false
	if _, err := os.Stat(tsconfigPath); os.IsNotExist(err) {
		tsconfig := fmt.Sprintf(`{
  "compilerOptions": {
    "target": "esnext",
    "module": "esnext",
    "noEmit": true,
    "strict": false,
    "allowJs": true
  },
  "files": [%q]
}`, base)
		if err := os.WriteFile(tsconfigPath, []byte(tsconfig), 0644); err != nil {
			return fmt.Errorf("failed to create temporary tsconfig: %w", err)
		}
		createdTsconfig = true
	}

	result, err := p.sendRequest("updateSnapshot", map[string]interface{}{
		"openProject": tsconfigPath,
	})

	// Clean up temporary tsconfig
	if createdTsconfig {
		os.Remove(tsconfigPath)
	}

	if err != nil {
		return fmt.Errorf("failed to open project: %w", err)
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

	// The result is {"data":"<base64>"} containing a binary-encoded AST.
	var dataResp struct {
		Data string `json:"data"`
	}
	if err := json.Unmarshal(result, &dataResp); err != nil {
		return nil, fmt.Errorf("parse %s: failed to parse getSourceFile response: %w", filename, err)
	}

	binaryAST, err := astconv.DecodeBinaryASTFromBase64(dataResp.Data)
	if err != nil {
		return nil, fmt.Errorf("parse %s: failed to decode binary AST: %w", filename, err)
	}

	kindToName := BuildKindToNameMap()
	converter := astconv.NewConverter(binaryAST, kindToName)
	astObj, err := converter.Convert()
	if err != nil {
		return nil, fmt.Errorf("parse %s: failed to convert AST: %w", filename, err)
	}

	filtered := astconv.FilterWhitelist(astObj)

	return &ParseResult{
		AST:     filtered,
		RawData: []byte(dataResp.Data),
	}, nil
}

// GetMetadata returns the syntax kinds and node flags.
func (p *TsgoParser) GetMetadata() (*Metadata, error) {
	return GetStaticTS7Metadata(), nil
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
