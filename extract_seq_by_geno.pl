#!/usr/bin/perl
# FILE_NAME.pl
# Mike Covington
# created: 2012-05-17
#
# Description: 
#
use Modern::Perl;
use Bio::DB::Fasta;

my $file_in = $ARGV[0];
my $match_id = $ARGV[1];
#
my $db = Bio::DB::Fasta->new($file_in);
my @ids_all = $db->ids;
my $match_full;
my @testarray;
for my $id (@ids_all) {
    $match_full = $1 if $id  =~ m/(.*$match_id.*)/i; #what if multiple??
    push @testarray, $1 if $id  =~ m/(.*$match_id.*)/i;
}

say scalar @testarray;

my $seq = $db->seq($match_full);
say "$match_full:$seq" if defined $seq;




# my $db = Bio::DB::Fasta->new('ITAG2.3_cds_SHORTNAMES.fasta');
# my @ids_all = $db->ids;
# my $match_id = "Solyc00g016590.1.1";# "Solyc00g005000.2.1";

# # my $seq = $db->seq('lyrata', 1 => 108);
# my $seq = $db->seq($match_id);
# say "seq:$seq." if defined $seq;
# for my $id (@ids_all) {
#     say $1 if $id  =~ m/(.*$match_id.*)/i;
# }
