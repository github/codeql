package main

func gotoStackedLabelTarget(flag bool) {
outer:
inner:
	{
		if flag {
			goto back // $ gotoTarget=back
		}
		goto done // $ gotoTarget=done

	back:
		goto inner // $ MISSING: gotoTarget=inner
	done:
		flag = false
	}
	goto outer // $ gotoTarget=outer
}

func gotoDirectStackedLabelTarget() {
	goto outer // $ gotoTarget=outer
outer:
inner:
	goto inner // $ gotoTarget=inner
}
