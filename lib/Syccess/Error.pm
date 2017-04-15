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

Contains the actual resulting error message. See L</validator_message>.

=attr syccess_field

References to the L<Syccess::Field> where this error comes from.

=attr syccess_result

References to the L<Syccess::Result> where this error comes from.

=attr validator_message

This field contains the error message information given back by the validator.
I<Syccess::Error> uses this message with B<sprintf> to generate the resulting
error message in L</message>. As parameter for the B<sprintf> you will get
the label of the field. Alternative the validator can give back an ArrayRef
which first element is the format for sprintf, while the rest of the ArrayRef
is used as additional parameter for the formatting. This functionality is
added to make localization of error messages easier, but its still not tested
in a real environment, so changes might happen here.

With an own error trait given via L<Syccess/error_traits> you can always
override the way how the error messages are generated, if you are not happy
with the given procedure.

=head1 SUPPORT

IRC

  Join irc.perl.org and msg Getty

Repository

  http://github.com/Getty/p5-syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-syccess/issues

=cut
