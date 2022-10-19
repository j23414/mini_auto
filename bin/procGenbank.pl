#! /usr/bin/env perl
# Auth: Jennifer Chang
# Date: 2018/05/14

use strict;
use warnings;

# ===== Check ARGS 
my $USAGE="USAGE: $0 <input.gb> > <tabular|fasta>\n";
$USAGE=$USAGE."    input.gb - genbank file\n";
$USAGE=$USAGE."    Edit the printEntry function to select tab or fasta output\n";

if(@ARGV != 1){
    die $USAGE;
    exit;
}
# ===== Variables
my $fn=$ARGV[0];

my $unknown="-";

my $col_country="Collection_Country";
my $col_date="Collection_Date";
my $consrtm="Consrtm";
my $gb="GenBank";
my $host="Host";
my $iso_source="Isolation_Source";
my $isolate="Sample_Identifier";
my $state="State";
my $strain="Strain";
my $subtype="Subtype";
my $segment="Segment";
my $gene="Gene";
my $def="define";
my $type="VRL";
my $authors="authors";
my $pubmed="pubmed";
# = Fasta output
my $fasta="";
my $seq=-1;
my $yr="ColYear";
my $mo="ColMon";
my $dd="01"; # "ColDay"

my $start=-1;   # only restrict to coding region, cut off to ATG start site
my $stop=-1;

my %months=(
    "Jan","01",
    "Feb","02",
    "Mar","03",
    "Apr","04",
    "May","05",
    "Jun","06",
    "Jul","07",
    "Aug","08",
    "Sep","09",
    "Oct","10",
    "Nov","11",
    "Dec","12"
    );

my %fluC_genes=(
    "1","PB2",
    "2","PB1",
    "3","P3",
    "4","HE",
    "5","NP",
    "6","M",
    "7","NS"
    );

my %fluA_genes=(
    "1","PB2",
    "2","PB1",
    "3","PA",
    "4","HA",
    "5","NP",
    "6","NA",
    "7","M",
    "8","NS"
    );

# = Reset variables
sub resetVariables(){
  $col_country=$unknown;
  $col_date=$unknown;
  $yr="XXXX";
  $mo="XX";
  $dd="XX";
  $consrtm=$unknown;
  $gb=$unknown;
  $host=$unknown;
  $iso_source=$unknown;
  $isolate=$unknown;
  $state=$unknown;
  $strain=$unknown;
  $subtype=$unknown;
  $segment=$unknown;
  $gene=$unknown;
  $fasta="";
  $seq=-1;
  $def=$unknown;
  $type=$unknown;
  $start=-1;
  $stop=-1;
  $authors=$unknown;
  $pubmed="unpublished";
}

