#<<<
use utf8;
package Gob::Schema::Gob::Result::Application;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'Gob::Schema::Gob::Result';
use g;
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "InflateColumn::Serializer",
  "TimeStamp",
);
__PACKAGE__->table("application");
__PACKAGE__->add_columns(
  "user_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "posting_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "cover_letter",
  { data_type => "text", is_nullable => 0 },
  "resume",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "created_at",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
  "last_updated_at",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);
__PACKAGE__->belongs_to(
  "posting",
  "Gob::Schema::Gob::Result::Posting",
  { posting_id => "posting_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);
__PACKAGE__->belongs_to(
  "user",
  "Gob::Schema::Gob::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);
#>>>

# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-03 11:23:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uV3O8J2deIx83EX++MSwTg

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
