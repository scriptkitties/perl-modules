#!/usr/bin/env perl

package Scriptkitties::Opts;

use strict;
use warnings;

sub new
{
	my $class = shift;
	my $self  = {
		'longopts'   => {
			'help'    => 0,
			'verbose' => 0
		},
		'opts'       => {
		},
		'ignore'     => 0
	};

	bless($self, $class);

	return $self;
}

sub getLong
{
	my $self = shift;
	my $opt  = shift;

	if (defined($self->{longopts}{$opt})) {
		return $self->{longopts}{$opt};
	}

	return 0;
}

sub getOpt
{
	my $self = shift;
	my $opt  = shift;

	if (defined($self->{opts}{$opt})) {
		return $self->{opts}{$opt};
	}

	return 0;
}

sub parse
{
	my $self  = shift;
	my @args  = @_;
	my $index = 0;
	my @split;
	my @leftovers;

	foreach my $arg (@args) {
		if (!$self->{ignore}) {
			# a lone -- indicates that the next values are all arguments, not options
			if (substr($arg, 0, 2) eq '--' && length($arg) == 2) {
				$self->{ignore} = 1;
				next;
			}

			if (substr($arg, 0, 2) eq '--' && length($arg) > 2) {
				$arg   = substr($arg, 2);
				$index = index($arg, '=');

				if ($index > 0) {
					@split = split('=', $arg);

					$self->{longopts}{$split[0]} = $split[1];
				} else {
					$self->{longopts}{$arg} = 1;
				}

				next;
			}

			if (substr($arg, 0, 1) eq '-' && length($arg) == 2) {
				$self->{opts}{substr($arg, 1, 1)} = 1;
				next;
			}
		}

		push(@leftovers, $arg);
	}

	return @leftovers;
}

1;
