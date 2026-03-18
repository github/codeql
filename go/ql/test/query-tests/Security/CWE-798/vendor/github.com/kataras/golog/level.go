package golog

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/kataras/pio"
)

// Level is a number which defines the log level.
type Level uint32

// MarshalJSON implements the json marshaler for Level.
func (l Level) MarshalJSON() ([]byte, error) {
	if level, ok := Levels[l]; ok {
		return []byte(strconv.Quote(level.Name)), nil
	}

	return nil, fmt.Errorf("unknown level %v", l)
}

// String implements the fmt.Stringer interface for level.
// Returns the level's name.
func (l Level) String() string {
	if level, ok := Levels[l]; ok {
		return level.Name
	}

	return ""
}

// The available built'n log levels, users can add or modify a level via `Levels` field.
const (
	// DisableLevel will disable the printer.
	DisableLevel Level = iota
	// FatalLevel will `os.Exit(1)` no matter the level of the logger.
	// If the logger's level is fatal, error, warn, info or debug
	// then it will print the log message too.
	FatalLevel
	// ErrorLevel will print only errors.
	ErrorLevel
	// WarnLevel will print errors and warnings.
	WarnLevel
	// InfoLevel will print errors, warnings and infos.
	InfoLevel
	// DebugLevel will print on any level, fatals, errors, warnings, infos and debug logs.
	DebugLevel
)

// Levels contains the levels and their
// mapped (pointer of, in order to be able to be modified) metadata, callers
// are allowed to modify this package-level global variable
// without any loses.
var Levels = map[Level]*LevelMetadata{
	DisableLevel: {
		Name:             "disable",
		AlternativeNames: []string{"disabled"},
		Title:            "",
	},
	FatalLevel: {
		Name:      "fatal",
		Title:     "[FTAL]",
		ColorCode: pio.Red,
		Style:     []pio.RichOption{pio.Background},
	},
	ErrorLevel: {
		Name:      "error",
		Title:     "[ERRO]",
		ColorCode: pio.Red,
	},
	WarnLevel: {
		Name:             "warn",
		AlternativeNames: []string{"warning"},
		Title:            "[WARN]",
		ColorCode:        pio.Magenta,
	},
	InfoLevel: {
		Name:      "info",
		Title:     "[INFO]",
		ColorCode: pio.Cyan,
	},
	DebugLevel: {
		Name:      "debug",
		Title:     "[DBUG]",
		ColorCode: pio.Yellow,
	},
}

// ParseLevel returns a `golog.Level` from a string level.
// Note that all existing log levels (name, prefix and color) can be customized
// and new one can be added by the package-level `golog.Levels` map variable.
func ParseLevel(levelName string) Level {
	levelName = strings.ToLower(levelName)

	for level, meta := range Levels {
		if strings.ToLower(meta.Name) == levelName {
			return level
		}

		for _, altName := range meta.AlternativeNames {
			if strings.ToLower(altName) == levelName {
				return level
			}
		}
	}

	return DisableLevel
}

// LevelMetadata describes the information
// behind a log Level, each level has its own unique metadata.
type LevelMetadata struct {
	// The Name of the Level
	// that named (lowercased) will be used
	// to convert a string level on `SetLevel`
	// to the correct Level type.
	Name string
	// AlternativeNames are the names that can be referred to this specific log level.
	// i.e Name = "warn"
	// AlternativeNames = []string{"warning"}, it's an optional field,
	// therefore we keep Name as a simple string and created this new field.
	AlternativeNames []string
	// Tha Title is the prefix of the log level.
	// See `ColorCode` and `Style` too.
	// Both `ColorCode` and `Style` should be respected across writers.
	Title string
	// ColorCode a color for the `Title`.
	ColorCode int
	// Style one or more rich options for the `Title`.
	Style []pio.RichOption
}

// Text returns the text that should be
// prepended to the log message when a specific
// log level is being written.
func (m *LevelMetadata) Text(enableColor bool) string {
	if enableColor {
		return pio.Rich(m.Title, m.ColorCode, m.Style...)
	}
	return m.Title
}

// SetText can modify the prefix that will be prepended
// to the output message log when `Error/Errorf` functions are being used.
func (m *LevelMetadata) SetText(title string, colorCode int, style ...pio.RichOption) {
	m.Title = title
	m.ColorCode = colorCode
	m.Style = style
}

var (
	// ErrorText can modify the prefix that will be prepended
	// to the output message log when `Error/Errorf` functions are being used.
	//
	// If "newColorfulText" is empty then it will update the text color version using
	// the default values by using the new raw text.
	//
	// Defaults to "[ERRO]" and pio.Red("[ERRO]").
	//
	// Deprecated Use `Levels[ErrorLevel].SetText(string, string)` instead.
	ErrorText = Levels[ErrorLevel].SetText

	// WarnText can modify the prefix that will be prepended
	// to the output message log when `Warn/Warnf` functions are being used.
	//
	// If "newColorfulText" is empty then it will update the text color version using
	// the default values by using the new raw text.
	//
	// Defaults to "[WARN]" and pio.Purple("[WARN]").
	//
	// Deprecated Use `Levels[WarnLevel].SetText(string, string)` instead.
	WarnText = Levels[WarnLevel].SetText

	// InfoText can modify the prefix that will be prepended
	// to the output message log when `Info/Infof` functions are being used.
	//
	// If "newColorfulText" is empty then it will update the text color version using
	// the default values by using the new raw text.
	//
	// Defaults to "[INFO]" and pio.LightGreen("[INFO]").
	//
	// Deprecated Use `Levels[InfoLevel].SetText(string, string)` instead.
	InfoText = Levels[InfoLevel].SetText

	// DebugText can modify the prefix that will be prepended
	// to the output message log when `Info/Infof` functions are being used.
	//
	// If "newColorfulText" is empty then it will update the text color version using
	// the default values by using the new raw text.
	//
	// Defaults to "[DBUG]" and pio.Yellow("[DBUG]").
	//
	// Deprecated Use `Levels[DebugLevel].SetText(string, string)` instead.
	DebugText = Levels[DebugLevel].SetText

	// GetTextForLevel is the function which
	// has the "final" responsibility to generate the text (colorful or not)
	// that is prepended to the leveled log message
	// when `Error/Errorf, Warn/Warnf, Info/Infof or Debug/Debugf`
	// functions are being called.
	//
	// It can be used to override the default behavior, at the start-up state.
	GetTextForLevel = func(level Level, enableColor bool) string {
		if meta, ok := Levels[level]; ok {
			return meta.Text(enableColor)
		}
		return ""
	}

	// GetNameForLevel is the function which
	// has the "final" responsibility to generagte the name of the level
	// that is prepended to the leveled log message
	GetNameForLevel = func(level Level) string {
		if meta, ok := Levels[level]; ok {
			return meta.Name
		}
		return ""
	}
)
