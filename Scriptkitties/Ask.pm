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
		$default,
		$columns
	) = @_;
	my @options       = @$o;
	my $answer;
	my $columnc       = 0;
	my $max_opts      = ($#options + 1);
	my $length_index  = length("$max_opts");
	my $length_option = 0;
	my $printf_value;

	# set the amount of columns
	if (!defined($columns) || $columns == 0) {
		$columns = 1;
	} else {
		for (my $i = 0; $i < $#options; $i++) {
			# check wether a displayname is given and store it in a variable we're not using
			# right now anyway
			if (defined($options[$i][1])) {
				$printf_value = $options[$i][1];
			} else {
				$printf_value = $options[$i][0];
			}

			# check if the length is bigger, since we want the biggest possible length
			if (length($printf_value) > $length_option) {
				$length_option = length($printf_value);
			}
		}

		# add a bit of space between the options
		$length_option += 2;

		# calculate how much columns we could fit
		$columns = int(80 / $length_option) - 1;

		# at least 1 column would be nice to have
		if ($columns < 1) {
			$columns = 1
		}
	}

	# print the quetion
	print "$question:\n";

	while (1) {
		for (my $i = 0; $i < $max_opts; $i++) {
			if (defined($options[$i][1])) {
				$printf_value = $options[$i][1];
			} else {
				$printf_value = $options[$i][0];
			}

			# print the option
			printf(" %${length_index}d) %-${length_option}s", ($i + 1), $options[$i][1]);

			if (++$columnc == $columns) {
				print "\n";
				$columnc = 0;
			}
		}

		# add an extra newline before the input
		print "\n";

		if (defined($default) && $default > 0) {
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
			print "\"$answer\" is an invalid choice. Please try again.\n";
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
