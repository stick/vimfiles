:silent! %s/\['filename'\]/\=expand('%:p:t')/g
#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Pod::Usage;
use Getopt::Long qw(:config auto_help auto_version );

$main::VERSION = "1.0";

=head1 NAME

['filename'] - a script

=head1 SYNOPSIS

  ['filename'] [options]

  Options:
    --help brief help message
    --man full documentation

=head1 OPTIONS

=over

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

=cut

my %opts;
GetOptions(\%opts, "man", "db=s", "action=s" ) or pod2usage(2);
pod2usage(-exitstatus => 0, -verbose => 2) if $opts{'man'};
