package Gob::Types;

use g;

use parent 'Specio::Exporter';

use Specio::Declare;
use Specio::Library::Builtins -reexport;
use Specio::Library::Numeric -reexport;
use Specio::Library::Perl -reexport;
use Specio::Library::String -reexport;

declare(
    'MethodName',
    parent => t('Str'),
    inline => sub {
        return
            sprintf( <<'EOF', $_[0]->parent->inline_check( $_[1] ), $_[1] );
do {
    no warnings 'experimental::regex_sets';
    %s && %s =~ /
                 ^
                 (?[ ( \p{Word} & \p{XID_Start} ) + [_] ])
                 (?[ ( \p{Word} & \p{XID_Continue} ) ])*
                 $
                /x;
    }
EOF
    },
);

1;
