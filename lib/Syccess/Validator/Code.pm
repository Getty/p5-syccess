package Syccess::Validator::Code;
# ABSTRACT: A validator to check a value through a simple coderef

use Moo;

with qw(
  Syccess::Validator
);

has message => (
  is => 'lazy',
);

sub _build_message {
  return 'Your value for %s is not valid.';
}

sub validate {
  my ( $self, %params ) = @_;
  my $name = $self->syccess_field->name;
  return if !exists($params{$name})
    || !defined($params{$name})
    || $params{$name} eq '';
  my $value = $params{$name};
  my $code = $self->arg;
  my @return;
  for ($value) {
    push @return, $code->($self,%params);
  }
  return map { !defined $_ ? $self->message : $_ } @return;
}

1;

=encoding utf8

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ code => sub { $_ > 3 ? () : ('You are WRONG!') } ],
      bar => [ code => {
        arg => sub { $_ > 5 ? () : (undef) },
        message => 'You have 5 seconds to comply.'
      } ],
    ],
  );

=head1 DESCRIPTION

This validator allows checking against a CodeRef. The CodeRef will be getting
all parameters on B<@_> as Hash, and the specific parameter value for to check
against will be in B<$_>, so the coderef can decide which way he want to check.

The CodeRef should give back nothing (not even B<undef>) if its a success. Else
if should give back B<undef> to release the error message given on L</message>
or the default error message B<'Your value for %s is not valid.'>. Alternative
it can also give back a string which will be used as B<message> for the error.

=attr message

This contains the error message or the format for the error message
generation. See L<Syccess::Error/validator_message>.

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut