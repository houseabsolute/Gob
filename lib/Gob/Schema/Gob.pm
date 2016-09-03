#<<<
use utf8;
package Gob::Schema::Gob;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces(
    default_resultset_class => "ResultSet",
);
#>>>

# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-03 11:23:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kNdPBQtvg1hvOd9FO97sIg

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
1;
