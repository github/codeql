# Based on https://github.com/psf/black/blob/d8fa8df0526de9c0968e0a3568008f58eae45364/tests/data/pep_572.py

# See license at end of file.

(a := 1)
(a := a)
if (match := pattern.search(data)) is None:
    pass
[y := f(x), y ** 2, y ** 3]
filtered_data = [y for x in data if (y := f(x)) is None]
(y := f(x))
y0 = (y1 := f(x))
foo(x=(y := f(x)))


def foo(answer=(p := 42)):
    pass


def foo(answer: (p := 42) = 5):
    pass


lambda: (x := 1)
(x := lambda: 1)
(x := lambda: (y := 1))
lambda line: (m := re.match(pattern, line)) and m.group(1)
x = (y := 0)
(z := (y := (x := 0)))
(info := (name, phone, *rest))
(x := 1, 2)
(total := total + tax)
len(lines := f.readlines())
foo(x := 3, cat="vector")
foo(cat=(category := "vector"))
if any(len(longline := l) >= 100 for l in lines):
    print(longline)
if env_base := os.environ.get("PYTHONUSERBASE", None):
    return env_base
if self._is_special and (ans := self._check_nans(context=context)):
    return ans
foo(b := 2, a=1)
foo((b := 2), a=1)
foo(c=(b := 2), a=1)

while x := f(x):
    pass

# The MIT License (MIT)
#
# Copyright (c) 2018 Łukasz Langa
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
