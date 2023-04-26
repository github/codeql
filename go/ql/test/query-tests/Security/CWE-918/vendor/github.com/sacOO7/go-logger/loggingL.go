package logging

type LoggingLevel int

//go:generate stringer -type=LoggingLevel

const (
	TRACE LoggingLevel = iota
	INFO
	WARNING
	ERROR
	OFF
)
