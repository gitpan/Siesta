# $Id: MembersOnly.pm 1229 2003-07-21 13:55:40Z richardc $
package Siesta::Plugin::MembersOnly;
use strict;
use Siesta::Plugin;
use base 'Siesta::Plugin';

sub description {
    "reject non-member posts";
}

sub process {
    my $self = shift;
    my $mail = shift;
    my $list = $self->list;

    return if $list->is_member( $mail->from );

    # I'm not even supposed to be here today.
    my $extra = '';
    if ($self->pref('approve')) {
        $extra = "\nYour message is now held in an approval queue.";
        my $id = $mail->defer(
            why => "non member post requires approval",
            who => $list->owner);
        $mail->reply( to      => $list->owner->email,
                      from    => $list->return_path,
                      subject => "deferred message",
                      body    => Siesta->bake('members_only_approve',
                                              list     => $list,
                                              mail     => $mail,
                                              deferred => $id),
                     );
    }
    else {
        $mail->reply( to   => $list->owner->email,
                      from => $list->return_path,
                      body => Siesta->bake('members_only_dropped',
                                           list => $list,
                                           mail => $mail)
                    );
    }

    return 1 unless $self->pref('tell_user');

    $mail->reply( from => $list->return_path,
                  body => Siesta->bake('members_only_held',
                                       extra => $extra ) );

    return 1;
}

sub options {
    +{
      'approve'
      => {
          description => "should we hold non-member posts for approval",
          type        => "boolean",
          default     => 1,
         },
      'tell_user'
      => {
          description => "should we tell the user if their post is rejected/delayed",
          type        => "boolean",
          default     => 0,
         },
     };
}

1;
