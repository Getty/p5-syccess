package Syccess::Validator::Regex;
# ABSTRACT: A validator to check with a regex

use Moo;

with qw(
  Syccess::ValidatorSimple
);

has message => (
  is => 'lazy',
);

sub _build_message {
  return 'Your value for %s is not valid.';
}

sub validator {
  my ( $self, $value ) = @_;
  my $regex = $self->arg;
  my $r = ref $regex eq 'Regexp' ? $regex : qr{$regex};
  return $self->message unless $value =~ m/$r/;
  return;
}

1;

=encoding utf8

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ regex => qr/^\w+$/ ],
      bar => [ regex => {
        arg => '^[a-z]+$', # will be converted to regexp
        message => 'We only allow lowercase letters on this field.',
      } ],
    ],
  );

=head1 DESCRIPTION

This validator allows checking against a regular expression. The regular
expression can be given as Regex or plain scalar, which will be converted
to a Regex.

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