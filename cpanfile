requires 'autodie'                        => '2.29';
requires 'Import::Into'                   => '1.002005';
requires 'indirect'                       => '0.37';
requires 'Moose'                          => '2.1805';
requires 'MooseX::MarkAsMethods'          => '0.13';
requires 'MooseX::NonMoose'               => '0.25';
requires 'MooseX::SemiAffordanceAccessor' => '0.10';
requires 'MooseX::StrictConstructor'      => '0.19';
requires 'multidimensional'               => '0.012';
requires 'namespace::autoclean'           => '0.28';
requires 'Specio'                         => '0.24';

on develop => sub {
    requires 'DBIx::Class::Helper::Row::ToJSON'       => '2.033001';
    requires 'DBIx::Class::InflateColumn::Serializer' => '0.08';
    requires 'DBIx::Class::Schema::Loader'            => '0.07045';
    requires 'DBIx::Class::TimeStamp'                 => '0.14';
};
