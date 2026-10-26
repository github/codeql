# Taken from https://github.com/psf/black/blob/2848e2e1d6527d6031ea020cd991fd73e52c4a0b/tests/data/pep_570.py

# See license at end of file.

def positional_only_arg(a, /):
    pass


def all_markers(a, b, /, c, d, *, e, f):
    pass


def all_markers_with_args_and_kwargs(
    a_long_one,
    b_long_one,
    /,
    c_long_one,
    d_long_one,
    *args,
    e_long_one,
    f_long_one,
    **kwargs,
):
    pass


def all_markers_with_defaults(a, b=1, /, c=2, d=3, *, e=4, f=5):
    pass


def long_one_with_long_parameter_names(
    but_all_of_them,
    are_positional_only,
    arguments_mmmmkay,
    so_this_is_only_valid_after,
    three_point_eight,
    /,
):
    pass


lambda a, /: a

lambda a, b, /, c, d, *, e, f: a

lambda a, b, /, c, d, *args, e, f, **kwargs: args

lambda a, b=1, /, c=2, d=3, *, e=4, f=5: 1

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
