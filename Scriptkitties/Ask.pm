#!/usr/bin/env perl

package Scriptkitties::Ask;

use strict;
use warnings;

sub new
{
	my $class = shift;
	my $self  = {
	};

	bless($self, $class);

	return $self;
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

sub choice
{
	my(
		$self,
		$question,
		$o,
		$default
	) = @_;
	my @options = @$o;
	my $answer;
	my $max_opts = ($#options + 1);

	print "$question:\n";

	while (1) {
		for (my $i = 0; $i < $max_opts; $i++) {
			if (defined($options[$i][1])) {
				printf(" %5d) %s\n", ($i + 1), $options[$i][1]);
			} else {
				printf(" %5d) %s\n", ($i + 1), $options[$i][0]);
			}
		}

		if (defined($default)) {
			printf('Enter a number [%s]: ', $default);
		} else {
			print 'Enter a number: ';
		}

		chomp($answer = <STDIN>);

		if (!length($answer) && !defined($default)) {
			next;
		}

		if (!length($answer) && defined($default)) {
			return $options[$default - 1][0];
		}

		if (!($answer =~ /\d+/)) {
			print "'$answer' is an invalid choice. Please try again.\n";
			next;
		}

		if ($answer <= 0) {
			print "You must enter a positive integer.\n";
			next;
		}

		if ($answer > $max_opts) {
			print "Please enter a number between 1 and $max_opts.\n";
			next;
		}

		last;
	}

	return ($options[$answer - 1][0]);
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

1;
