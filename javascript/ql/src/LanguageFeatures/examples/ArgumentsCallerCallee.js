(function (i) {
	if (i <= 1)
		return 1;
	return i*arguments.callee(i-1);
}(3));
