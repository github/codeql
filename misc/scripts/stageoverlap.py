#!/usr/bin/env python3

import sys
import os
import re

# read first argument
if len(sys.argv) < 2:
    print("Usage: stagestats.py <dil>")
    sys.exit(1)

dilfile = sys.argv[1]

seen_stages = set()
computed_predicates = {}
stage_number = 0

def process_stage(stage, cached):
    global stage_number
    stage_key = ' '.join(cached)
    # skip repeated stages (in case we're looking at DIL for several queries, e.g. from a .qls)
    if stage_key in seen_stages:
        return
    # don't count the query-stage as seen, since we don't want to skip those
    if not '#select' in cached:
        seen_stages.add(stage_key)
    stage_number += 1
    print('STAGE ' + str(stage_number) + ':')
    print(str(len(cached)) + ' cached predicate(s)')
    print(' '.join(cached))
    for predicate in stage:
        # strip trailing characters matching the regex '#[bf]+', i.e. disregard magic
        predicate = re.sub('#[bf]+$', '', predicate)
        # TODO: maybe also strip the hash?
        # predicate = re.sub('#[a-f0-9]+$', '', predicate)
        if predicate in computed_predicates.keys():
            # skip db-relations and some generated predicates
            if predicate.startswith('@') or predicate.startswith('project#'):
                continue
            prior_stage = computed_predicates[predicate]
            print('Recompute from ' + str(prior_stage) + ': ' + predicate)
        else:
            computed_predicates[predicate] = stage_number
    print()

with open(dilfile, 'r') as f:
    stage = []
    cached = []
    query = False
    for line in f:
        # skip lines starting with a space, i.e. predicate bodies
        if line.startswith(' '): continue
        # get the part of the line containing no spaces occuring before the first '('
        # this is the predicate name
        parenpos = line.find('(')
        if parenpos != -1:
            start = line.rfind(' ', 0, parenpos)
            predicate = line[start+1:parenpos]
            if predicate.startswith('`'):
                # remove the leading and trailing backticks
                predicate = predicate[1:-1]
            stage.append(predicate)
            continue
        # query predicates, aka cached predicates, are written either as
        # 'query <predicatename> = ...' on one line, or split across 2+ lines
        if line.startswith('query '):
            predicate = line.split(' ')[1]
            cached.append(predicate)
            continue
        if line == 'query\n':
            query = True
            continue
        if query:
            predicate = line.split(' ')[0]
            cached.append(predicate)
            query = False
            continue
        if line == '/* ---------- END STAGE ---------- */\n':
            process_stage(stage, cached)
            stage = []
            cached = []
