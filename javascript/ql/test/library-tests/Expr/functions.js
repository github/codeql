function f() {
	in_f;
	while (also_in_f)
		(function() {
			not_in_f;
		})({
			x: in_f_again
		});
}
global;