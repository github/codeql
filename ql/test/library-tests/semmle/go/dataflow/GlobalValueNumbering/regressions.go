package main

import "unsafe"

const c = unsafe.Sizeof(test())

const d = false

const e = !d

const f = true
