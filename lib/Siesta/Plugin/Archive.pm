# $Id: Archive.pm 989 2003-05-29 19:37:33Z richardc $
package Siesta::Plugin::Archive;
use strict;
use Siesta::Config;
use Siesta::Plugin;
use base 'Siesta::Plugin';
use Email::LocalDelivery;

sub description {
    "save messages to maildirs";
}

sub process {
    my $self = shift;
    my $mail = shift;

    my $name = $self->list->name;
    my $path = "$Siesta::Config::ARCHIVE/$name/";
    Email::LocalDelivery->deliver( $mail->as_string, $path )
        or die "local delivery into '$path' failed";
    return;
}

1;
