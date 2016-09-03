package H::Runner;

use Gob::Moose;

use Gob::Types;
use Module::Runtime qw( require_module );
use Module::Util qw( fs_path_to_module );
use Test::Class::Moose::Load ();
use Test::Class::Moose::Runner;

with 'MooseX::Getopt::Dashes';

has jobs => (
    is      => 'ro',
    isa     => t('PositiveInt'),
    default => 4,
);

has test_classes => (
    traits => ['Array'],
    is     => 'ro',
    isa    => t( 'ArrayRef', of => t('ClassName') ),
    default => sub { [] },
    handles => {
        _has_test_classes => 'count',
    },
);

has methods => (
    traits => ['Array'],
    is     => 'ro',
    isa    => t( 'ArrayRef', of => t('MethodName') ),
    default => sub { [] },
    handles => {
        _has_methods => 'count',
    },
);

sub run ($self) {
    $self->_load_classes;

    my %args = (
        set_process_name => 1,
        jobs             => 1,
    );

    $args{test_classes} = $self->test_classes
        if $self->_has_test_classes;

    if ( $self->_has_methods ) {
        my $names = join '|',
            map { /^test_/ ? $_ : 'test_' . $_ } $self->methods->@*;
        $args{include} = qr/^(?:$names)$/;
    }

    Test::Class::Moose::Runner->new(%args)->runtests;

    return 0;
}

sub _load_classes ($self) {
    unless ( $self->_has_test_classes ) {
        Test::Class::Moose::Load->import('t/lib');
        return;
    }

    require_module($_)
        for map { $self->_maybe_file_to_class($_) } $self->test_classes->@*;

    return;
}

sub _maybe_file_to_class ( $self, $thing ) {
    return $thing if $thing =~ /::/;

    return fs_path_to_module( $thing =~ s{^.*t/lib/}{}r );
}

__PACKAGE__->meta->make_immutable;

1;
