#!/bin/bash

# Given a trap file, extract the CFG and format it as a DOT digraph

echo "digraph {"

# Iterate over all tuples in the trap file.
#
# For tuples of the form `<tablename>(#id, ..., "text")`, record
# "text (#id)" as a human-readable label for #id. As a special case,
# for tuples of the form `guard_node(#id1, <outcome>, #id2)` we
# record "#id2 is <outcome> (#id1)" as a human-readable label for #id1.
#
# For tuples of the form `successor(#id1, #id2)`, we output an
# edge from a node labelled with the human-readable label for #id1
# to a node labelled with the human-readable label for #id2. If no
# labels have been recorded for either #id1 or #id2, the numeric
# ids are used instead.

perl -lne 'print "  " . ($labels[$1] || $1) . " -> " . ($labels[$2] || $2) . ";" if /successor\(#(\d+),#(\d+)\)/; $labels[$1] = "$2 (#$1)\"" if /^\w+\(#(\d+),.*,(".*)"\)$/; $labels[$1] = "\"#$3 is $2 (#$1)\"" if /^guard_node\(#(\d+),(\w+),#(\d+)\)$/;' $1 | sed 's/\\/\\\\/g'

echo "}"
