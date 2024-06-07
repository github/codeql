package diagnostics

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"
	"time"
)

type sourceStruct struct {
	Id            string `json:"id"`
	Name          string `json:"name"`
	ExtractorName string `json:"extractorName"`
}

type diagnosticSeverity string

const (
	severityError   diagnosticSeverity = "error"
	severityWarning diagnosticSeverity = "warning"
	severityNote    diagnosticSeverity = "note"
)

type visibilityStruct struct {
	StatusPage      bool `json:"statusPage"`      // True if the message should be displayed on the status page (defaults to false)
	CliSummaryTable bool `json:"cliSummaryTable"` // True if the message should be counted in the diagnostics summary table printed by `codeql database analyze` (defaults to false)
	Telemetry       bool `json:"telemetry"`       // True if the message should be sent to telemetry (defaults to false)
}

var fullVisibility *visibilityStruct = &visibilityStruct{true, true, true}
var telemetryOnly *visibilityStruct = &visibilityStruct{false, false, true}

type locationStruct struct {
	File        string `json:"file,omitempty"`
	StartLine   int    `json:"startLine,omitempty"`
	StartColumn int    `json:"startColumn,omitempty"`
	EndLine     int    `json:"endLine,omitempty"`
	EndColumn   int    `json:"endColumn,omitempty"`
}

var noLocation *locationStruct = nil

type diagnostic struct {
	Timestamp       string            `json:"timestamp"`
	Source          sourceStruct      `json:"source"`
	MarkdownMessage string            `json:"markdownMessage"`
	Severity        string            `json:"severity"`
	Visibility      *visibilityStruct `json:"visibility,omitempty"` // Use a pointer so that it is omitted if nil
	Location        *locationStruct   `json:"location,omitempty"`   // Use a pointer so that it is omitted if nil
}

var diagnosticsEmitted, diagnosticsLimit uint = 0, 100
var noDiagnosticDirPrinted bool = false

func emitDiagnostic(sourceid, sourcename, markdownMessage string, severity diagnosticSeverity, visibility *visibilityStruct, location *locationStruct) {
	if diagnosticsEmitted < diagnosticsLimit {
		diagnosticsEmitted += 1

		diagnosticDir := os.Getenv("CODEQL_EXTRACTOR_GO_DIAGNOSTIC_DIR")
		if diagnosticDir == "" {
			if !noDiagnosticDirPrinted {
				log.Println("No diagnostic directory set, so not emitting diagnostic")
				noDiagnosticDirPrinted = true
			}
			return
		}

		timestamp := time.Now().UTC().Format("2006-01-02T15:04:05.000") + "Z"

		var d diagnostic

		if diagnosticsEmitted < diagnosticsLimit {
			d = diagnostic{
				timestamp,
				sourceStruct{sourceid, sourcename, "go"},
				markdownMessage,
				string(severity),
				visibility,
				location,
			}
		} else {
			d = diagnostic{
				timestamp,
				sourceStruct{"go/autobuilder/diagnostic-limit-reached", "Diagnostics limit exceeded", "go"},
				fmt.Sprintf("CodeQL has produced more than the maximum number of diagnostics. Only the first %d have been reported.", diagnosticsLimit),
				string(severityWarning),
				fullVisibility,
				noLocation,
			}
		}

		content, err := json.Marshal(d)
		if err != nil {
			log.Println(err)
			return
		}

		targetFile, err := os.CreateTemp(diagnosticDir, "go-extractor.*.json")
		if err != nil {
			log.Println("Failed to create diagnostic file: ")
			log.Println(err)
			return
		}
		defer func() {
			if err := targetFile.Close(); err != nil {
				log.Println("Failed to close diagnostic file:")
				log.Println(err)
			}
		}()

		_, err = targetFile.Write(content)
		if err != nil {
			log.Println("Failed to write to diagnostic file: ")
			log.Println(err)
		}
	}
}

func EmitPackageDifferentOSArchitecture(pkgPath string) {
	emitDiagnostic(
		"go/autobuilder/package-different-os-architecture",
		"An imported package is intended for a different OS or architecture",
		"`"+pkgPath+"` could not be imported. Make sure the `GOOS` and `GOARCH` [environment variables are correctly set](https://docs.github.com/en/actions/learn-github-actions/variables#defining-environment-variables-for-a-single-workflow). Alternatively, [change your OS and architecture](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#using-a-github-hosted-runner).",
		severityWarning,
		fullVisibility,
		noLocation,
	)
}

func plural(n int, singular, plural string) string {
	if n == 1 {
		return singular
	} else {
		return plural
	}
}

const maxNumPkgPaths = 5

