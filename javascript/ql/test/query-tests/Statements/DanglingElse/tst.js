function bad1() {
	if (cond1())
		if (cond2())
			return 23;
	else
		return 42;
}

function good1() {
	if (cond1())
		if (cond2())
			return 23;
		else
			return 42;
}

function bad2() {
	if (cond1()) {
		if (cond2()) {
			return 23;
	} else {
		return 42;
	}}
}

function good2() {
	if (cond1())
	if (cond2())
		return 23;
	else
		return 42;
}

function bad3() {
	if (cond1())
		return 23;
	else if (cond2())
		if (cond2())
			return 42;
	else
		return 42;
}


function good3() {
	if (cond1())
			if (cond2())
		return 23;
		else
		return 42;
}

function good4() {
	if (cond1()) {
		if (cond2())
			return 23;
	} else
		return 42;
}

function good5() {
    if (cond1())
    (function inner() {
        if (cond2())
            return 23;
    else
        return 42;
    }());
}

function good6() {
  if (true) {
  } else if (true) {
    if (true) {
    } else if (true) {
    } else {
    }
  }
}
