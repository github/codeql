package internal

import (
	"fmt"
	"time"
)

const (
	dateFormat         = "2006-01-02"
	timeFormat         = "15:04:05.999999999"
	timetzFormat1      = "15:04:05.999999999-07:00:00"
	timetzFormat2      = "15:04:05.999999999-07:00"
	timetzFormat3      = "15:04:05.999999999-07"
	timestampFormat    = "2006-01-02 15:04:05.999999999"
	timestamptzFormat1 = "2006-01-02 15:04:05.999999999-07:00:00"
	timestamptzFormat2 = "2006-01-02 15:04:05.999999999-07:00"
	timestamptzFormat3 = "2006-01-02 15:04:05.999999999-07"
)

func ParseTime(s string) (time.Time, error) {
	l := len(s)

	if l >= len("2006-01-02 15:04:05") {
		switch s[10] {
		case ' ':
			if c := s[l-6]; c == '+' || c == '-' {
				return time.Parse(timestamptzFormat2, s)
			}
			if c := s[l-3]; c == '+' || c == '-' {
				return time.Parse(timestamptzFormat3, s)
			}
			if c := s[l-9]; c == '+' || c == '-' {
				return time.Parse(timestamptzFormat1, s)
			}
			return time.ParseInLocation(timestampFormat, s, time.UTC)
		case 'T':
			return time.Parse(time.RFC3339Nano, s)
		}
	}

	if l >= len("15:04:05-07") {
		if c := s[l-6]; c == '+' || c == '-' {
			return time.Parse(timetzFormat2, s)
		}
		if c := s[l-3]; c == '+' || c == '-' {
			return time.Parse(timetzFormat3, s)
		}
		if c := s[l-9]; c == '+' || c == '-' {
			return time.Parse(timetzFormat1, s)
		}
	}

	if l < len("15:04:05") {
		return time.Time{}, fmt.Errorf("bun: can't parse time=%q", s)
	}

	if s[2] == ':' {
		return time.ParseInLocation(timeFormat, s, time.UTC)
	}
	return time.ParseInLocation(dateFormat, s, time.UTC)
}
