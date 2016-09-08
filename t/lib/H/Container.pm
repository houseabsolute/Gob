package H::Container;

use Gob::Moose;

use Bread::Board;
use Gob::Container;
use Gob::Types;
use H::Fixtures;
use H::Fixtures::DB;
use Module::Util qw( module_path );
use Path::Tiny qw( path );

use g;

extends 'Gob::Container';

sub _build_db_name {
    return join q{_}, 'Gob', $$, time;
}

override _build_container => sub {
    my $fixtures = container fixtures => as {
        service checkout_root_dir =>
            path( $INC{ module_path(__PACKAGE__) } )
            ->parent->parent->parent->parent;

        service db => (
            class        => 'H::Fixtures::DB',
            dependencies => [
                'checkout_root_dir',
                map { '/database|db_name/' . $_ }
                    qw( name user password host port )
            ],
        );

        # This is separate from fixtures so we can enforce the order of db ->
        # connect schema -> create fixtures. If we make both the schema and
        # the db dependencies of the fixtures object, then we might try to
        # create the schema object before the database actually exists.
        service schema => (
            block => sub ($s) {
                $s->parent->resolve( service => '/database|db_name/schema' );
            },
            dependencies => ['db'],
        );
        service f => (
            class        => 'H::Fixtures',
            lifecycle    => 'Singleton',
            dependencies => ['schema'],
        );
    };

    my $container = super();
    $container->add_sub_container($fixtures);

    return $container;
};

__PACKAGE__->meta->make_immutable;

1;
