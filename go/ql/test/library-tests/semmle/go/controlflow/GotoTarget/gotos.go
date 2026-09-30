package main

func gotoStackedSiblingTarget(flag bool) {
	if flag {
		goto inner // $ gotoTarget=inner
	}
outer:
inner:
	flag = false
	goto outer // $ gotoTarget=outer
}

func gotoNestedSiblingTarget(flag bool) {
	if flag {
		goto inner // $ gotoTarget=inner
	} else {
		goto outer // $ gotoTarget=outer
	}
outer:
inner:
	{
		flag = false
	}
}

func gotoSelfLoop(flag bool) {
self:
	if flag {
		goto self // $ gotoTarget=self
	}
}

func gotoDirectSelfLoop() {
self:
	goto self // $ gotoTarget=self
}

func gotoEnclosingStackedLabel(flag bool) {
outer:
inner:
	if flag {
		goto inner // $ gotoTarget=inner
	} else {
		goto outer // $ gotoTarget=outer
	}
}
