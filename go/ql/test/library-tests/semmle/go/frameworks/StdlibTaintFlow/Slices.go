package main

import (
	"cmp"
	"slices"
	"strings"
)

func TaintStepTest_SlicesClip(fromStringSlice []string) []string {
	toStringSlice := slices.Clip(fromStringSlice)
	return toStringSlice
}

func TaintStepTest_SlicesClone(fromStringSlice []string) []string {
	toStringSlice := slices.Clone(fromStringSlice)
	return toStringSlice
}

func TaintStepTest_SlicesCompact(fromStringSlice []string) []string {
	toStringSlice := slices.Compact(fromStringSlice)
	return toStringSlice
}

func TaintStepTest_SlicesCompactFunc(fromStringSlice []string) []string {
	toStringSlice := slices.CompactFunc(fromStringSlice, strings.EqualFold)
	return toStringSlice
}

func TaintStepTest_SlicesConcat0(fromStringSlice []string) []string {
	toStringSlice := slices.Concat(fromStringSlice, []string{"a", "b", "c"})
	return toStringSlice
}

func TaintStepTest_SlicesConcat1(fromStringSlice []string) []string {
	toStringSlice := slices.Concat([]string{"a", "b", "c"}, fromStringSlice)
	return toStringSlice
}

func TaintStepTest_SlicesDelete(fromStringSlice []string) []string {
	toStringSlice := slices.Delete(fromStringSlice, 0, 1)
	return toStringSlice
}

func TaintStepTest_SlicesDeleteFunc(fromStringSlice []string) []string {
	deleteEmptyString := func(str string) bool {
		return str == ""
	}
	toStringSlice := slices.DeleteFunc(fromStringSlice, deleteEmptyString)
	return toStringSlice
}

func TaintStepTest_SlicesGrow(fromStringSlice []string) []string {
	toStringSlice := slices.Grow(fromStringSlice, 1)
	return toStringSlice
}

func TaintStepTest_SlicesInsert0(fromStringSlice []string) []string {
	toStringSlice := slices.Insert(fromStringSlice, 1, "a", "b")
	return toStringSlice
}

func TaintStepTest_SlicesInsert2(fromString string) []string {
	toStringSlice := slices.Insert([]string{}, 0, fromString, "b")
	return toStringSlice
}

func TaintStepTest_SlicesMax(fromStringSlice []string) string {
	toString := slices.Max(fromStringSlice)
	return toString
}

func TaintStepTest_SlicesMaxFunc(fromStringSlice []string) string {
	toString := slices.MaxFunc(fromStringSlice, cmp.Compare)
	return toString
}

func TaintStepTest_SlicesMin(fromStringSlice []string) string {
	toString := slices.Min(fromStringSlice)
	return toString
}

func TaintStepTest_SlicesMinFunc(fromStringSlice []string) string {
	toString := slices.MinFunc(fromStringSlice, cmp.Compare)
	return toString
}

func TaintStepTest_SlicesRepeat(fromStringSlice []string) []string {
	toStringSlice := slices.Repeat(fromStringSlice, 2)
	return toStringSlice
}

func TaintStepTest_SlicesReplace0(fromStringSlice []string) []string {
	toStringSlice := slices.Replace(fromStringSlice, 1, 2, "a")
	return toStringSlice
}

func TaintStepTest_SlicesReplace3(fromString string) []string {
	toStringSlice := slices.Replace([]string{}, 1, 3, fromString, "b")
	return toStringSlice
}

func RunAllTaints_Slices() {
	{
		source := []string{newSource(0).(string)}
		out := TaintStepTest_SlicesClip(source)
		sink(0, out[0])
	}
	{
		source := []string{newSource(1).(string)}
		out := TaintStepTest_SlicesClone(source)
		sink(1, out[0])
	}
	{
		source := []string{newSource(2).(string)}
		out := TaintStepTest_SlicesCompact(source)
		sink(2, out[0])
	}
	{
		source := []string{newSource(3).(string)}
		out := TaintStepTest_SlicesCompactFunc(source)
		sink(3, out[0])
	}
	{
		source := []string{newSource(4).(string)}
		out := TaintStepTest_SlicesConcat0(source)
		sink(4, out[0])
	}
	{
		source := []string{newSource(5).(string)}
		out := TaintStepTest_SlicesConcat1(source)
		sink(5, out[0])
	}
	{
		source := []string{newSource(6).(string)}
		out := TaintStepTest_SlicesDelete(source)
		sink(6, out[0])
	}
	{
		source := []string{newSource(7).(string)}
		out := TaintStepTest_SlicesDeleteFunc(source)
		sink(7, out[0])
	}
	{
		source := []string{newSource(8).(string)}
		out := TaintStepTest_SlicesGrow(source)
		sink(8, out[0])
	}
	{
		source := []string{newSource(9).(string)}
		out := TaintStepTest_SlicesInsert0(source)
		sink(9, out[0])
	}
	{
		source := newSource(10).(string)
		out := TaintStepTest_SlicesInsert2(source)
		sink(10, out[0])
	}
	{
		source := []string{newSource(11).(string)}
		out := TaintStepTest_SlicesMax(source)
		sink(11, out)
	}
	{
		source := []string{newSource(12).(string)}
		out := TaintStepTest_SlicesMaxFunc(source)
		sink(12, out)
	}
	{
		source := []string{newSource(13).(string)}
		out := TaintStepTest_SlicesMin(source)
		sink(13, out)
	}
	{
		source := []string{newSource(14).(string)}
		out := TaintStepTest_SlicesMinFunc(source)
		sink(14, out)
	}
	{
		source := []string{newSource(15).(string)}
		out := TaintStepTest_SlicesRepeat(source)
		sink(15, out[0])
	}
	{
		source := []string{newSource(16).(string)}
		out := TaintStepTest_SlicesReplace0(source)
		sink(16, out[0])
	}
	{
		source := newSource(17).(string)
		out := TaintStepTest_SlicesReplace3(source)
		sink(17, out[0])
	}
}
