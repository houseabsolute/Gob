package Gob::DBICDumper;

use Gob::Moose;

use DBI 1.636;
use DBIx::Class::Helper::Row::ToJSON 2.033001   ();
use DBIx::Class::InflateColumn::Serializer 0.08 ();
use DBIx::Class::Schema::Loader 0.07045 qw( make_schema_at );
use DBIx::Class::TimeStamp 0.14 ();
use Gob::Types;
use MooseX::MarkAsMethods 0.13 ();
use MooseX::NonMoose 0.25      ();

with 'MooseX::Getopt::Dashes';

has dump_directory => (
    is      => 'ro',
    isa     => t('NonEmptySimpleStr'),
    default => './lib',
);

has debug => (
    is      => 'ro',
    isa     => t('Bool'),
    default => 0,
);

sub run ($self) {
    $self->_dump_database;
    system('tidyall -r lib/Gob/Schema');
    return 0;
}

sub _dump_database ( $self ) {
    my $schema = make_schema_at(
        'Gob::Schema::Gob',
        $self->_make_schema_args,
        ['dbi:Pg:database=Gob'],
    );
    $schema->storage->disconnect;
    return;
}

sub _make_schema_args ( $self ) {
    return {
        additional_classes => ['g'],
        components         => [
            'InflateColumn::DateTime',
            'InflateColumn::Serializer',
            'TimeStamp',
        ],
        custom_column_info => sub {
            if ( grep { $_[2]->{data_type} eq $_ } ( 'json', 'jsonb' ) ) {
                return { serializer_class => 'JSON' };
            }
        },
        debug                   => $self->debug,
        default_resultset_class => 'ResultSet',
        dump_directory          => $self->dump_directory,

        # We place format-skipping markers around the generated code so that
        # we don't mess with the checksum when tidying generated schema
        # files. This also currently requires pod generation to be switched
        # off, since PerlTidy inserts newlines in the Pod sections between the
        # format-skipping markers.
        filter_generated_code => sub {
            return "#<<<\n$_[2]#>>>";
        },
        generate_pod            => 0,
        naming                  => 'current',
        only_autoclean          => 1,
        overwrite_modifications => 0,
        quiet                   => 0,
        result_base_class       => 'Gob::Schema::Gob::Result',
        skip_load_external      => 1,
        use_moose               => 1,
        use_namespaces          => 1,
    };
}

__PACKAGE__->meta->make_immutable;

1;
