#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long qw( auto_help );

my $usage = <<EOU;
Usage:
  $0 --db DSN
  $0 --action [hide|show]
EOU

my %opts;
GetOptions(\%opts, "db=s", "action=s") or die $usage;
