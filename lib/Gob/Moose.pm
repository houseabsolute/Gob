## no critic (Moose::RequireMakeImmutable)

package Gob::Moose;

use Import::Into;
use Moose ();
use Moose::Exporter;
use MooseX::SemiAffordanceAccessor ();
use MooseX::StrictConstructor      ();
use namespace::autoclean           ();

use g;

my ($import) = Moose::Exporter->setup_import_methods(
    install => [ 'unimport', 'init_meta' ],
    also    => ['Moose'],
);

sub import ( $class, @ ) {
    my $for_class = caller();

    $import->( undef, { into => $for_class } );

    MooseX::SemiAffordanceAccessor->import( { into => $for_class } );
    MooseX::StrictConstructor->import( { into => $for_class } );

    # Note that we need to use a level here rather than a classname so that
    # importing autodie works.
    my $level = 1;
    g->import::into($level);
    namespace::autoclean->import::into($level);

    return;
}

1;
