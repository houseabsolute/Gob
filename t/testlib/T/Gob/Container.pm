package T::Gob::Container;

use H::Test::Class::Moose;

sub test_db ( $self, @ ) {
    my $c    = $T::C;
    my $name = $c->resolve( service => 'database|db_name/name' );
    my $pid  = $$;

    like(
        $name,
        qr/^Gob_\Q$pid\E_\d+$/,
        'db name includes pid and time'
    );

    is(
        $c->resolve( service => 'database|db_name/dsn' ),
        "dbi:Pg:dbname=$name;sslmode=require",
        'got expected dsn'
    );

    isa_ok(
        $c->resolve( service => 'fixtures/f' ),
        'H::Fixtures',
    );
}

__PACKAGE__->meta->make_immutable;

1;
