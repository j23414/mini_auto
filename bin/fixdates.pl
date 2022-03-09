#! /usr/bin/env perl
# Auth: Jennifer Chang
# Date: 2018/03/26

use strict;
use warnings;

my @column;
my @date;
while(<>){
    chomp;
    @column=split(/\t/,$_);
    if(scalar @column > 5){
	@date=split(/\//,$column[5]);
	if(scalar @date <2){
#	    print (@date,"\n");
	    $column[5]=join('/',@date,"01","01");
#	    print ($column[5],"\n");
	}elsif(scalar @date < 3){
#	    print (@date,"\n");
	    $column[5]=join('/',@date,"01");
#	    print ($column[5],"\n");
	}
	print (join("\t",@column),"\n");
    }   
}
