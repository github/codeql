#!/usr/bin/perl -w

# This currently won't parse the test output, as showIds isn't enabled.

use strict;

my %info;

sub add_info {
    my $id = shift;
    my $str = shift;

    if (defined($info{$id})) {
        if ($info{$id} ne $str) {
            die "Mismatch";
        }
    } else {
        $info{$id} = $str;
    }
}

open OUT, "> cfg.dot" or die "open failed: $!";

print OUT "digraph G {\n";

open IN, "< cfg.expected" or die "open failed: $!";
while (<IN>) {
    if (/^\| [0-9]+ \| [0-9]+ \| ([0-9]+) \| ([^|]+) \| ([0-9]+) \| ([^|]+) \|$/) {
        my $srcid = $1;
        my $srcstr = $2;
        my $dstid = $3;
        my $dststr = $4;
        &add_info($srcid, $srcstr);
        &add_info($dstid, $dststr);
        print OUT "n$srcid -> n$dstid;\n";
    } elsif (/^$/) {
        # Nothing
    } else {
        die "Bad line: $_";
    }
}
close IN;

for my $id (keys %info) {
    my $str = $info{$id};
    print OUT qq(n$id [label="$str"];\n);
}

print OUT "}\n";
close OUT;

system ("dot", "-Tpng", "cfg.dot", "-o", "cfg.png") == 0
    or die "dot failed: $?";

