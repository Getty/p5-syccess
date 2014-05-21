package Syccess::Validator::IsNumber;
# ABSTRACT: A validator to check if value is a number

use Moo;
use Scalar::Util qw( looks_like_number );

with qw(
  Syccess::ValidatorSimple
);

has message => (
  is => 'lazy',
);

sub _build_message {
  return '%s must be a number.';
}

sub validator {
  my ( $self, $value ) = @_;
  return $self->message unless looks_like_number($value);
  return;
}

1;

=encoding utf8

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ is_number => 1 ],
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