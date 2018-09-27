if (0 || condition) { //wrong: can be converted to just 'condition'
	//...
}

if (0 && condition) { //wrong: always evaluates to false, if statement can be removed
	// ...
}

if ('A' == 65 && condition) { // wrong: can be converted to just 'condition'
	// ...
}
