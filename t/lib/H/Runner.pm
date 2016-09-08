package H::Runner;

use Gob::Moose;

use Gob::Types;
use H::Test::Class::Moose::Config;
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

# These are values from the CLI set by passing --test-classes
has test_classes => (
    is  => 'ro',
    isa => t( 'ArrayRef', of => t('NonEmptyStr') ),
    default => sub { [] },
);

# These are the munged filenames/classes from the CLI, whether via the
# --test-classes argument or by being the "extra" argv.
has _test_classes => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => t( 'ArrayRef', of => t('PackageName') ),
    lazy    => 1,
    builder => '_build_test_classes',
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

    my %args = ( set_process_name => 1 );

    $args{test_classes} = $self->_test_classes
        if $self->_has_test_classes;

    if ( $self->_has_methods ) {
        my $names = join '|',
            map { /^test_/ ? $_ : 'test_' . $_ } $self->methods->@*;
        $args{include} = qr/^(?:$names)$/;
    }

    my $c = H::Container->new;
    $args{test_configuration}
        = H::Test::Class::Moose::Config->new( container => $c );

    Test::Class::Moose::Runner->new(%args)->runtests;

    # We don't want to try to drop the database if it hasn't already been
    # created.
    if ( $c->created_service('fixtures/f') ) {
        $c->resolve( service => 'database|db_name/dbh' )->disconnect;
        $c->resolve( service => 'fixtures/db' )->drop;
    }

    return 0;
}

sub _load_classes ($self) {
    unless ( $self->_has_test_classes ) {
        Test::Class::Moose::Load->import('t/testlib');
        return;
    }

    require_module($_) for $self->_test_classes->@*;

    return;
}

sub _build_test_classes ($self) {
    return [
        map { $self->_maybe_file_to_class($_) } (
            $self->test_classes->@*,
            (
                  $self->extra_argv
                ? $self->extra_argv->@*
                : ()
            ),
        )
    ];
}

sub _maybe_file_to_class ( $self, $thing ) {
    return $thing if $thing =~ /::/;

    return fs_path_to_module( $thing =~ s{^.*t/lib/}{}r );
}

__PACKAGE__->meta->make_immutable;

1;
