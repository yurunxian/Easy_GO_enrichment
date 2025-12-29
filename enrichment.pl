use strict;
use warnings;
use Getopt::Long;
use Text::NSP::Measures::2D::Fisher::right;

my $bg = "";
my $input = "";
my $desc = "";
my $rank = 0;
my $threshold = "";
my $threshold_raw = "";
my $help = "";
my %input = ();
my %all_input = ();
my %description = ();
my %GO2gene = ();
my %gene2GO = ();
my %pvalue_raw = ();
my $usage = "Usage: perl enrichment.pl -b <background> -i <gene_list> -p 0.05\n";
GetOptions ("b=s" => \$bg,
			"i=s" => \$input,
			"d=s" => \$desc,
			"p=f" => \$threshold,
			"r=f" => \$threshold_raw,
			"h" => \$help) or die(get_help());
if ($help) {get_help(); die()}
if ($threshold and $threshold_raw) {get_help(); die("\nERROR: -p and -r are mutually exclusive!\n")}
if (!$threshold and !$threshold_raw) {get_help(); die("\nERROR: Please set a threshold for output with -p OR -r!\n")}
if (!$bg or !$input) {get_help(); die($usage)}

open (BG,"<$bg") or die();
open (IN,"<$input") or die();
open (DESC,"<$desc");

while (<BG>) {
	$_ =~ s/[\r\n]+//;
	my @tmp = split /\s+/,$_;
	push @{$GO2gene{$tmp[0]}},$tmp[1];
	push @{$gene2GO{$tmp[1]}},$tmp[0];
}

while (<IN>) {if (/(\S+)/) {
	my $gene = $1;
	if (exists $gene2GO{$gene}) {
		$all_input{$gene} = 1;
		foreach my $GO (@{$gene2GO{$gene}}) {$input{$GO}++}}
	}
}

while (<DESC>) {
	$_ =~ s/[\r\n]+//;
	my @tmp = split /\t/,$_;
	$description{$tmp[0]} = $tmp[1];
}

foreach my $GO (sort keys %input) {
	my $n11 = $input{$GO};
	my $n12 = scalar keys %all_input;
	my $n21 = scalar @{$GO2gene{$GO}};
	my $n22 = scalar keys %gene2GO;
	my $n1p = $n11 + $n12;
	my $np1 = $n11 + $n21;
	my $npp = $n11 + $n12 + $n21 + $n22;
	$pvalue_raw{$GO} = calculateStatistic(n11=>$n11,n1p=>$n1p,np1=>$np1,npp=>$npp);
}

#my @number = grep {$pvalue_raw{$_} < 0.05} keys %pvalue_raw;

print "GO term\tDescription\t# within input\t# within backgroud\tRaw p-value\tFDR adjusted p-value\n";
foreach my $GO (sort {$pvalue_raw{$a} <=> $pvalue_raw{$b}} keys %pvalue_raw) {
	$rank++;
	my $pvalue_FDR = $pvalue_raw{$GO} * scalar(keys %pvalue_raw) / $rank;
	if ($threshold and $pvalue_FDR < $threshold) {
		if (! exists $description{$GO}) {$description{$GO} = "NA"}
		print $GO,"\t",$description{$GO},"\t",$input{$GO},"\t",scalar @{$GO2gene{$GO}},"\t",$pvalue_raw{$GO},"\t",$pvalue_FDR,"\n";
	}
	elsif ($threshold_raw and $pvalue_raw{$GO} < $threshold_raw) {
		if (! exists $description{$GO}) {$description{$GO} = "NA"}
		print $GO,"\t",$description{$GO},"\t",$input{$GO},"\t",scalar @{$GO2gene{$GO}},"\t",$pvalue_raw{$GO},"\t",$pvalue_FDR,"\n";
	}
}

sub get_help {
print <<END_OF_TEXT;

    ###########################
    #        Runxian Yu       #
    #  yurunxian\@ibcas.ac.cn  #
    ###########################

    This script is designed for (GO) enrichment analysis, using Fisher's exact test
    and FDR (False Discovery Rate) correction.

    Usage:
    -b <backgroud>   a text file containing the GO term for each gene.
                     example:    GO:0005524    AT3G54180
                                 GO:0006468    AT3G54180
                                 GO:0005515    AT3G54190
                                 GO:0006412    AT3G54210
    -i <gene_list>   input gene list, one gene per line.
                     example:    AT3G54180
                                 AT3G54180
                                 AT3G54190
                                 AT3G54210
    -r <0-1>         the threshold of RAW p-value for output. Mutually exclusive with -p.
    -p <0-1>         the threshold of adjusted p-value for output. Mutually exclusive with -r.
    -d <description> a text file containing the description for each GO term. (Optional)
                     example:    GO:0000001    mitochondrion inheritance
                                 GO:0000002    mitochondrial genome maintenance
                                 GO:0000003    reproduction
    -h               print this page

END_OF_TEXT
}
