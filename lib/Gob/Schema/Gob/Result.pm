package Gob::Schema::Gob::Result;

use g;
use namespace::autoclean;

use Moose;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components('Helper::Row::ToJSON');

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
