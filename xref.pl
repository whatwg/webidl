#!/usr/bin/perl -w

use strict;

# regex hacking of xml ftw

my $opt = shift || '';
my $input = shift || '-';

unless ($opt =~ /^-[dt]/ && $input ne '' && @ARGV == 1) { 
  die <<EOF
usage:
  $0 -d INPUT URL   output ID database file for the input XML document
  $0 -t INPUT DB    translate input XML document using ID database file
EOF
}

my %db;
my %internal;
my $url;

sub fixup {
  my $tag = shift;
  return $tag unless $tag =~ /\bhref=["']#([^"']*)["']/;
  my $frag = $1;
  return $tag unless !exists($internal{$frag}) && exists($db{$frag});
  $tag =~ s/\bhref=["']#[^"']*["']/href="$url#$frag"/;
  if (!($tag =~ s/\bclass=["']([^"']*)["']/class="$1 external"/)) {
    $tag =~ s/>$/ class="external">/;
  }
  return $tag;
}

if ($opt eq '-d') {
  my $url = shift;
  local $/;
  open FH, $input;
  my $s = <FH>;
  close FH;
  print "$url\n";
  while ($s =~ s/<[a-z][a-z0-9]*[^>]*id=["']([^"']+)["'][^>]*>//) {
    print "$1\n";
  }
} elsif ($opt eq '-t') {
  my $dbfile = shift;
  open FH, $dbfile;
  $url = <FH>;
  chomp $url;
  %db = ();
  while (<FH>) {
    chomp;
    $db{$_} = 1;
  }
  close FH;
  local $/;
  open FH, $input;
  my $s = <FH>;
  my $t = $s;
  close FH;
  %internal = ();
  while ($s =~ s/<[a-z][a-z0-9]*[^>]*id=["']([^"']+)["'][^>]*>//) {
    $internal{$1} = 1;
  }
  $s = $t;
  $s =~ s/(<a\b[^>]*>)/fixup($1)/ge;
  print $s;
}
