package main

import (
	"fmt"
	"math"
	"strconv"
)

func main() {

}

type something struct {
}
type config struct {
}
type registry struct {
}

func lookupTarget(conf *config, num int32) (int32, error) {
	return 567, nil
}
func lookupNumberByName(reg *registry, name string) (int32, error) {
	return 567, nil
}
func lab(s string) (*something, error) {
	num, err := strconv.Atoi(s) // $ Source

	if err != nil {
		number, err := lookupNumberByName(&registry{}, s)
		if err != nil {
			return nil, err
		}
		num = int(number)
	}
	target, err := lookupTarget(&config{}, int32(num)) // $ Alert
	if err != nil {
		return nil, err
	}

	// convert the resolved target number back to a string

	s = strconv.Itoa(int(target))

	return nil, nil
}

func testParseInt() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 8)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)
		_ = uint8(parsed)
		_ = int16(parsed)
		_ = uint16(parsed)
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 16) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)  // $ Alert
		_ = uint8(parsed) // $ Alert
		_ = int16(parsed)
		_ = uint16(parsed)
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 32) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ Alert
		_ = uint8(parsed)  // $ Alert
		_ = int16(parsed)  // $ Alert
		_ = uint16(parsed) // $ Alert
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 64) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ Alert
		_ = uint8(parsed)  // $ Alert
		_ = int16(parsed)  // $ Alert
		_ = uint16(parsed) // $ Alert
		_ = int32(parsed)  // $ Alert
		_ = uint32(parsed) // $ Alert
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)  // $ Alert
		_ = uint(parsed) // $ Alert
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 0) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ Alert
		_ = uint8(parsed)  // $ Alert
		_ = int16(parsed)  // $ Alert
		_ = uint16(parsed) // $ Alert
		_ = int32(parsed)  // $ Alert
		_ = uint32(parsed) // $ Alert
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
}

func testParseUint() {
	{
		parsed, err := strconv.ParseUint("3456", 10, 8) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed) // $ Alert
		_ = uint8(parsed)
		_ = int16(parsed)
		_ = uint16(parsed)
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 16) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)  // $ Alert
		_ = uint8(parsed) // $ Alert
		_ = int16(parsed) // $ Alert
		_ = uint16(parsed)
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 32) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ Alert
		_ = uint8(parsed)  // $ Alert
		_ = int16(parsed)  // $ Alert
		_ = uint16(parsed) // $ Alert
		_ = int32(parsed)  // $ Alert
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed) // $ Alert
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 64) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ Alert
		_ = uint8(parsed)  // $ Alert
		_ = int16(parsed)  // $ Alert
		_ = uint16(parsed) // $ Alert
		_ = int32(parsed)  // $ Alert
		_ = uint32(parsed) // $ Alert
		_ = int64(parsed)  // $ Alert
		_ = uint64(parsed)
		_ = int(parsed)  // $ Alert
		_ = uint(parsed) // $ Alert
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 0) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ Alert
		_ = uint8(parsed)  // $ Alert
		_ = int16(parsed)  // $ Alert
		_ = uint16(parsed) // $ Alert
		_ = int32(parsed)  // $ Alert
		_ = uint32(parsed) // $ Alert
		_ = int64(parsed)  // $ Alert
		_ = uint64(parsed)
		_ = int(parsed) // $ Alert
		_ = uint(parsed)
	}
}

func testAtoi() {
	parsed, err := strconv.Atoi("3456") // $ Source
	if err != nil {
		panic(err)
	}
	_ = int8(parsed)   // $ Alert
	_ = uint8(parsed)  // $ Alert
	_ = int16(parsed)  // $ Alert
	_ = uint16(parsed) // $ Alert
	_ = int32(parsed)  // $ Alert
	_ = uint32(parsed) // $ Alert
	_ = int64(parsed)
	_ = uint64(parsed)
	_ = int(parsed)
	_ = uint(parsed)
}

type customInt int16

// these should be caught:
func typeAliases(input string) {
	{
		parsed, err := strconv.ParseInt(input, 10, 32) // $ Source
		if err != nil {
			panic(err)
		}
		// NOTE: byte is uint8
		_ = byte(parsed)      // $ Alert
		_ = customInt(parsed) // $ Alert
	}
}

