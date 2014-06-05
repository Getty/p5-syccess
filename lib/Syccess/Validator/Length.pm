package Syccess::Validator::Length;
# ABSTRACT: A validator to check the length of the value in chars

use Moo;
use Carp qw( croak );

with qw(
  Syccess::ValidatorSimple
);

has min => (
  is => 'ro',
  predicate => 1,
);

has max => (
  is => 'ro',
  predicate => 1,
);

sub BUILD {
  my ( $self ) = @_;
  croak __PACKAGE__.' cant have arg (specific length) and min/max'
    if $self->has_arg && ( $self->has_min || $self->has_max );
}

has message => (
  is => 'lazy',
);

sub _build_message {
  my ( $self ) = @_;
  if ($self->has_arg) {
    return [ $self->format, $self->arg ];
  } else {
    if ($self->has_min && $self->has_max) {
      return [ $self->format, $self->min, $self->max ];
    } elsif ($self->has_min) {
      return [ $self->format, $self->min ];
    } elsif ($self->has_max) {
      return [ $self->format, $self->max ];
    }
  }
  croak __PACKAGE__.' needs an arg, min or max value';
}

has format => (
  is => 'lazy',
);

sub _build_format {
  my ( $self ) = @_;
  if ($self->has_arg) {
    return '%s must be exactly %s characters.';
  } else {
    if ($self->has_min && $self->has_max) {
      return '%s must be between %s and %s characters.';
    } elsif ($self->has_min) {
      return '%s must be at least %s characters.';
    } elsif ($self->has_max) {
      return '%s is not allowed to be more than %s characters.';
    }
  }
  croak __PACKAGE__.' needs an arg, min or max value';
}

sub validator {
  my ( $self, $value ) = @_;
  my $length = length($value);
  if ($self->has_arg) {
    return $self->message if $length != $self->arg;
  } else {
    if ($self->has_min && $self->has_max) {
      return $self->message if $length < $self->min || $length > $self->max;
    } elsif ($self->has_min) {
      return $self->message if $length < $self->min;
    } elsif ($self->has_max) {
      return $self->message if $length > $self->max;
    }
  }
  return;
}

1;

=encoding utf8

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      pin => [ length => 4 ],
      username => [ length => {
        min => 3,
        max => 12,
        message => 'Username must be between %s and %s characters.'
      } ],
      tweet => [ length => { max => 140 } ],
    ],
  );

=head1 DESCRIPTION

This validator allows to check for the amount of characters in the value.
The default error message depends on the parameter given. The default
functionality is using the parameter as the required length for the value.
Longer or shorter would be denied. This can't be combined with L</min> or
L</max>.

=attr min

Given this parameter, allows to define a minimum length for the value. This
can be combined with L</max>.

=attr max

Given this parameter, allows to define a maximum length for the value. This
can be combined with L</min>.

=attr message

This contains the error message or the format for the error message
generation. See L<Syccess::Error/validator_message>.

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut