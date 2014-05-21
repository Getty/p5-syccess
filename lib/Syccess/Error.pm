package Syccess::Error;
# ABSTRACT: Syccess error message

use Moo;

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
  return ref $validator_message eq 'ARRAY'
    ? sprintf(@{$validator_message})
    : $validator_message;
}

has validator_message => (
  is => 'ro',
  init_arg => 'message',
  required => 1,
);

1;
