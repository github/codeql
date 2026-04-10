package main

import (
	"github.com/github/codeql/javascript/extractor/lib/typescript-go/internal/protocol"
	"github.com/github/codeql/javascript/extractor/lib/typescript-go/internal/tsparser"
)

// Handler implements protocol.Handler by delegating to a tsparser.Parser.
type Handler struct {
	parser       tsparser.Parser
	pendingFiles []string
}

// NewHandler creates a new Handler backed by the given parser.
func NewHandler(parser tsparser.Parser) *Handler {
	return &Handler{parser: parser}
}

func (h *Handler) HandleParse(filename string) (interface{}, error) {
	result, err := h.parser.Parse(filename)
	if err != nil {
		return nil, err
	}
	return result.AST, nil
}

func (h *Handler) HandlePrepareFiles(filenames []string) error {
	h.pendingFiles = filenames
	return nil
}

func (h *Handler) HandleReset() error {
	h.pendingFiles = nil
	return h.parser.Reset()
}

func (h *Handler) HandleGetMetadata() (*protocol.MetadataResponse, error) {
	meta, err := h.parser.GetMetadata()
	if err != nil {
		return nil, err
	}
	return &protocol.MetadataResponse{
		Type:        "metadata",
		SyntaxKinds: meta.SyntaxKinds,
		NodeFlags:   meta.NodeFlags,
	}, nil
}
