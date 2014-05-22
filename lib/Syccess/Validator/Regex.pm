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

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut