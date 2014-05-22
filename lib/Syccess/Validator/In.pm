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

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut