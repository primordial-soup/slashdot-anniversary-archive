#!/usr/bin/env perl

use strict;
use warnings;

use WWW::Mechanize;
use DateTime;
use File::Spec;
use File::Slurp qw/write_file/;


use constant ARCHIVE_URL => 'http://slashdot.org/index2.pl?section=13&color=green&index=1&view=stories&duration=-1&startdate=';
#'20121025'
use constant DIR => 'archive';

mkdir DIR;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla Firefox 2.5');
my $today = DateTime->now;
my $six_years = $today->duration_class->new( years => 6 );
my $dt = $today - $six_years;
my $a_day = $dt->duration_class->new( days => 1 );
while( $dt < $today ) {
	my $dt_str = $dt->ymd('');
	print "$dt_str\n";
	my $file = File::Spec->catfile(DIR, $dt_str );
	unless(-e $file) {
		my $resp = $mech->get( ARCHIVE_URL . $dt_str);
		write_file($file, $resp->decoded_content);
		sleep 5;
	}
	$dt += $a_day;
}
