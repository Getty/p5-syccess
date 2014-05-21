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
