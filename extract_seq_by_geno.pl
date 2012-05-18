#!/usr/bin/perl
# FILE_NAME.pl
# Mike Covington
# created: 2012-05-17
#
# Description:
#
use Modern::Perl;
use autodie;
use Bio::DB::Fasta;
use Bio::SeqIO;
use Getopt::Long;

#options
my ( $fasta_in, $gene_id, $list );
my $options = GetOptions(
    "fasta_in=s" => \$fasta_in,
    "gene_id=s"  => \$gene_id,
    "list"       => \$list,
);

#gather gene ids to search for
my @gene_list;
if ($list) {
    open my $gene_list_fh, '<', $gene_id;
    while ( my $line = <$gene_list_fh> ) {
        chomp $line;
        push @gene_list, $line;
    }
}
else { push @gene_list, $gene_id; }

#designate input/output files + formats
my $seq_db = Bio::DB::Fasta->new($fasta_in);
my $out    = Bio::SeqIO->new(
    -file   => ">$gene_id.fasta",
    -format => 'Fasta'
);

for my $match_id (@gene_list) {

    #get all gene IDs that match query
    my @ids_all = $seq_db->ids;
    my @matches_full;
    for my $id (@ids_all) {
        push @matches_full, $1 if $id =~ m{ ( \A .* $match_id .* \Z ) }ix;
    }

    #write output fasta file for all queries
    for my $seq_id ( sort @matches_full ) {
        my $seqobj = Bio::Seq->new(
            -display_id => $seq_id,
            -seq        => $seq_db->seq($seq_id),
        );
        $out->write_seq($seqobj);
    }
}