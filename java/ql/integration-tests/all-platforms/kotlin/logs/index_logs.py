#!/usr/bin/python

import csv
import json
import re
import sys
from create_database_utils import *

# Make a source file to keep codeql happy
src_dir = os.environ['CODEQL_EXTRACTOR_JAVA_SOURCE_ARCHIVE_DIR']
src_file = src_dir + '/Source.java'
os.makedirs(src_dir)
with open(src_file, 'w') as f:
    pass

line_index = 0
file_index = 0
with open('logs.csv', 'w', newline='') as f_out:
    csv_writer = csv.writer(f_out)
    def write_line(origin, kind, msg):
        global file_index, line_index
        csv_writer.writerow([str(file_index), str(line_index), origin, kind, msg])
        line_index += 1
    log_dir = 'kt-db/log'
    for file_name in os.listdir(log_dir):
        if file_name.startswith('kotlin-extractor'):
            file_index += 1
            line_index = 1
            write_line('Test script', 'Log file', str(file_index))
            with open(log_dir + '/' + file_name) as f_in:
                for line in f_in:
                    j = json.loads(line)
                    msg = j['message']
                    msg = re.sub(r'(?<=Extraction for invocation TRAP file ).*[\\/]kt-db[\\/]trap[\\/]java[\\/]invocations[\\/]kotlin\..*\.trap', '<FILENAME>', msg)
                    msg = re.sub('(?<=Kotlin version )[0-9.]+(-[a-zA-Z0-9.]+)?', '<VERSION>', msg)
                    if msg.startswith('Peak memory: '):
                        # Peak memory information varies from run to run, so just ignore it
                        continue
                    write_line(j['origin'], j['kind'], msg)

runSuccessfully(["codeql", "database", "index-files", "--language=csv", "--include=logs.csv", "test-db"])

