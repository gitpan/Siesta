# $Id: Subscribe.pm 1175 2003-07-11 21:39:57Z richardc $
package Siesta::Plugin::Subscribe;
use strict;
use Siesta::Plugin;
use base 'Siesta::Plugin';

sub description {
    'A system plugin used for subscribing a member to the list';
}

sub process {
    my $self  = shift;
    my $mail  = shift;
    my $list  = $self->list;
    my $email = $mail->from;

    # check to see if they're already subbed
    if ( $list->is_member($email) ) {
        $mail->reply( body => Siesta->bake('subscribe_already',
                                           list    => $list,
                                           message => $mail) );
        return 1;
    }

    my $user = Siesta::Member->find_or_create({ email => $email });

    # add the user to the list and if that fails, send an error
    unless ( $list->add_member( $user ) ) {
        # mail them and reject them
        $mail->reply( body => Siesta->bake('subscribe_already',
                                           list    => $list,
                                           message => $mail) );
        return 1;
    }

    # mail the listowner and tell them that someone subbed
    $mail->reply( to   => $list->owner->email,
                  body => Siesta->bake('subscribe_notify',
                                       list    => $list,
                                       user    => $user,
                                       message => $mail )
                 );

    # mail the person and tell them that they've been subbed
    $mail->reply( body => Siesta->bake('subscribe_reply',
                                       list    => $list,
                                       message => $mail )
                 );
    return 1;
}


1;

