#!/usr/bin/env python

import not_in_pacakge_lib_copy

def not_in_package_script_func(x, y):
    return x + y

if __name__ == "__main__":
    print(not_in_pacakge_lib_copy.not_in_pacakge_lib_func(1, 2))
    print(not_in_package_script_func(3, 4))
