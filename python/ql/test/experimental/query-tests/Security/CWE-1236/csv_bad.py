#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：csv injection
"""
import copy
import csv
from flask import Flask
from flask import request # $ Source
from typing import List

app = Flask(__name__)

@app.route('/bad1')
def bad1():
    csv_data = request.args.get('csv')
    csvWriter = csv.writer(open("test.csv", "wt"))
    csvWriter.writerow(csv_data)    # $ Alert # bad
    csvWriter.writerows(csv_data)    # $ Alert # bad
    return "bad1"

@app.route('/bad2')
def bad2():
    csv_data = request.args.get('csv')
    csvWriter = csv.DictWriter(f, fieldnames=csv_data)    # $ Alert # bad
    csvWriter.writeheader()
    return "bad2"

if __name__ == '__main__':
    app.debug = True
    app.run()
