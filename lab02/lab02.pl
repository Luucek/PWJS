#!/usr/bin/perl

use warnings;
use POSIX qw( strftime );
use FileHandle;


my @STARTS;
my @ENDS;

my $STARTS_COUNT = 0;
my $ENDS_COUNT = 0;

sub get_file_path() {
	
	print "Podaj sciezke do pliku:\n";
	my $file_path = <STDIN>;
	chomp $file_path;

	return $file_path;
}

sub read_file {

	my $file_path = shift;

	my $fh = FileHandle->new;

	if ($fh->open("< $file_path")) {
	
		my $start_flag = "DTSTART;";
		my $end_flag = "DTEND;";

		while(<$fh>){
			if (index($_, $start_flag) != -1) {

				if (my $t = (substr $_, -8, 1) ne "T") {

					push @STARTS, (substr $_, -8, 4);
				}
				else {
					push @STARTS, (substr $_, -7, 4);
				}
				
				$STARTS_COUNT++;
			}
			if (index($_, $end_flag) != -1) {
				
				if (my $t = (substr $_, -8, 1) ne "T") {
					push @ENDS, (substr $_, -8, 4);
				}
				else {
					push @ENDS, (substr $_, -7, 4);
				}

				$ENDS_COUNT++;
			}
		}

		$fh->close;
	}
}

sub get_working_hours() {

	my $working_minutes = 0;
	
	if ($STARTS_COUNT eq $ENDS_COUNT) {
		for (my $i = 0; $i < $STARTS_COUNT; $i++) {
			my $hours = abs( (substr $ENDS[$i], 0, 2) - (substr $STARTS[$i], 0, 2) );
			my $minutes = abs( (substr $ENDS[$i], 2, 2) - (substr $STARTS[$i], 2, 2) );
			$working_minutes += $hours * 60 + $minutes;
		}
	}
	else {
		print "Ilosc rozpoczetych zajec nie jest rowna ilosci zakonczonych zajec!";
		exit;
	}
	
	return $working_minutes / 60;
}

my $path = get_file_path();
read_file($path);
print "Ilosc godzin przepracowanych w semestrze: ";
print get_working_hours();
print "\n"
