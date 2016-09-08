package H::Test::Class::Moose::Config;

use Gob::Moose;

use H::Container;
use Specio::Declare;

extends 'Test::Class::Moose::Config';

# All of this class's attributes will be passed to each test class as it is
# constructed by the TCM class execution code.
has container => (
    is       => 'ro',
    isa      => object_isa_type('H::Container'),
    required => 1,
);

__PACKAGE__->meta->make_immutable;

1;
