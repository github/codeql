(function(){
	var o = f1();
	while (f2()) {
		if (f4()) {
			o.p = 42;
			break;
		}
		f5();
	}
	o.p = 42;
});

(function(){
	var o = f1();
	o.p1 = o.p1 += 42;
	o.p2 -= (o.p2 *= 42);
});

(function(){
	var o = f1();
	o.m(function () {
		if (f2()) {

		} else {
			try {
				f3();
			} catch (e) {
				f4();
				o.p = 42;
			}
		}
		o.p = 42;
	});
});

(function(){
	var o = f1();
	o.p = f2() ? o.p = f3() : f4();
});
