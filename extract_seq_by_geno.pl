#!/usr/bin/perl
# FILE_NAME.pl
# Mike Covington
# created: 2012-05-17
#
# Description: 
#
use Modern::Perl;
use Bio::DB::Fasta;
use Bio::SeqIO;
use Getopt::Long;

my ($fa_file, $match_id);

my $options = GetOptions (
    "fasta=s" => \$fa_file,
    "id=s"    => \$match_id,
);

my $out = Bio::SeqIO->new(
    -file   => ">outputfilename" ,
    -format => 'Fasta'
);

my $seq_db = Bio::DB::Fasta->new($fa_file);

#get all gene IDs that match query
my @ids_all = $seq_db->ids;
my @matches_full;
for my $id (@ids_all) {
    push @matches_full, $1 if $id  =~ m/(.*$match_id.*)/i; #what if multiple??
}

#write output fasta file for all queries
for my $seq_id (sort @matches_full) {
    my $seqobj = Bio::Seq->new(
        -display_id => $seq_id,
        -seq        => $seq_db->seq($seq_id)
    );
    $out->write_seq($seqobj);
}



# my $db = Bio::DB::Fasta->new('ITAG2.3_cds_SHORTNAMES.fasta');
# my @ids_all = $db->ids;
# my $match_id = "Solyc00g016590.1.1";# "Solyc00g005000.2.1";

# # my $seq = $db->seq('lyrata', 1 => 108);
# my $seq = $db->seq($match_id);
# say "seq:$seq." if defined $seq;
# for my $id (@ids_all) {
#     say $1 if $id  =~ m/(.*$match_id.*)/i;
# }
