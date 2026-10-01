package main

import (
	"maps"
)

func TaintStepTest_MapsCloneValue(fromString string) string {
	m := map[string]string{"key": fromString}
	clone := maps.Clone(m)
	return clone["key"]
}

func TaintStepTest_MapsCloneKey(fromString string) string {
	m := map[string]string{fromString: "value"}
	clone := maps.Clone(m)
	for k := range clone {
		return k
	}
	return ""
}

func TaintStepTest_MapsCopyValue(fromString string) string {
	src := map[string]string{"key": fromString}
	dst := map[string]string{}
	maps.Copy(dst, src)
	return dst["key"]
}

func TaintStepTest_MapsCopyKey(fromString string) string {
	src := map[string]string{fromString: "value"}
	dst := map[string]string{}
	maps.Copy(dst, src)
	for k := range dst {
		return k
	}
	return ""
}

func RunAllTaints_Maps() {
	{
		source := newSource(0).(string)
		out := TaintStepTest_MapsCloneValue(source)
		sink(0, out)
	}
	{
		source := newSource(1).(string)
		out := TaintStepTest_MapsCloneKey(source)
		sink(1, out)
	}
	{
		source := newSource(2).(string)
		out := TaintStepTest_MapsCopyValue(source)
		sink(2, out)
	}
	{
		source := newSource(3).(string)
		out := TaintStepTest_MapsCopyKey(source)
		sink(3, out)
	}
}
