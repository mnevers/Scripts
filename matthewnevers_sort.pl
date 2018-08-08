#!/usr/bin/perl

#Matthew Nevers
#Simple sort program written in Perl
#9/7/17
#matthewnevers_sort.pl reads in an arbitrary number of strings from the command line and
#displays them sorted alphabetically
#To execute the program simple enter perl matthewnevers_sort.pl x x x (x's being strings to sort)
#you may also add -r to reverse the sort order or -h for help.

use strict;
use warnings;
use Getopt::Long;

my @words; 	#Array of strings to sort
my $length;	#@words array length
my $reverse;	#reverse option boolean
my $help;	#help option boolean

#Assign option values
GetOptions(
	'reverse' => \$reverse,
	'help' => \$help,
)or die "Use -h for Help\n";

#Assign arguments to @words array
foreach(@ARGV){
	push (@words, $_);
}

#Display Help 
#Else execute complete function.
if($help){
	print "\n$0 requires two or more strings to sort\n\n";
	print "-r, --reverse \t\t Reverses the sort order for the strings to sort\n";
	print "-h, --help \t\t Help\n";
}else{
	$length = @words;
	
	if($length > 1){
		if($reverse){
			@words = reverse sort(@words);
			print "@words";
		}else{		
			@words = sort(@words);	
			print "@words";
		}
	}else{
		print "Invalid command line arguments to program. Please supply two or more strings to sort";
	}
}