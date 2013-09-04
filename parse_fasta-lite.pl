#!/usr/bin/env perl
# FILE_NAME.pl
# Mike Covington
# created: 2013-09-03
#
# Description:
#
use strict;
use warnings;
use autodie;
use feature 'say';

my $gene_list = $ARGV[0];
my $fasta     = $ARGV[1];

open my $gene_list_fh, "<", $gene_list;
my %genes = map { chomp; $_ => 1 } <$gene_list_fh>;
close $gene_list_fh;

open my $fa_fh,     "<", $fasta;
open my $fa_out_fh, ">", "$gene_list.$fasta";
my $hit = 0;
while (<$fa_fh>) {
    if (/^>(\S+)/) {
        $hit = 0;
        $hit = 1 if exists $genes{$1};
    }
    print $fa_out_fh $_ if $hit == 1;
}
close $fa_fh;
close $fa_out_fh;

exit;
