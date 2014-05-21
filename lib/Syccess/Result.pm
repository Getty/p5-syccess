package Syccess::Result;
# ABSTRACT: A validation process result

use Moo;
use Module::Runtime qw( use_module );

has syccess => (
  is => 'ro',
  required => 1,
);

has params => (
  is => 'ro',
  required => 1,
);

has success => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_success {
  my ( $self ) = @_;
  return scalar @{$self->errors} ? 0 : 1;
}

has errors => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_errors {
  my ( $self ) = @_;
  my %params = %{$self->params};
  my @fields = @{$self->syccess->fields};
  my @errors;
  for my $field (@fields) {
    my @messages = $field->validate( %params );
    for my $message (@messages) {
      my $ref = ref $message;
      if ($ref eq 'ARRAY' or !ref) {
        push @errors, use_module($self->syccess->error_class)->new(
          message => $message,
          syccess_field => $field,
          syccess_result => $self,
        );
      } elsif ($ref eq 'HASH') {
        my %error_args = %{$message};
        push @errors, use_module($self->syccess->error_class)->new(
          %error_args,
          syccess_field => $field,
          syccess_result => $self,
        );        
      } else {
        push @errors, $message;
      }
    }
  }
  return [ @errors ];
}

1;