func EmitCannotFindPackages(pkgPaths []string) {
	numPkgPaths := len(pkgPaths)

	numPrinted := numPkgPaths
	truncated := false
	if numPrinted > maxNumPkgPaths {
		numPrinted = maxNumPkgPaths
		truncated = true
	}

	secondLine := "`" + strings.Join(pkgPaths[0:numPrinted], "`, `") + "`"
	if truncated {
		secondLine += fmt.Sprintf(" and %d more", numPkgPaths-maxNumPkgPaths)
	}

	emitDiagnostic(
		"go/autobuilder/package-not-found",
		"Some packages could not be found",
		fmt.Sprintf(
			"%d package%s could not be found:\n\n%s.\n\nDefinitions in those packages may not be recognized by CodeQL, and files that use them may only be partially analyzed.\n\nCheck that the paths are correct and make sure any private packages can be accessed. If any of the packages are present in the repository then you may need a [custom build command](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-the-codeql-workflow-for-compiled-languages).",
			numPkgPaths,
			plural(len(pkgPaths), "", "s"),
			secondLine),
		severityWarning,
		fullVisibility,
		noLocation,
	)
}

func EmitNewerGoVersionNeeded(installedVersion string, requiredVersion string) {
	emitDiagnostic(
		"go/autobuilder/newer-go-version-needed",
		"Newer Go version needed",
		"Version `"+installedVersion+"` of Go is installed, but this is lower than `"+requiredVersion+"` required by your project's `go.mod`. [Install a newer version of Go before analyzing your project](https://github.com/actions/setup-go#basic).",
		severityError,
		fullVisibility,
		noLocation,
	)
}

func EmitGoFilesFoundButNotProcessed() {
	emitDiagnostic(
		"go/autobuilder/go-files-found-but-not-processed",
		"Go files were found but not processed",
		"[Specify a custom build command](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-the-codeql-workflow-for-compiled-languages) that includes one or more `go build` commands to build the `.go` files to be analyzed.",
		severityError,
		fullVisibility,
		noLocation,
	)
}

func EmitRelativeImportPaths() {
	emitDiagnostic(
		"go/autobuilder/relative-import-paths",
		"Some imports use unsupported relative package paths",
		"You should replace relative package paths (that contain `.` or `..`) with absolute paths. Alternatively you can [use a Go module](https://go.dev/blog/using-go-modules).",
		severityError,
		fullVisibility,
		noLocation,
	)
}

// The following diagnostics are telemetry-only.

