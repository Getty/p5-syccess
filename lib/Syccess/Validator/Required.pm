package Syccess::Validator::Required;
# ABSTRACT: A validator to check for a required field

use Moo;

with qw(
  Syccess::Validator
);

has message => (
  is => 'lazy',
);

sub _build_message {
  return '%s is required.';
}

sub validate {
  my ( $self, %params ) = @_;
  my $name = $self->syccess_field->name;
  return $self->message if !exists($params{$name})
    || !defined($params{$name})
    || $params{$name} eq '';
  return;
}

1;

=encoding utf8

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ required => 1 ],
      bar => [ required => {
        message => 'You have 5 seconds to comply.'
      } ],
    ],
  );

=head1 DESCRIPTION

This validator allows to check if a field is required. The default error
message is B<'%s is required.'> and can be overriden via the L</message>
parameter.

=attr message

This contains the error message or the format for the error message
generation. See L<Syccess::Error/validator_message>.

=head1 SUPPORT

IRC

  Join irc.perl.org and msg Getty

Repository

  http://github.com/Getty/p5-syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-syccess/issues

=cut
