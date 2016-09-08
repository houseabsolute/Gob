package Gob::Container;

use Gob::Moose;

use Bread::Board;
use DBI;
use Gob::Types;
use Specio::Declare;

use g;

has _container => (
    is      => 'ro',
    isa     => object_isa_type('Bread::Board::Container'),
    lazy    => 1,
    builder => '_build_container',
);

has _db_name => (
    is      => 'ro',
    isa     => t('NonEmptySimpleStr'),
    lazy    => 1,
    builder => '_build_db_name',
);

has _database_container => (
    is      => 'ro',
    isa     => object_isa_type('Bread::Board::Container::Parameterized'),
    lazy    => 1,
    builder => '_build_database_container',
);

has _resolved => (
    traits => ['Hash'],
    is     => 'ro',
    isa    => t( 'HashRef', of => t('NonEmptyStr') ),
    lazy   => 1,
    default => sub { {} },
    handles => {
        created_service => 'exists',
    },
);

sub _build_db_name {'Gob'}

sub _build_container ($self) {
    my $db_name = $self->_db_name;
    my $db      = $self->_database_container->create(
        db_name => (
            container db_name => as {
                service name => $db_name;
            }
        )
    );

    return container master => as {
        container($db);
    };
}

sub _build_database_container ($self) {
    return container database => ['db_name'] => as {
        service name => (
            block => sub ($s) {
                $s->parent->get_sub_container('db_name')
                    ->resolve( service => 'name' );
            }
        );
        service host    => undef;
        service port    => undef;
        service sslmode => 'require';

        service dsn => (
            lifecycle    => 'Singleton',
            block        => \&_make_dsn,
            dependencies => [qw( name host port sslmode )],
        );

        service user     => undef;
        service password => undef;

        service dbh => (
            lifecycle    => 'Singleton',
            block        => \&_make_dbh,
            dependencies => [qw( dsn user password )],
        );
        service schema => (
            lifecycle    => 'Singleton',
            block        => \&_make_schema,
            dependencies => ['dbh'],
        );
    };
}

# We track which services we've resolved mostly for the benefit of the test
# suite, which wants to know if a test database was created so it can be torn
# down.
sub resolve ( $self, $type, $path ) {
    if ( $type eq 'service' ) {
        $self->_resolved->{$path} = 1;
    }

    return $self->_container->resolve( $type => $path );
}

# XXX - this stuff should probably be moved to another package eventually.
sub _make_dsn ($s) {
    my $dsn = 'dbi:Pg:dbname=' . $s->param('name');

    for my $p (qw( host port sslmode )) {
        if ( $s->param($p) ) {
            $dsn .= ";$p=" . $s->param($p);
        }
    }

    return $dsn;
}

sub _make_dbh ($s) {
    my $dbh = DBI->connect(
        $s->param('dsn'),
        $s->param('user'),
        $s->param('password'),
        {
            AutoCommit         => 0,
            RaiseError         => 1,
            ShowErrorStatement => 1,
        },
    );
    $dbh->{pg_enable_utf8} = 1;

    local $dbh->{AutoCommit} = 1;
    $dbh->do(q{SET client_encoding TO 'UTF8'});
    $dbh->do(q{SET timezone TO 'UTC'});

    return $dbh;
}

sub _make_schema ($s) {
    require Gob::Schema::Gob;

    return Gob::Schema::Gob->connect(
        sub { $s->param('dbh') },
        {
            quote_names => 1,
        },
    );
}

__PACKAGE__->meta->make_immutable;

1;