func EmitBazelBuildFilesFound(bazelPaths []string) {
	emitDiagnostic(
		"go/autobuilder/bazel-build-file-found",
		"Bazel BUILD files were found",
		fmt.Sprintf(
			"%d bazel BUILD %s found:\n\n`%s`",
			len(bazelPaths),
			plural(len(bazelPaths), "file was", "files were"),
			strings.Join(bazelPaths, "`, `")),
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGopkgTomlFound() {
	emitDiagnostic(
		"go/autobuilder/gopkg-toml-found",
		"A dep `Gopkg.toml` file was found",
		"A dep `Gopkg.toml` file was found",
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGlideYamlFound() {
	emitDiagnostic(
		"go/autobuilder/glide-yaml-found",
		"A Glide `glide.yaml` file was found",
		"A Glide `glide.yaml` file was found",
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoWorkFound(goWorkPaths []string) {
	emitDiagnostic(
		"go/autobuilder/go-work-found",
		"`go.work` file found",
		fmt.Sprintf(
			"%d `go.work` %s found:\n\n`%s`",
			len(goWorkPaths),
			plural(len(goWorkPaths), "file was", "files were"),
			strings.Join(goWorkPaths, "`, `")),
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoFilesOutsideGoModules(goModPaths []string) {
	emitDiagnostic(
		"go/autobuilder/go-files-outside-go-modules",
		"Go files were found outside Go modules",
		"Go files were found outside of the Go modules corresponding to these `go.mod` files.\n\n`"+strings.Join(goModPaths, "`, `")+"`",
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitMultipleGoModFoundNested(goModPaths []string) {
	emitDiagnostic(
		"go/autobuilder/multiple-go-mod-found-nested",
		"Multiple `go.mod` files were found, all nested under one root `go.mod` file",
		fmt.Sprintf(
			"%d `go.mod` files were found:\n\n`%s`",
			len(goModPaths),
			strings.Join(goModPaths, "`, `")),
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitMultipleGoModFoundNotNested(goModPaths []string) {
	emitDiagnostic(
		"go/autobuilder/multiple-go-mod-found-not-nested",
		"Multiple `go.mod` files found, not all nested under one root `go.mod` file",
		fmt.Sprintf(
			"%d `go.mod` files were found:\n\n`%s`",
			len(goModPaths),
			strings.Join(goModPaths, "`, `")),
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitSingleRootGoModFound(goModPath string) {
	emitDiagnostic(
		"go/autobuilder/single-root-go-mod-found",
		"A single `go.mod` file was found in the root",
		"A single `go.mod` file was found.\n\n`"+goModPath+"`",
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitSingleNonRootGoModFound(goModPath string) {
	emitDiagnostic(
		"go/autobuilder/single-non-root-go-mod-found",
		"A single, non-root `go.mod` file was found",
		"A single, non-root `go.mod` file was found.\n\n`"+goModPath+"`",
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

// The following diagnostics are related to identifying the build environment.

func EmitNoGoModAndNoGoEnv(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-no-go-mod-no-go-env",
		"No `go.mod` file found and no Go version in environment",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitNoGoModAndGoEnvUnsupported(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-no-go-mod-go-env-unsupported",
		"No `go.mod` file found and Go version in environment is unsupported",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitNoGoModAndGoEnvSupported(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-no-go-mod-go-env-supported",
		"No `go.mod` file found and Go version in environment is supported",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionTooHighAndNoGoEnv(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-too-high-no-go-env",
		"Go version in `go.mod` file above supported range and no Go version in environment",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionTooHighAndEnvVersionTooHigh(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-too-high-go-env-too-high",
		"Go version in `go.mod` file above supported range and Go version in environment above supported range",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionTooHighAndEnvVersionTooLow(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-too-high-go-env-too-low",
		"Go version in `go.mod` file above supported range and Go version in environment below supported range",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionTooHighAndEnvVersionBelowMax(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-too-high-go-env-below-max",
		"Go version in `go.mod` file above supported range and Go version in environment is supported and below the maximum supported version",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionTooHighAndEnvVersionMax(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-too-high-go-env-max",
		"Go version in `go.mod` file above supported range and Go version in environment is the maximum supported version",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionTooLowAndNoGoEnv(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-too-low-no-go-env",
		"Go version in `go.mod` file below supported range and no Go version in environment",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionTooLowAndEnvVersionUnsupported(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-too-low-go-env-unsupported",
		"Go version in `go.mod` file below supported range and Go version in environment unsupported",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionTooLowAndEnvVersionSupported(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-too-low-go-env-supported",
		"Go version in `go.mod` file below supported range and Go version in environment supported",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionSupportedAndNoGoEnv(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-supported-no-go-env",
		"Go version in `go.mod` file in supported range and no Go version in environment",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionSupportedAndGoEnvUnsupported(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-supported-go-env-unsupported",
		"Go version in `go.mod` file in supported range and Go version in environment unsupported",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionSupportedHigherGoEnv(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-supported-higher-than-go-env",
		"The Go version in `go.mod` file is supported and higher than the Go version in environment",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitGoModVersionSupportedLowerEqualGoEnv(msg string) {
	emitDiagnostic(
		"go/autobuilder/env-go-mod-version-supported-lower-than-or-equal-to-go-env",
		"The Go version in `go.mod` file is supported and lower than or equal to the Go version in environment",
		msg,
		severityNote,
		telemetryOnly,
		noLocation,
	)
}

func EmitNewerSystemGoRequired(requiredVersion string) {
	emitDiagnostic(
		"go/autobuilder/newer-system-go-version-required",
		"The Go version installed on the system is too old to support this project",
		"At least Go version `"+requiredVersion+"` is required to build this project, but the version installed on the system is older. [Install a newer version](https://github.com/actions/setup-go#basic).",
		severityError,
		fullVisibility,
		noLocation,
	)
}

func EmitExtractionFailedForProjects(path []string) {
	emitDiagnostic(
		"go/autobuilder/extraction-failed-for-project",
		"Unable to extract some Go projects",
		fmt.Sprintf(
			"The following %d Go project%s could not be extracted successfully:\n\n`%s`\n",
			len(path),
			plural(len(path), "", "s"),
			strings.Join(path, "`, `")),
		severityWarning,
		fullVisibility,
		noLocation,
	)
}

func EmitInvalidToolchainVersion(goModPath string, version string) {
	emitDiagnostic(
		"go/autobuilder/invalid-go-toolchain-version",
		"Invalid Go toolchain version",
		strings.Join([]string{
			"As of Go 1.21, toolchain versions [must use the 1.N.P syntax](https://go.dev/doc/toolchain#version).",
			fmt.Sprintf("`%s` in `%s` does not match this syntax and there is no additional `toolchain` directive, which may cause some `go` commands to fail.", version, goModPath),
		},
			"\n\n"),
		severityWarning,
		fullVisibility,
		&locationStruct{File: goModPath},
	)
}
