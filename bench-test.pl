#!/bin/perl
# Need to create netlist because lines are not in order of nodes being defined

use strict;
use Data::Dumper;

my @inputs;
my @outputs;
my %variables = (
    'n1' => 1,
    'n2' => 0,
    'n3' => 1,
    'n4' => 1,
);
my %functions = (
    'AND' => \&and,
    'OR' => \&or,
    'NAND' => \&nand,
    'NOR' => \&nor,
);

# May want to go through first, find inputs/outputs, then go through and create 
# netlist. Need to find way to sort based on when node defined, not node name which 
# may not be in correct order.
while (<>) {
    chomp($_);
    if (/INPUT\(([a-zA-Z0-9]+)\)/m) {
        push(@inputs, $1);
    } elsif (/OUTPUT\(([a-zA-Z0-9]+)\)/m) {
        push(@outputs, $1);
    } elsif (/([a-zA-Z0-9]+) = (AND|OR|NAND|NOR|DFF)\(([a-zA-Z0-9_, ]+)\)/m) {
        my $output = $1;
        my $func = $2;
        if ($func == "DFF") { # skip DFF for now because idk how it's implemented
            next;
        }
        my @args = split(/, /, $3);
        my $solution = $functions{$func}->(@args);
        print "Found operation: $output - $func - @args ... Sol: $solution\n";
    }
}

sub not {
    my $output = (0+@_[0]) ^ 0x01;
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

# Testing
print "@inputs\n";
print "@outputs\n";
my $anded = &and(qw(n1 n2 n3 n4));
my $ored = &or(qw(n1 n2 n3 n4));
my $nored = &nor(qw(n1 n2 n3 n4));
my $nanded = &nand(qw(n1 n2 n3 n4));
# print Dumper(\%variables);
# print "AND: $anded\n";
# print "OR: $ored\n";
# print "NAND: $nanded\n";
# print "NOR: $nored\n";
