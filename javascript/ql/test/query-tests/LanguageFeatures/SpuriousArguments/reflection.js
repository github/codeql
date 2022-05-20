function f0() {return;}
function f1(x) {return;}

f0.call();
f0.call(this);
f0.call(this, 1);
f0.call(this, 1, 2);

f1.call();
f1.call(this);
f1.call(this, 1);
f1.call(this, 1, 2);

f0.apply();
f0.apply(this);
f0.apply(this, []);
f0.apply(this, [1]);
f0.apply(this, [1, 2]);

f1.apply();
f1.apply(this);
f1.apply(this, []);
f1.apply(this, [1]);
f1.apply(this, [1, 2]);
