package main

import kotlin.collections.MutableList

fun test(
  a: Int,
  b: String,
  c: MutableList<String>,
  d: MutableList<out String>,
  e: DefinedHere<String>,
  f: DefinedOtherFile<String>
) { }

class DefinedHere<T> { }