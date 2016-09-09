package H::Fixtures::DB;

use Gob::Moose;

use File::pushd qw( pushd );
use Gob::Types;
use IPC::Run3 qw( run3 );
use Path::Tiny;
use Pg::CLI::createdb;
use Pg::CLI::dropdb;
use Pg::CLI::psql;
use Specio::Declare;
use Test2::Tools::Basic qw( diag fail );

has checkout_root_dir => (
    is       => 'ro',
    isa      => object_isa_type('Path::Tiny'),
    required => 1,
);

has name => (
    is       => 'ro',
    isa      => t('NonEmptySimpleStr'),
    required => 1,
);

has [qw( user password host )] => (
    is       => 'ro',
    isa      => union( of => [ t('Undef'), t('NonEmptySimpleStr') ] ),
    required => 1,
);

has port => (
    is       => 'ro',
    isa      => union( of => [ t('Undef'), t('PositiveOrZeroInt') ] ),
    required => 1,
);

sub BUILD ( $self, @ ) {
    return if $self->_db_exists;

    diag( 'Creating a test database named ' . $self->name );

    my $stderr;
    Pg::CLI::createdb->new( $self->_pg_cli_args )->run(
        database => $self->name,
        stdout   => \&_chomp_diag,
        stderr   => \$stderr,
    );
    if ($stderr) {
        fail( 'createdb ' . $self->name );
        diag($stderr);
    }

    my $pushed = pushd( $self->checkout_root_dir->child('schema') );

    my $uri = 'db:pg://';
    $uri .= $self->user           if $self->user;
    $uri .= ':' . $self->password if $self->password;
    $uri .= '@' . $self->host     if $self->host;
    $uri .= ':' . $self->port if $self->host && $self->port;
    $uri .= '/' . $self->name;

    diag('Running sqitch');

    my @commands = (
        [ qw( sqitch --quiet deploy --target ), $uri ],
        [ qw( sqitch --quiet verify --target ), $uri ],
    );
    for my $c (@commands) {
        run3(
            $c,
            undef,
            \&_chomp_diag,
            \$stderr,
        );
        if ($stderr) {
            fail( join q{ }, $c->@* );
            diag($stderr);
        }
    }

    return;
}

sub _db_exists ($self) {
    my $stdout;
    my $stderr;
    Pg::CLI::psql->new( $self->_pg_cli_args )->run(
        database => 'template1',
        options  => [
            '-t', '-c',
            sprintf(
                q{SELECT 1 AS result FROM pg_database WHERE datname = '%s'},
                $self->name
            ),
        ],
        stdout => \$stdout,
        stderr => \$stderr,
    );

    if ($stderr) {
        fail('psql to check if database exists');
        diag($stderr);
    }

    return $stdout =~ /1/;
}

sub drop ( $self, @ ) {
    diag( 'Dropping a test database named ' . $self->name );

    my $stderr;
    Pg::CLI::dropdb->new( $self->_pg_cli_args )->run(
        database => $self->name,
        stdout   => \&_chomp_diag,
        stderr   => \$stderr,
    );

    if ($stderr) {
        fail( 'dropdb ' . $self->name );
        diag($stderr);

        Pg::CLI::psql->new( $self->_pg_cli_args )->run(
            database => 'template1',
            options  => [
                '-c',
                sprintf(
                    q{SELECT * FROM pg_stat_activity WHERE datname = '%s'},
                    $self->name
                ),
            ],
            stdout => \&_chomp_diag,
            stderr => \&_chomp_diag,
        );
    }

    return;
}

sub _pg_cli_args ($self) {
    return
        map { defined $self->$_ ? ( $_ => $self->$_ ) : () }
        qw( user password host port );
}

sub _chomp_diag {
    for (@_) {
        chomp;
        diag($_);
    }
}

__PACKAGE__->meta->make_immutable;

1;
