requires 'autodie'                                => '2.29';
requires 'DBIx::Class'                            => '0.082840';
requires 'DBIx::Class::Helper::Row::ToJSON'       => '2.033001';
requires 'DBIx::Class::InflateColumn::Serializer' => '0.08';
requires 'DBIx::Class::TimeStamp'                 => '0.14';
requires 'File::pushd'                            => '1.009';
requires 'Import::Into'                           => '1.002005';
requires 'indirect'                               => '0.37';
requires 'Moose'                                  => '2.1805';
requires 'MooseX::Getopt'                         => '0.71';
requires 'MooseX::MarkAsMethods'                  => '0.13';
requires 'MooseX::NonMoose'                       => '0.25';
requires 'MooseX::SemiAffordanceAccessor'         => '0.10';
requires 'MooseX::StrictConstructor'              => '0.19';
requires 'multidimensional'                       => '0.012';
requires 'namespace::autoclean'                   => '0.28';
requires 'Path::Tiny'                             => '0.096';
requires 'Specio'                                 => '0.25';

on test => sub {
    requires 'Test2::Suite'       => '0.000058';
    requires 'Test::Class::Moose' => '0.78';
};

on develop => sub {
    requires 'App::Sqitch'                 => '0.9995';
    requires 'DBIx::Class::Schema::Loader' => '0.07045';
    requires 'Pg::CLI'                     => '0.11';
};
