package Syccess::Validator;
# ABSTRACT: Syccess validator

use Moo::Role;

requires qw(
  validate
);

has syccess_field => (
  is => 'ro',
  required => 1,
  handles => [qw(
    syccess
  )],
);

has arg => (
  is => 'ro',
  predicate => 1,
);

1;