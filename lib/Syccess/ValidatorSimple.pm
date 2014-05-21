package Syccess::ValidatorSimple;
# ABSTRACT: Syccess validator

use Moo::Role;

with qw(
  Syccess::Validator
);

requires qw(
  validator
);

sub validate {
  my ( $self, %params ) = @_;
  my $name = $self->syccess_field->name;
  return if !exists($params{$name})
    && $self->missing_ok;
  return if exists($params{$name})
    && !defined($params{$name})
    && $self->undef_ok;
  return if exists($params{$name})
    && defined($params{$name})
    && $params{$name} eq ''
    && $self->empty_ok;
  return exists($params{$name})
    ? $self->validator($params{$name})
    : $self->validator();
}

sub missing_ok { 1 }
sub undef_ok { 1 }
sub empty_ok { 1 }

1;