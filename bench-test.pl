#!/bin/perl

use strict;

my @inputs;
my @outputs;
my %variables = (
    'n1' => 1,
    'n2' => 0,
    'n3' => 1,
    'n4' => 1,
);

while (<>) {
    chomp($_);
    # print $line, "\n";
    if (/INPUT\(([a-zA-Z0-9]+)\)/m) {
        push(@inputs, $1);
    } elsif (/OUTPUT\(([a-zA-Z0-9]+)\)/) {
        push(@outputs, $1);
    }
}

sub not {
    my $output = $_ ^ 0x01;
    return $output;
}

sub or {
    my $output = 0;
    foreach my $key (@_) {
        $output |= $variables{$key};
    }
    return $output;
}

sub and {
    my $output = 1;
    foreach my $key (@_) {
        $output &= $variables{$key};
    }
    return $output;
}

sub nor {
    my $ored = &or(@_);
    my $output = &not($ored);
    return $output;
}

sub nand {
    my $anded = &and(@_);
    my $output = &not($anded);
    return $output;
}

print "@inputs\n";
print "@outputs\n";
my $anded = &and(qw(n1 n2 n3 n4));
print "$anded\n";