func testBoundsChecking(input string) {
	{
		parsed, err := strconv.Atoi(input) // $ Source
		if err != nil {
			panic(err)
		}
		if parsed <= math.MaxInt8 && parsed >= math.MinInt8 {
			_ = int8(parsed)
		}
		if parsed < math.MaxInt8 {
			_ = int8(parsed) // $ MISSING: Alert  // Not found because we only check for upper bounds
			if parsed >= 0 {
				_ = int16(parsed)
			}
		}
		if parsed >= math.MinInt8 {
			_ = int8(parsed) // $ Alert
			if parsed <= 0 {
				_ = int16(parsed)
			}
		}
		if parsed <= math.MaxUint16 {
			_ = uint16(parsed)
			_ = uint(parsed)
			_ = int32(parsed)
		}
	}
	{
		parsed, err := strconv.ParseUint(input, 10, 0) // $ Source
		if err != nil {
			panic(err)
		}
		if parsed <= math.MaxUint64 {
			_ = int8(parsed)   // $ Alert
			_ = uint8(parsed)  // $ Alert
			_ = int16(parsed)  // $ Alert
			_ = uint16(parsed) // $ Alert
			_ = int32(parsed)  // $ Alert
			_ = uint32(parsed) // $ Alert
			_ = int64(parsed)  // $ Alert
			_ = uint64(parsed)
			_ = int(parsed) // $ Alert
			_ = uint(parsed)
		}
		if parsed <= math.MaxInt64 {
			_ = int8(parsed)   // $ Alert
			_ = uint8(parsed)  // $ Alert
			_ = int16(parsed)  // $ Alert
			_ = uint16(parsed) // $ Alert
			_ = int32(parsed)  // $ Alert
			_ = uint32(parsed) // $ Alert
			_ = int64(parsed)
			_ = uint64(parsed)
			_ = int(parsed) // $ Alert
			_ = uint(parsed)
		}
		if parsed <= math.MaxUint32 {
			_ = int8(parsed)   // $ Alert
			_ = uint8(parsed)  // $ Alert
			_ = int16(parsed)  // $ Alert
			_ = uint16(parsed) // $ Alert
			_ = int32(parsed)  // $ Alert
			_ = uint32(parsed)
			_ = int64(parsed)
			_ = uint64(parsed)
			_ = int(parsed) // $ Alert
			_ = uint(parsed)
		}
		if parsed <= math.MaxInt32 {
			_ = int8(parsed)   // $ Alert
			_ = uint8(parsed)  // $ Alert
			_ = int16(parsed)  // $ Alert
			_ = uint16(parsed) // $ Alert
			_ = int32(parsed)
			_ = uint32(parsed)
			_ = int64(parsed)
			_ = uint64(parsed)
			_ = int(parsed)
			_ = uint(parsed)
		}
	}
	{
		parsed, err := strconv.ParseUint(input, 10, 32) // $ Source
		if err != nil {
			panic(err)
		}
		if parsed <= math.MaxUint16 {
			_ = uint16(parsed)
			_ = int16(parsed) // $ Alert
		}
		if parsed <= 255 {
			_ = uint8(parsed)
		}
		if parsed <= 256 {
			_ = uint8(parsed) // $ Alert
		}
		if err == nil && 1 == 1 && parsed < math.MaxInt8 {
			_ = int8(parsed)
		}
		if parsed > 42 {
			_ = uint16(parsed) // $ Alert
		}
		if parsed >= math.MaxUint8+1 {
			return
		}
		_ = uint8(parsed)
	}
}

func testBoundsChecking2(input string) error {
	version, err := strconv.ParseUint(input, 10, 0)
	if err != nil || version > math.MaxInt {
		return fmt.Errorf("checksum has invalid version: %w", err)
	}
	_ = int(version)
	return nil
}

func testRightShifted(input string) {
	{
		parsed, err := strconv.ParseInt(input, 10, 32)
		if err != nil {
			panic(err)
		}
		_ = byte(parsed)
		_ = byte(parsed >> 8)
		_ = byte(parsed >> 16)
		_ = byte(parsed >> 24)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 16)
		if err != nil {
			panic(err)
		}
		_ = byte(parsed)
		_ = byte(parsed & 0xff00 >> 8)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 32)
		if err != nil {
			panic(err)
		}
		_ = byte(parsed)
		_ = byte(parsed >> 8 & 0xff)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 16) // $ Source
		if err != nil {
			panic(err)
		}
		_ = byte(parsed) // $ Alert
		_ = byte(parsed << 8)
	}
}

