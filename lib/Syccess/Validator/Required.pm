package Syccess::Validator::Required;
# ABSTRACT: A field that is required

use Moo;

with qw(
  Syccess::Validator
);

has message => (
  is => 'lazy',
);

sub _build_message { "This field is required." }

sub validate {
  my ( $self, %params ) = @_;
  my $name = $self->syccess_field->name;
  return $self->message if !exists($params{$name})
    || !defined($params{$name})
    || $params{$name} eq '';
  return;
}

1;