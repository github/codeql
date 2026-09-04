package main

func multipleReturns(selector int) int {
	if selector == 0 {
		return 0 // $ Alert[result-node]
	}
	switch selector {
	case 1:
		return 1 // $ Alert[result-node]
	case 2:
		return 2 // $ Alert[result-node]
	}
	return 3 // $ Alert[result-node]
}

func resultParameter1() (r int) { // $ Alert[result-node] // implicit reads of result parameters are located at the result parameter declaration
	r = 0
	return
}

func resultParameter2(selector int) (r int) { // $ Alert[result-node] // implicit reads of result parameters are located at the result parameter declaration
	r = 0
	if selector == 1 {
		return 1
	}
	return
}
