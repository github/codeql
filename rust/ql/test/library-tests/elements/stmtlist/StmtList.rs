
// --- tests ---

fn test1() -> i32 {
	// two statements + tail expression
	let a = 1;
	let b = 2;
	a + b
}

fn test2() -> () {
	// two statements only
	let a = 1;
	let b = 2;
}

fn test3() -> i32 {
	// tail expression only
	1 + 2
}

fn test4() -> () {
	// one statement only
	1 + 2;
}

fn test5() -> () {
	// neither
}

fn test6() -> () {
	// neither
	;
}

fn test7(cond: bool) -> i32 {
	// nested blocks
	if cond {
		1
	} else {
		2
	}
}
