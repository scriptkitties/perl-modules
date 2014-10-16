#!/usr/bin/env perl

use strict;
use warnings;

package Scriptkitties::Ask;

sub new
{
	my $class = shift;
	my $self  = {
	};

	bless($self, $class);

	return $self;
}

sub input
{
	my($self, $question, $default, $allow_empty) = @_;
	my $answer;

	if (!defined($allow_empty)) {
		$allow_empty = 0;
	}

	do {
		if (defined($default)) {
			print "$question [$default]: ";
		} else {
			print "$question: ";
		}

		chomp($answer = <STDIN>);

		if (!length($answer) && length($default)) {
			$answer = $default;
		}
	} while(!length($answer) && !$allow_empty);

	return $answer;
}

sub bool
{
	my($self, $question, $default) = @_;
	my $answer;
	my $value;

	if (!defined($default)) {
		$default = 0;
	}

	if ($default) {
		$value   = 'Yn';
	} else {
		$value   = 'yN';
	}

	print "$question [$value]: ";

	chomp($answer = <STDIN>);

	if (!length($answer) && $default) {
		return 1;
	}

	if (length($answer) && $answer =~ /^y.*/i) {
		return 1;
	}

	return 0;
}

1;
