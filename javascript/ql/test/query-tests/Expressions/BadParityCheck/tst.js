x % 2 === 1;
x % 2 !== 1;
x % 2 == 1;
x % 2 != 1;
x % 2 >= 1;
x % 2 <= 1;
x % 2 > 1;
x % 2 < 1;

x % 2 === -1;
x % 2 !== -1;
x % 2 == -1;
x % 2 != -1;
x % 2 >= -1;
x % 2 <= -1;
x % 2 > -1;
x % 2 < -1;

x % 2 === 0;
x % 2 !== 0;
x % 2 == 0;
x % 2 != 0;
x % 2 >= 0;
x % 2 <= 0;
x % 2 > 0;
x % 2 < 0;

x % 3 === 1;
x % (2) === ((1));
2 % x == 1;
1 === x % 2;

x = Math.random() > 0.5 ? -1 : 1;

// OK
function printOdd(n) {
	for (var i=0; i<n; ++i)
		if (i % 2 == 1)
			console.log(i);
}

// NOT OK
y % 2 === 1;

// NOT OK
function isEven(i) {
	return i % 2 > 0;
}