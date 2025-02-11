(x + x) / 2; // $ TODO-SPURIOUS: Alert
e[i] - e[i]; // $ TODO-SPURIOUS: Alert
(x + y)/(x + y); // $ TODO-SPURIOUS: Alert
window.height - window.height; // $ TODO-SPURIOUS: Alert
x == 23 || x == 23; // $ TODO-SPURIOUS: Alert
x & x;

// this may actually be OK, but it's not good style
pop() && pop(); // $ TODO-SPURIOUS: Alert

foo[bar++] && foo[bar++]