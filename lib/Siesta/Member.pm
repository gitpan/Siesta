# $Id: Member.pm 1214 2003-07-20 11:34:10Z simon $
package Siesta::Member;
use strict;
use Siesta::DBI;
use base 'Siesta::DBI';
__PACKAGE__->set_up_table( 'member' );
__PACKAGE__->load_alias('email');
__PACKAGE__->has_many( lists => [ 'Siesta::Subscription' => 'list' ] );
__PACKAGE__->has_many( prefs => 'Siesta::Pref' );

# fuck the users, fuck them up their stupid asses

=head1 NAME

Siesta::Member - manipulate a member.

=head1 METHODS

=head2 ->id

get and set their id.

=head2 ->email

get and set their email address.

=head2 ->config

get and set config values for this Member.

=head2 ->lists

all the lists this member is subbed to.

=cut

1;
