// Package protocol implements the line-delimited JSON protocol used to
// communicate between the Java extractor and the TypeScript parser wrapper.
//
// The protocol matches the one implemented by the Node.js wrapper in
// lib/typescript/src/main.ts. Commands are read from stdin as one JSON
// object per line, and responses are written to stdout in the same format.
package protocol

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"os"
)

// Command represents a parsed command from the Java extractor.
type Command struct {
	Command   string   `json:"command"`
	Filename  string   `json:"filename,omitempty"`
	Filenames []string `json:"filenames,omitempty"`
}

// Response is the interface for all protocol responses.
type Response interface {
	ResponseType() string
}

// MetadataResponse is sent in reply to a "get-metadata" command.
type MetadataResponse struct {
	Type        string         `json:"type"`
	SyntaxKinds map[string]int `json:"syntaxKinds"`
	NodeFlags   map[string]int `json:"nodeFlags"`
}

func (r *MetadataResponse) ResponseType() string { return "metadata" }

// OKResponse is sent in reply to a "prepare-files" command.
type OKResponse struct {
	Type string `json:"type"`
}

func (r *OKResponse) ResponseType() string { return "ok" }

// ASTResponse is sent in reply to a "parse" command.
type ASTResponse struct {
	Type string      `json:"type"`
	AST  interface{} `json:"ast"`
}

func (r *ASTResponse) ResponseType() string { return "ast" }

// ResetDoneResponse is sent in reply to a "reset" command.
type ResetDoneResponse struct {
	Type string `json:"type"`
}

func (r *ResetDoneResponse) ResponseType() string { return "reset-done" }

// ErrorResponse is sent when an error occurs during processing.
type ErrorResponse struct {
	Type    string `json:"type"`
	Message string `json:"message"`
}

func (r *ErrorResponse) ResponseType() string { return "error" }

// Handler defines the interface for handling protocol commands.
type Handler interface {
	// HandleParse parses a TypeScript file and returns the AST.
	HandleParse(filename string) (interface{}, error)

	// HandlePrepareFiles informs the handler that the given files will be
	// requested in order, allowing pre-parsing.
	HandlePrepareFiles(filenames []string) error

	// HandleReset resets the handler to a fresh state.
	HandleReset() error

	// HandleGetMetadata returns the syntax kind and node flag mappings.
	HandleGetMetadata() (*MetadataResponse, error)
}

// Server reads commands from stdin and dispatches them to a Handler.
type Server struct {
	handler Handler
	in      io.Reader
	out     io.Writer
}

// NewServer creates a new protocol server.
func NewServer(handler Handler) *Server {
	return &Server{
		handler: handler,
		in:      os.Stdin,
		out:     os.Stdout,
	}
}

// NewServerWithIO creates a server with custom I/O streams (for testing).
func NewServerWithIO(handler Handler, in io.Reader, out io.Writer) *Server {
	return &Server{
		handler: handler,
		in:      in,
		out:     out,
	}
}

// Run reads commands from stdin and processes them until a "quit" command
// is received or stdin is closed.
func (s *Server) Run() error {
	scanner := bufio.NewScanner(s.in)
	// Allow for very large JSON payloads.
	scanner.Buffer(make([]byte, 1024*1024), 100*1024*1024)

	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			continue
		}

		var cmd Command
		if err := json.Unmarshal([]byte(line), &cmd); err != nil {
			s.writeResponse(&ErrorResponse{
				Type:    "error",
				Message: fmt.Sprintf("failed to parse command: %v", err),
			})
			continue
		}

		quit, err := s.dispatch(cmd)
		if err != nil {
			s.writeResponse(&ErrorResponse{
				Type:    "error",
				Message: err.Error(),
			})
			continue
		}
		if quit {
			return nil
		}
	}

	return scanner.Err()
}

func (s *Server) dispatch(cmd Command) (quit bool, err error) {
	switch cmd.Command {
	case "parse":
		ast, err := s.handler.HandleParse(cmd.Filename)
		if err != nil {
			return false, err
		}
		s.writeResponse(&ASTResponse{
			Type: "ast",
			AST:  ast,
		})
	case "prepare-files":
		if err := s.handler.HandlePrepareFiles(cmd.Filenames); err != nil {
			return false, err
		}
		s.writeResponse(&OKResponse{Type: "ok"})
	case "reset":
		if err := s.handler.HandleReset(); err != nil {
			return false, err
		}
		s.writeResponse(&ResetDoneResponse{Type: "reset-done"})
	case "get-metadata":
		resp, err := s.handler.HandleGetMetadata()
		if err != nil {
			return false, err
		}
		s.writeResponse(resp)
	case "quit":
		return true, nil
	default:
		return false, fmt.Errorf("unknown command: %s", cmd.Command)
	}
	return false, nil
}

func (s *Server) writeResponse(resp Response) {
	data, err := json.Marshal(resp)
	if err != nil {
		// If we can't marshal the response, write an error.
		fmt.Fprintf(s.out, `{"type":"error","message":"marshal error: %s"}`+"\n", err.Error())
		return
	}
	s.out.Write(data)
	s.out.Write([]byte("\n"))
}