func testPathWithMoreThanOneSink(input string) {
	{
		parsed, err := strconv.ParseInt(input, 10, 32) // $ Source
		if err != nil {
			panic(err)
		}
		v1 := int16(parsed) // $ Alert
		_ = int16(v1)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 32) // $ Source
		if err != nil {
			panic(err)
		}
		v := int16(parsed) // $ Alert
		_ = int8(v)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 32) // $ Source
		if err != nil {
			panic(err)
		}
		v1 := int32(parsed)
		v2 := int16(v1) // $ Alert
		_ = int8(v2)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 16) // $ Source
		if err != nil {
			panic(err)
		}
		v1 := int64(parsed)
		v2 := int32(v1)
		v3 := int16(v2)
		_ = int8(v3) // $ Alert
	}
}

func testUsingStrConvIntSize(input string) {
	parsed, err := strconv.ParseInt(input, 10, strconv.IntSize) // $ Source
	if err != nil {
		panic(err)
	}
	_ = int8(parsed)   // $ Alert
	_ = uint8(parsed)  // $ Alert
	_ = int16(parsed)  // $ Alert
	_ = uint16(parsed) // $ Alert
	_ = int32(parsed)  // $ Alert
	_ = uint32(parsed) // $ Alert
	_ = int64(parsed)
	_ = uint64(parsed)
	_ = int(parsed)
	_ = uint(parsed)
}

// parsePositiveInt parses value as an int. It returns an error if value cannot
// be parsed or is negative.
func parsePositiveInt1(value string) (int, error) {
	switch i64, err := strconv.ParseInt(value, 10, 64); {
	case err != nil:
		return 0, fmt.Errorf("unable to parse positive integer %q: %v", value, err)
	case i64 < 0:
		return 0, fmt.Errorf("unable to parse positive integer %q: negative value", value)
	case i64 > math.MaxInt:
		return 0, fmt.Errorf("unable to parse positive integer %q: overflow", value)
	default:
		return int(i64), nil
	}
}

func parsePositiveInt2(value string) (int, error) {
	i64, err := strconv.ParseInt(value, 10, 64)
	if err != nil {
		return 0, fmt.Errorf("unable to parse positive integer %q: %w", value, err)
	}
	if i64 < 0 {
		return 0, fmt.Errorf("unable to parse positive integer %q: negative value", value)
	}
	if i64 > math.MaxInt {
		return 0, fmt.Errorf("unable to parse positive integer %q: overflow", value)
	}
	return int(i64), nil
}

func dealWithArchSizeCorrectly(s string) uint {
	if i, err := strconv.ParseUint(s, 10, 64); err == nil && i < math.MaxUint {
		return uint(i)
	}
	return 0
}

func typeSwitch1(s string) {
	i64, _ := strconv.ParseInt(s, 10, 64) // $ Source
	var input any = i64
	switch v := input.(type) {
	case int16, string:
		if _, ok := input.(string); ok {
			return
		}
		_ = int16(v.(int16))
		_ = int8(v.(int16)) // $ Alert
	case int32:
		_ = int32(v)
		_ = int8(v) // $ Alert
	case int64:
		_ = int8(v) // $ Alert
	default:
		_ = int8(v.(int64)) // $ Alert
	}
}

func typeSwitch2(s string) {
	i64, _ := strconv.ParseInt(s, 10, 64) // $ Source
	var input any = i64
	switch input.(type) {
	case int16, string:
		if _, ok := input.(string); ok {
			return
		}
		_ = int16(input.(int16))
		_ = int8(input.(int16)) // $ Alert
	case int32:
		_ = int32(input.(int32))
		_ = int8(input.(int32)) // $ Alert
	case int64:
		_ = int8(input.(int64)) // $ Alert
	default:
		_ = int8(input.(int64)) // $ Alert
	}
}

func checkedTypeAssertion(s string) {
	i64, _ := strconv.ParseInt(s, 10, 64) // $ Source
	var input any = i64
	if v, ok := input.(int16); ok {
		// Need to account for the fact that within this case clause, v is an int16
		_ = int16(v)
		_ = int8(v) // $ Alert
	} else if v, ok := input.(int32); ok {
		_ = int16(v) // $ Alert
	}
}
