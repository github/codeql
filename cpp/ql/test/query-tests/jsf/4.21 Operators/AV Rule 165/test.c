
typedef unsigned int TUI;

void f(int i, unsigned int ui, signed int si, TUI tui, volatile unsigned int vui, unsigned u, unsigned short us) {
	i = -i;
	i = -ui; // BAD
	i = -si;
	ui = -i;
	ui = -ui; // BAD
	ui = -si;
	si = -i;
	si = -ui; // BAD
	si = -si;

	i = -(int)i;
	i = -(unsigned int)i; // BAD
	i = -(signed int)i;
	ui = -(int)ui;
	ui = -(unsigned int)ui; // BAD
	ui = -(signed int)ui;

	tui = -tui; // BAD
	vui = -vui; // BAD
	u = -u; // BAD
	us = -us; // BAD
	ui = -(5U); // BAD [NOT DETECTED]
}
