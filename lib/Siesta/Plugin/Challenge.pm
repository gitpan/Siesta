package Siesta::Plugin::Challenge;
use strict;
use Siesta::Plugin;
use base 'Siesta::Plugin';

# suggested usage  set_plugins( subscribe => qw( Challenge Subscribe ) );
#                  set_plugins( resume    => qw( Resume ) );

sub description {
    'defer a message and send a challenge';
}

sub process {
    my $self = shift;
    my $mail = shift;

    my $newmember = 0;     # is this a new member
    my $member = Siesta::Member->load( $mail->from );
    unless ($member) {
        $member = Siesta::Member->create({ email    => $mail->from,
                                           password => 'XXX_autogenerate_me' });
        $newmember = 1;
    }

    my $deferred = $mail->defer( who => $member, why => "challenge" );
    $mail->reply(
        from => $self->list->address( 'resume' ),
        body => Siesta->bake( "challenge",
                              deferred  => $deferred,
                              newmember => $newmember,
                             ),
       );
    return 1;
}


1;