# ===== Print line of GB data
sub printEntry(){
    if($type eq "PAT"){ # Ignore Patents
        resetVariables();
        return;
    }
    # = If "strain=" was empty, try "isolate=", else try to parse from "DEFINITION" line
    if($strain eq $unknown){
        if($isolate ne $unknown){
            $strain=$isolate;
        } else {
            if($def =~/virus [^(]+\((.+)\)/){
                $strain=$1;
            }elsif($def =~ /Influenza (\S+\/\S+.+\/\S+)\s/){
                $strain=$1;
            }
            # $strain=$def;
            # # /DEFINITION\s+[^(]+\((.+)\)/
            # $strain=~s/ /_/g;
            # $strain=(split(/\(/,$strain))[0];
            # $strain=~s/_$//g;
        }
    }

    # # = Recover A0 number from strain name if not in isoalte
    # if(defined($isolate) && $isolate eq $unknown){
	#     my @temp=split(/\//, $strain);
	#     if(defined($temp[3])){
	#         $isolate=$temp[3];
	#         $isolate=~s/ //g;
	#         # if(substr($isoalte,0,2) ne "A0" || length($isolate) != 9){
	#         #     $isolate=$unknown;
	#         # }
    #     }
    # }

    $state=(split(/\//,$strain))[2] || $state;
    $col_country=(split(/:/,$col_country))[0] || $col_country;

    # = Process dates
    if($col_date eq $unknown) {
        $col_date=$1 if($strain =~ /\/(\d+)$/);
        if(length($col_date)==2){
            $col_date="19$col_date";
        }
    }

    # = Convert dates to numbers
    if($col_date =~/\d\d\d\d-\d\d-\d\d/){
        # do nothing
    }else{
      my @temp=reverse(split(/-/,$col_date));
      if(defined($temp[0]) && $temp[0] eq $col_date){
	      $yr = $temp[0];
      }
      $yr=$temp[0] || $yr;
      $mo=$temp[1] || $mo;
      $dd=$temp[2] || $dd;
      $mo=$months{$mo} || $mo;
      $col_date=join("-",$yr,$mo,$dd);
    }

    if($segment eq $unknown){
        if($def =~ /segment (\d)/){
            $segment=$1;
        }elsif($def =~ /(\d) gene/){
            $segment=$1;
        }
    }
    if($gene eq $unknown){
        $gene=$fluC_genes{$segment};
    }

    # = Tabular output
    #print join("\t",">",$isolate,$strain,$host,$subtype,$col_date,$yr,$mo,$dd,$col_country,$iso_source,$gb),"\n";
    # print join("\t",$isolate,$col_date,$yr,$mo,$dd,$state,$gb,$subtype,$strain,$iso_source),"\n";

    # = Fasta output
    $fasta=~s/[0-9]//g;
    $fasta=~s/ //g;
    $fasta=~s/\n//g;
    $fasta=~s/\r//g;
    if($start>0 && $stop>0){
        $fasta = substr($fasta, $start-1, $stop-$start+1);
    }

    $authors =~s/, .+/ et al./g;
    
    print ">",join("|",$gb,$strain,$segment,$col_country,$col_date,$authors,$pubmed),"\n";
    print $fasta,"\n";

    # = Reset variables
    resetVariables();
}

# ===== Main
my $fh;
open($fh, "<:encoding(UTF-8)",$fn)
    or die "Could not open file '$fn'";

resetVariables();

# = Reset Variable names for fasta output
while(<$fh>){
    if(/^\/\//){
        printEntry;
    }
    if($seq > 0){
        $fasta=$fasta.$_;
    }elsif(/ACCESSION\s+(\S+)/){
        $gb=$1;
    }elsif(/LOCUS\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/){
        $gb=$1;
        $type=$6;
    }elsif(/gene\s+(\d+)..[>]?(\d+)/){
        if($start==-1 || $1<$start){
            $start=$1;
        }
        if($2 > $stop){
            $stop=$2;
        }
    }elsif(/gene="(.+)"/){
        if($gene eq $unknown || $gene eq "Gene"){ # only capture the first one
            $gene=$1;
        }
    }elsif(/isolate="(.+)"/){
        $isolate=$1;
    }elsif(/host="(.+)"/){
        $host=$1;
    }elsif(/country="(.+)"/){
        $col_country=$1;
    }elsif(/isolation_source="(.+)"/){
        $iso_source=$1;
    }elsif(/strain="(.+)"/){
        $strain=$1;
    }elsif(/serotype="(.+)"/){
        $subtype=$1;
    }elsif(/segment="(.+)"/){
        $segment=$1;
    }elsif(/collection_date="(.+)"/){
        $col_date=$1;
    }elsif(/^ORIGIN/){
        $seq=1;
    }elsif(/CONSRTM\s+(\S.+)/){
        $consrtm=$1;
    }elsif(/DEFINITION\s+(\S.+)/){
        $def=$1;
    }elsif(/AUTHORS\s+(\S.+)/){
        $authors=$1;
    }elsif(/PUBMED\s+(\S.+)/){
        $pubmed=$1;
    }
}
