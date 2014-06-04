package Syccess::Field;
# ABSTRACT: Syccess field

use Moo;
use Module::Runtime qw( use_module );
use Module::Load::Conditional qw( can_load );

with qw(
  MooX::Traits
);

has syccess => (
  is => 'ro',
  required => 1,
  weak_ref => 1,
);

has name => (
  is => 'ro',
  required => 1,
);

has label => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_label {
  my ( $self ) = @_;
  if (ref $self->validators_list eq 'HASH') {
    return $self->validators_list->{label}
      if defined $self->validators_list->{label};
  } else {
    my @validators_list = @{$self->validators_list};
    while (@validators_list) {
      my ( $key, $arg ) = splice(@validators_list,0,2);
      return $arg if $key eq 'label';
    }
  }
  return ucfirst($self->name);
}

has validators_args => (
  is => 'ro',
  predicate => 1,
);

has validators_list => (
  is => 'ro',
  required => 1,
  init_arg => 'validators',
);

has validators => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_validators {
  my ( $self ) = @_;
  my %validators_args = $self->has_validators_args
    ? (%{$self->validators_args}) : ();
  my @validators;
  my @validators_list = ref $self->validators_list eq 'HASH'
    ? ( map { $_, $self->validators_list->{$_} }
        sort { $a cmp $b }
        keys %{$self->validators_list} )
    : ( @{$self->validators_list} );
  while (@validators_list) {
    my ( $key, $arg ) = splice(@validators_list,0,2);
    next if $key eq 'label';
    my %args;
    if (ref $arg eq 'HASH') {
      %args = %{$arg};
    } else {
      $args{arg} = $arg;
    }
    $args{syccess_field} = $self;
    push @validators, $self->load_class_by_key($key)->new(
      %validators_args, %args
    );
  }
  return [ @validators ];
}

sub load_class_by_key {
  my ( $self, $key ) = @_;
  my $class;
  if ($key =~ m/::/) {
    if (can_load( modules => { $key, 0 } )) {
      $class = $key;
    }
  } else {
    my $module = $key;
    $module =~ s/_([a-z])/\U$1/;
    $module = ucfirst($module);
    my @namespaces = @{$self->syccess->validator_namespaces};
    for my $namespace (@namespaces) {
      my $can_class = $namespace.'::'.$module;
      if (can_load( modules => { $can_class, 0 } )) {
        $class = $can_class;
        last;
      }
    }
  }
  die __PACKAGE__." can't load validator for ".$key unless $class;
  return use_module($class);
}

sub validate {
  my ( $self, %params ) = @_;
  my @validators = @{$self->validators};
  my @messages;
  for my $validator (@validators) {
    push @messages, $validator->validate(%params);
  }
  return @messages;
}

1;

=encoding utf8

=head1 SYNOPSIS

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