#!/usr/bin/perl
# parse_fasta.pl
# Mike Covington
# created: 2012-05-17
#
# Description: Extracts fasta sequences for specified gene(s)
#
use Modern::Perl;
use autodie;
use Bio::DB::Fasta;
use Bio::SeqIO;
use Getopt::Long;
use File::Basename;

#options/defaults
my ( $fasta_in, $gene_id, $list, $help );
my $out_dir = "./";
my $options = GetOptions(
    "fasta_in=s" => \$fasta_in,
    "gene_id=s"  => \$gene_id,
    "list"       => \$list,
    "out_dir=s"  => \$out_dir,
    "help"       => \$help,
);

#help/usage
my $prog = basename($0);
print_usage() and exit if $help;
print_usage() and exit unless defined $fasta_in and defined $gene_id;

#gather gene ids to search for
my @gene_list;
if ($list) {
    open my $gene_list_fh, '<', $gene_id;
    while ( my $line = <$gene_list_fh> ) {
        chomp $line;
        push @gene_list, $line;
    }
    close $gene_list_fh;
    $gene_id = basename($gene_id);
}
else { push @gene_list, $gene_id; }

#designate input/output files + formats
my $seq_db = Bio::DB::Fasta->new($fasta_in);
my $out    = Bio::SeqIO->new(
    -file   => ">$out_dir/$gene_id.fasta",
    -format => 'Fasta',
);

for my $match_id (@gene_list) {

    #get all gene IDs that match query
    my @ids_all = $seq_db->ids;
    my @matches_full;
    for my $id (@ids_all) {
        push @matches_full, $1 if $id =~ m{ ( \A .* $match_id .* \Z ) }ix;
    }

    #write output fasta file for matching gene(s)
    for my $seq_id ( sort @matches_full ) {
        my $seqobj = Bio::Seq->new(
            -display_id => $seq_id,
            -seq        => $seq_db->seq($seq_id),
        );
        $out->write_seq($seqobj);
    }
}

sub print_usage {
    warn <<"EOF";

USAGE
  $prog [options] -f IN.FASTA -g GENE.ID [-o OUTPUT_DIR]

DESCRIPTION
  Extracts fasta sequences for specified gene(s)

OPTIONS
  -h, --help                Print this help message
  -f, --fasta_in  IN.FASTA  Extract sequences from specified file    
  -g, --gene_id   GENE.ID   Specify gene or list of genes to extract
  -l, --list                Indicates --gene_id is a list of genes in a file
  -o, --out_dir   DIR       Output file is saved in the specified directory
                              (or current directory, if --out_dir is not used)

OUTPUT
  An output file in fasta format is written to the current directory, 
  unless an output directory is specified.
  The name of the output file is GENE.ID.fasta.

EXAMPLES
  $prog -f ITAG2.3_cds_SHORTNAMES.fasta -g Solyc10g044670 -o seq_directory
  $prog --fasta_in ITAG2.3_cds_SHORTNAMES.fasta --gene_id gene.ids --list
  $prog --help

EOF
}