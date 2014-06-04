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

=encoding utf8

=head1 SYNOPSIS

  package MyValidators::Custom;

  use Moo;

  with qw(
    Syccess::Validator
  );

  sub validate {
    my ( $self, %params ) = @_;
    my $name = $self->syccess_field->name;
    # No error if there is no value
    return if !exists($params{$name});
    my $value = $params{$name};
    return if $value eq 'ok';
    return 'Your value for %s is not ok.';
  }

  1;

=head1 DESCRIPTION

A custom validator requires a B<validate> function, which will be given the
complete list of parameters that was given to the B<validate> function on the
L<Syccess> object. If there is no error, then the function must return also
nothing, as in, an empty list. Anything else given back will be converted into
an error message. Most simple is giving a string, that may contain a B<%s>,
which will be filled with the label of the field.

Normally you don't need this role, most validation requirements will be
fulfilled with the B<Syccess::ValidatorSimple>. The case for this role is only
given, if you need also access to values of other fields to decide the
success.

=attr syccess_field

This attribute will be set automatically by Syccess, when it instantiate an
object of the validator. There the validator can get the B<name> to find its
value in the parameters given on B<validate>.

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut