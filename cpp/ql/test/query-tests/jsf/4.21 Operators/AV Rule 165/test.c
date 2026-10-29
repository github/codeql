
typedef unsigned int TUI;

void f(int i, unsigned int ui, signed int si, TUI tui, volatile unsigned int vui, unsigned u, unsigned short us) {
	i = -i;
	i = -ui; // $ Alert // BAD
	i = -si;
	ui = -i;
	ui = -ui; // $ Alert // BAD
	ui = -si;
	si = -i;
	si = -ui; // $ Alert // BAD
	si = -si;

	i = -(int)i;
	i = -(unsigned int)i; // $ Alert // BAD
	i = -(signed int)i;
	ui = -(int)ui;
	ui = -(unsigned int)ui; // $ Alert // BAD
	ui = -(signed int)ui;

	tui = -tui; // $ Alert // BAD
	vui = -vui; // $ Alert // BAD
	u = -u; // $ Alert // BAD
	us = -us; // $ Alert // BAD
	ui = -(5U); // $ MISSING: Alert // BAD [NOT DETECTED]
}
