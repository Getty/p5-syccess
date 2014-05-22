package Syccess;
# ABSTRACT: Easy Validation Handler

use Moo;
use Module::Runtime qw( use_module );
use Tie::IxHash;

has validator_namespaces => (
  is => 'lazy',
);

sub _build_validator_namespaces {
  my ( $self ) = @_;
  return [
    @{$self->custom_validator_namespaces},
    'Syccess::Validator',
    'SyccessX::Validator',
  ];
}

has custom_validator_namespaces => (
  is => 'lazy',
);

sub _build_custom_validator_namespaces {
  return [];
}

has field_class => (
  is => 'lazy',
);

sub _build_field_class {
  return 'Syccess::Field';
}

has result_class => (
  is => 'lazy',
);

sub _build_result_class {
  return 'Syccess::Result';
}

has error_class => (
  is => 'lazy',
);

sub _build_error_class {
  return 'Syccess::Error';
}

has fields_args => (
  is => 'ro',
  predicate => 1,
);

has errors_args => (
  is => 'ro',
  predicate => 1,
);

has fields_list => (
  is => 'ro',
  required => 1,
  init_arg => 'fields',
);

has fields => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_fields {
  my ( $self ) = @_;
  my @fields;
  my $fields_list = Tie::IxHash->new(@{$self->fields_list});
  for my $key ($fields_list->Keys) {
    push @fields, $self->new_field($key,$fields_list->FETCH($key));
  }
  return [ @fields ];
}

sub new_field {
  my ( $self, $name, $validators_list ) = @_;
  my %fields_args = $self->has_fields_args
    ? (%{$self->fields_args}) : ();
  return use_module($self->field_class)->new(
    %fields_args,
    syccess => $self,
    name => $name,
    validators => $validators_list,
  );
}

sub validate {
  my ( $self, %params ) = @_;
  return use_module($self->result_class)->new(
    syccess => $self,
    params => { %params },
  );
}

sub BUILD {
  my ( $self ) = @_;
  $self->fields;
}

1;

=encoding utf8

=head1 SYNOPSIS

  use Syccess;

  my $syccess = Syccess->new(
    fields => [
      foo => [ required => 1, length => 4, label => 'PIN Code' ],
      bar => [ required => { message => 'You have 5 seconds to comply.' } ],
      baz => [ length => { min => 2, max => 4 }, label => 'Ramba Zamba' ],
    ],
  );

  my $result = $syccess->validate( foo => 1, bar => 1 );
  if ($result->success) {
    print "Yeah!\n";
  }

  my $failed = $syccess->validate();
  unless ($result->success) {
    for my $message (@{$failed->errors}) {
      print $message->message."\n";
    }
  }

=head1 DESCRIPTION

Syccess is developed for L<SyContent|https://sycontent.de/>.

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut
