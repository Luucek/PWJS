#!/usr/bin/perl

use warnings;
use POSIX qw( strftime );
use FileHandle;


my $ORIGINAL;

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

		while(<$fh>) {
			if ($_ =~ m{<th>NAME</th>}) {
				$ORIGINAL = $_;
			}
		}
	}
}

sub get_values {
	
	my @matches;
	my @contestants;

	my $col_count = -1;

	while ($ORIGINAL =~ /(?<=<td class="mini">)(.*?)(?=<\/td>)/g) {
		push @matches, $1;
	}

	# find amount of columns:
	for (my $i = 0; $i < @matches; $i++) {
		if ($matches[$i] =~ m{/users/} and $i > 2) {
			last;
		}
		else {
			$col_count++;
		}
	}

	for (my $i = 1; $i < @matches; $i+= $col_count) {
		push @contestants, $matches[$i];
		push @contestants, $matches[$i + $col_count-2];
	}

	foreach my $m (@contestants) {
		if ($m =~ />(.+?)</) {
			print "imie: ", $1 , " ###### ";
		}
		else {
			if ($m =~ m{/users/}) {
				print "imie: !!EMPTY!! ###### ";
			}
			else {
				print "wynik: ", $m, "\n";
			}
		}
	}
}

my $path = get_file_path();
read_file($path);
get_values();
