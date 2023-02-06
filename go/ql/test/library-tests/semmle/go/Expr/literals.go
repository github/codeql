package main

import "fmt"

// autoformat-ignore (we intentionally test unconventional capitalisation of literals like 1E1i)

var intlits = map[string]int{
	"decimal":     42,
	"octal":       0600,
	"hexadecimal": 0xcaffee,
}

var floatlits = []float64{
	0.,
	72.40,
	072.40,
	2.71828,
	1.e+0,
	6.67428e-11,
	1E6,
	.25,
	.12345E+5,
}

var imaglits = []complex64{
	0i,
	011i,
	0.i,
	2.71828i,
	1.e+0i,
	6.67428e-11i,
	1E6i,
	.25i,
	.12345E+5i,
}

var runelits = []int{
	'a',
	'ä',
	'本',
	'\t',
	'\007',
	'\377',
	'\x07',
	'\xff',
	'\u12e4',
	'\U00101234',
	'\'',
}

var strlits = []string{
	`abc`,
	`\n,
\n`,
	"\n",
	"\"",
	"Hello, world!\n",
	"日本語",
	"\u65e5本\U00008a9e",
	"\xff\u00FF",
}

func literals() {
	for _, str := range strlits {
		fmt.Println(str)
	}
}

var non_bmp_strlit = "📿" + ""
