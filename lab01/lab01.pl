#!/usr/bin/perl 

use warnings;
use POSIX qw( strftime );


my $LONG_FORMAT = 0;
my $DISPLAY_OWNER = 0;
my @OPTIONS     = ( "-l", "-w" );
my $PATH = ".";

sub check_options {
  if ( @ARGV ) {
    for my $i ( @ARGV ) {
      if ( $i =~ m/$OPTIONS[0]/ ) {
        $LONG_FORMAT = 1;
      } elsif ( $i =~ m/$OPTIONS[1]/ ) {
        $DISPLAY_OWNER = 1;
      } else {
        my $letter = substr($i, 0, 1);
        
        if ( $letter ne "-" ) {
          $PATH = $i;
        } else {
          print "Wrong option: $i\nAvailable options: ";
          
          for my $option ( @OPTIONS ) {
            print "$option ";
          }
          
          print "\n";
          exit;
        }
      }
    }
  }
}

sub validate_path {
  my $path = shift;

  if ( '/' ne substr $path, - length('/') ) {
    $PATH = "$PATH" . "/";
  }
}

sub get_entries {
  my $dir_path = shift;

  opendir( my $dir_handle, $dir_path ) or die "Can't open $dir_path: $!";

  my @entries = readdir( $dir_handle );

  closedir( $dir_handle );

  return [ sort( @entries ) ];
}

sub get_info {
  my $file_path = shift;

  my $size = (stat($file_path))[7];
  my $mtime = (stat($file_path))[9];
  $mtime = strftime('%Y-%m-%d %H:%M:%S', localtime( $mtime ) );
  my $mode = (stat($file_path))[2];

  my @file_info = ($size, $mtime, $mode);

  return [ @file_info ];
}

sub get_owner {
  my $file_path = shift;
  my $uid = (stat($file_path))[4];
  my $owner = getpwuid( $uid );
  
  return " $owner";
}

sub display_entries {
  my @file_names = @{ get_entries( $PATH ) };

  for my $i ( @file_names ) {
    my $letter = substr( $i, 0, 1 );
    
    if ( $letter ne "." ) {
      print "$i ";

      my $file_path = "$PATH" . "$i";
      
      if ($LONG_FORMAT eq 1) {
        my @file_info = @{ get_info( $file_path ) };
        print "$file_info[0] $file_info[1] ";
        my $mods = sprintf( "%04o", $file_info[2] & 07777 );
        print format_mods( $mods );
      }

      if ($DISPLAY_OWNER eq 1) {
          printf get_owner( file_path );
      }

      print "\n";
    }
  }
}

sub format_mods {
  my $mods = shift;
  my $formated = "";

  for my $c (split //, $mods) {
    if ($c eq "7") { $formated = "rwx" }
    elsif ($c eq "6") { $formated = "rw-" }
    elsif ($c eq "5") { $formated = "r-x" }
    elsif ($c eq "4") { $formated = "r--" }
    elsif ($c eq "3") { $formated = "-wx" }
    elsif ($c eq "2") { $formated = "-w-" }
    elsif ($c eq "1") { $formated = "--x" }
    else { $formated = "---" }
  }

  return $formated;
}

check_options();
validate_path($PATH);
display_entries();
