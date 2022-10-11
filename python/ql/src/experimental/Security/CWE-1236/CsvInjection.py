#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：csv injection
"""
import copy
import csv
from flask import Flask
from flask import request
from typing import List

app = Flask(__name__)

@app.route('/bad1')
def bad1():
    csv_data = request.args.get('csv')
    csvWriter = csv.writer(open("test.csv", "wt"))
    csvWriter.writerow(csv_data)
    return "bad1"

@app.route('/good1')
def good1():
    csv_data = request.args.get('csv')
    csvWriter = csv.writer(open("test.csv", "wt"))
    csvWriter.writerow(santize_for_csv(csv_data))
    return "good1"

def santize_for_csv(data: str| List[str] | List[List[str]]):
    def sanitize(item):
        return "'" + item

    unsafe_prefixes = ("+", "=", "-", "@")
    if isinstance(data, str):
        if data.startswith(unsafe_prefixes):
            return sanitize(data)
        return data
    elif isinstance(data, list) and isinstance(data[0], str):
        sanitized_data = copy.deepcopy(data)
        for index, item in enumerate(data):
            if item.startswith(unsafe_prefixes):
                sanitized_data[index] = sanitize(item)
        return sanitized_data
    elif isinstance(data[0], list) and isinstance(data[0][0], str):
        sanitized_data = copy.deepcopy(data)
        for outer_index, sublist in enumerate(data):
            for inner_index, item in enumerate(sublist):
                if item.startswith(unsafe_prefixes):
                    sanitized_data[outer_index][inner_index] = sanitize(item)
        return sanitized_data
    else:
        raise ValueError("Unsupported data type: " + str(type(data)))


if __name__ == '__main__':
    app.debug = True
    app.run()