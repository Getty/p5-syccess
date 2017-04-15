package Syccess::Validator::In;
# ABSTRACT: A validator to check if a value is inside of a list of values

use Moo;
use Carp qw( croak );

with qw(
  Syccess::ValidatorSimple
);

has message => (
  is => 'lazy',
);

sub BUILD {
  my ( $self ) = @_;
  croak __PACKAGE__." arg must be ARRAY" unless ref $self->arg eq 'ARRAY';
}

sub _build_message {
  return 'This value for %s is not allowed.';
}

sub validator {
  my ( $self, $value ) = @_;
  my @values = @{$self->arg};
  return $self->message unless grep { $value eq $_ } @values;
  return;
}

1;

=encoding utf8

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ in => [qw( a b c )] ],
    ],
  );

=head1 DESCRIPTION

This validator allows to define a specific list of values which are valid. They
are given as ArrayRef.

=attr message

This contains the error message or the format for the error message
generation. See L<Syccess::Error/validator_message>.

=head1 SUPPORT

IRC

  Join irc.perl.org and msg Getty

Repository

  http://github.com/Getty/p5-syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-syccess/issues

=cut
