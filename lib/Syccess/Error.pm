package Syccess::Error;
# ABSTRACT: Syccess error message

use Moo;

with qw(
  MooX::Traits
);

has syccess_field => (
  is => 'ro',
  required => 1,
);

has syccess_result => (
  is => 'ro',
  required => 1,
);

has message => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_message {
  my ( $self ) = @_;
  my $validator_message = $self->validator_message;
  my $format;
  my @args = ( $self->syccess_field->label );
  if (ref $validator_message eq 'ARRAY') {
    my @sprintf_args = @{$validator_message};
    $format = shift @sprintf_args;
    push @args, @sprintf_args;
  } else {
    $format = $validator_message;
  }
  return sprintf($format,@args);
}

has validator_message => (
  is => 'ro',
  init_arg => 'message',
  required => 1,
);

1;

=encoding utf8

=head1 DESCRIPTION

This class is used to store an error and will be given back on the call of
L<Syccess::Field/errors> or L<Syccess::Result/errors>.

=attr message

Contains the actual resulting error message.

=attr syccess_field

References to the L<Syccess::Field> where this error comes from.

=attr syccess_result

References to the L<Syccess::Result> where this error comes from.

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut