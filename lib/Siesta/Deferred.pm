use strict;
package Siesta::Deferred;
use base qw( Siesta::DBI );

__PACKAGE__->set_up_table('deferred');
__PACKAGE__->has_a(who     => 'Siesta::Member' );
__PACKAGE__->has_a(message => 'Siesta::Message',
                   deflate => 'as_string',
                  );

1;
