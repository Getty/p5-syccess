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

=encoding utf8

=head1 SYNOPSIS

  package MyValidators::Custom;

  use Moo;

  with qw(
    Syccess::ValidatorSimple
  );

  sub validator {
    my ( $self, $value ) = @_;
    return if $value eq 'ok';
    return 'Your value for %s is not ok.';
  }

  sub missing_ok { 1 }
  sub undef_ok { 1 }
  sub empty_ok { 1 }

  1;

=head1 DESCRIPTION

Please first see L<Syccess::Validator>. This role is a wrapper around it,
which requires a function B<validator>, which will be called with the value
given on the parameters for the field where the validator is used. By default,
it ignores a not existing value, an undefined value or an empty string. You
can override this behaviour by overloading the functions B<missing_ok>,
B<undef_ok> or B<empty_ok> with a sub that returns a false value. Then this
specific case will still be dispatched to the B<validator> function and can
then there produce an error, or not ;).

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut