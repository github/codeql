#!/usr/bin/env swift
/** Documentation with /* a nested comment */ inside. */
let 😀 = 0x1.fp+2
let exponent = 0x1p-1
let decimal = 1.5e+2
let digits = (0b10_10, 0o7_7, 0xff_ff)
let escaped = "a\tb\"c\\d\u{1F600}"
let raw = ##"hello \##(😀)"##
let loop = { for item in values { print(item) } }
