package main

import "maps"

func TaintStepTest_MapsCloneKey(fromString string) string {
	toMap := maps.Clone(map[string]int{fromString: 0})
	for key := range toMap {
		return key
	}
	return ""
}

func TaintStepTest_MapsCloneValue(fromString string) string {
	toMap := maps.Clone(map[string]string{"key": fromString})
	return toMap["key"]
}

func TaintStepTest_MapsCopyKey(fromString string) string {
	toMap := map[string]int{}
	maps.Copy(toMap, map[string]int{fromString: 0})
	for key := range toMap {
		return key
	}
	return ""
}

func TaintStepTest_MapsCopyValue(fromString string) string {
	toMap := map[string]string{}
	maps.Copy(toMap, map[string]string{"key": fromString})
	return toMap["key"]
}

func RunAllTaints_Maps() {
	{
		source := newSource(0).(string)
		out := TaintStepTest_MapsCloneKey(source)
		sink(0, out)
	}
	{
		source := newSource(1).(string)
		out := TaintStepTest_MapsCloneValue(source)
		sink(1, out)
	}
	{
		source := newSource(2).(string)
		out := TaintStepTest_MapsCopyKey(source)
		sink(2, out)
	}
	{
		source := newSource(3).(string)
		out := TaintStepTest_MapsCopyValue(source)
		sink(3, out)
	}
}
