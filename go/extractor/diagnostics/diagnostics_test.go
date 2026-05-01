package diagnostics

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

type memoryDiagnosticsWriter struct {
	diagnostics []diagnostic
}

func newMemoryDiagnosticsWriter() *memoryDiagnosticsWriter {
	return &memoryDiagnosticsWriter{[]diagnostic{}}
}

func (writer *memoryDiagnosticsWriter) WriteDiagnostic(d diagnostic) {
	writer.diagnostics = append(writer.diagnostics, d)
}

func Test_EmitCannotFindPackages_Default(t *testing.T) {
	writer := newMemoryDiagnosticsWriter()

	// Clear environment variables that affect the diagnostic message.
	t.Setenv("GITHUB_EVENT_NAME", "")
	t.Setenv("GITHUB_ACTIONS", "")

	EmitCannotFindPackages(writer, []string{"github.com/github/foo"})

	assert.Len(t, writer.diagnostics, 1, "Expected one diagnostic to be emitted")

	d := writer.diagnostics[0]
	assert.Equal(t, d.Source.Id, "go/autobuilder/package-not-found")
	assert.Equal(t, d.Severity, string(severityWarning))
	assert.True(t, d.Visibility.CliSummaryTable)
	assert.True(t, d.Visibility.StatusPage)
	assert.True(t, d.Visibility.Telemetry)
	// Non-Actions suggestion for private registries
	assert.Contains(t, d.MarkdownMessage, "ensure that the necessary credentials and environment variables are set up")
	// Custom build command suggestion
	assert.Contains(t, d.MarkdownMessage, "If any of the packages are already present in the repository")
}

func Test_EmitCannotFindPackages_Dynamic(t *testing.T) {
	writer := newMemoryDiagnosticsWriter()

	// Set environment variables that affect the diagnostic message.
	t.Setenv("GITHUB_EVENT_NAME", "dynamic")
	t.Setenv("GITHUB_ACTIONS", "true")

	EmitCannotFindPackages(writer, []string{"github.com/github/foo"})

	assert.Len(t, writer.diagnostics, 1, "Expected one diagnostic to be emitted")

	d := writer.diagnostics[0]
	assert.Equal(t, d.Source.Id, "go/autobuilder/package-not-found")
	assert.Equal(t, d.Severity, string(severityWarning))
	// Dynamic workflow suggestion for private registries
	assert.Contains(t, d.MarkdownMessage, "can grant access to private registries for GitHub security products")
	// No default suggestions for private registries and custom build command
	assert.NotContains(t, d.MarkdownMessage, "ensure that the necessary credentials and environment variables are set up")
	assert.NotContains(t, d.MarkdownMessage, "If any of the packages are already present in the repository")
}

func Test_EmitCannotFindPackages_Actions(t *testing.T) {
	writer := newMemoryDiagnosticsWriter()

	// Set environment variables that affect the diagnostic message.
	t.Setenv("GITHUB_EVENT_NAME", "push")
	t.Setenv("GITHUB_ACTIONS", "true")

	EmitCannotFindPackages(writer, []string{"github.com/github/foo"})

	assert.Len(t, writer.diagnostics, 1, "Expected one diagnostic to be emitted")

	d := writer.diagnostics[0]
	assert.Equal(t, d.Source.Id, "go/autobuilder/package-not-found")
	assert.Equal(t, d.Severity, string(severityWarning))
	// Advanced workflow suggestion for private registries
	assert.Contains(t, d.MarkdownMessage, "add a step to your workflow which sets up")
	// No default suggestion for private registries
	assert.NotContains(t, d.MarkdownMessage, "ensure that the necessary credentials and environment variables are set up")
	// Custom build command suggestion
	assert.Contains(t, d.MarkdownMessage, "If any of the packages are already present in the repository")
}

func Test_EmitPrivateRegistryUsed_Single(t *testing.T) {
	writer := newMemoryDiagnosticsWriter()

	testItems := []string{
		"https://github.com/github/example (Git Source)",
	}

	EmitPrivateRegistryUsed(writer, testItems)

	assert.Len(t, writer.diagnostics, 1, "Expected one diagnostic to be emitted")

	d := writer.diagnostics[0]
	assert.Equal(t, d.Source.Id, "go/autobuilder/analysis-using-private-registries")
	assert.Equal(t, d.Severity, string(severityNote))
	assert.Contains(t, d.MarkdownMessage, "following private package registry")

	for i := range testItems {
		assert.Contains(t, d.MarkdownMessage, testItems[i])
	}
}

func Test_EmitPrivateRegistryUsed_Multiple(t *testing.T) {
	writer := newMemoryDiagnosticsWriter()

	testItems := []string{
		"https://github.com/github/example (Git Source)",
		"https://example.com/goproxy (GOPROXY Server)",
	}

	EmitPrivateRegistryUsed(writer, testItems)

	assert.Len(t, writer.diagnostics, 1, "Expected one diagnostic to be emitted")

	d := writer.diagnostics[0]
	assert.Equal(t, d.Source.Id, "go/autobuilder/analysis-using-private-registries")
	assert.Equal(t, d.Severity, string(severityNote))
	assert.Contains(t, d.MarkdownMessage, "following private package registries")

	for i := range testItems {
		assert.Contains(t, d.MarkdownMessage, testItems[i])
	}
}
