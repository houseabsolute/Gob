package H::Runner;

use Gob::Moose;

use Gob::Types;
use H::Container;
use Module::Runtime qw( require_module );
use Module::Util qw( fs_path_to_module );
use Test::Class::Moose 0.87 ();

with 'Test::Class::Moose::Role::CLI';

around run => sub ( $orig, $self, @args ) {
    my $c = $T::C = H::Container->new;

    $self->$orig( @args, set_process_name => 1 );

    # We don't want to try to drop the database if it hasn't already been
    # created.
    if ( $c->created_service('fixtures/f') ) {
        $c->resolve( service => 'database|db_name/dbh' )->disconnect;
        $c->resolve( service => 'fixtures/db' )->drop;
    }
};

sub _test_lib_dirs {
    return 't/testlib';
}

__PACKAGE__->meta->make_immutable;

1;
