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
  my %errors_args = $self->syccess->has_errors_args
    ? (%{$self->syccess->errors_args}) : ();
  my @errors;
  for my $field (@fields) {
    my @messages = $field->validate( %params );
    for my $message (@messages) {
      my $ref = ref $message;
      if ($ref eq 'ARRAY' or !ref) {
        push @errors, use_module($self->syccess->error_class)->new(
          %errors_args,
          message => $message,
          syccess_field => $field,
          syccess_result => $self,
        );
      } elsif ($ref eq 'HASH') {
        my %error_args = %{$message};
        push @errors, use_module($self->syccess->error_class)->new(
          %errors_args,
          %error_args,
          syccess_field => $field,
          syccess_result => $self,
        );        
      } else {
        if (%errors_args && $message->can('errors_args')) {
          $message->errors_args({ %errors_args });
        }
        push @errors, $message;
      }
    }
  }
  return [ @errors ];
}

1;
