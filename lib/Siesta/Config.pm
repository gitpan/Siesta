# $Id: Config.pm.in 1254 2003-07-24 10:42:13Z richardc $
package Siesta::Config;
use strict;
use vars qw( $CONFIG_FILE $ROOT $MESSAGES @STORAGE $ARCHIVE $LOG_PATH $LOG_LEVEL );

=head2 C<$ROOT>

Where to install everything to

=cut

BEGIN {
    use AppConfig qw(:expand :argcount);

    $ROOT = '/usr/local/siesta';
    $CONFIG_FILE = '/usr/local/siesta/siesta.conf' unless defined $CONFIG_FILE;

    my $config = AppConfig->new({
            GLOBAL => {
                ARGCOUNT => ARGCOUNT_ONE,
                EXPAND => EXPAND_ALL,
            },
        },

        root => {
            DEFAULT => '/usr/local/siesta',
        },
        messages => {
            DEFAULT => '/usr/local/siesta/messages',
        },
        archive => {
            DEFAULT => '/usr/local/siesta/archive',
        },
        log_path => {
            DEFAULT => '/usr/local/siesta/error',
        },
        log_level => {
            DEFAULT => 3,
        },
        storage_dsn => {
            DEFAULT => 'dbi:SQLite:/usr/local/siesta/database',
        },
        storage_user => {
            DEFAULT => 'root',
        },
        storage_pass => {
            DEFAULT => undef,
        },
    );

    $config->file($CONFIG_FILE);

    @STORAGE   = ($config->get('storage_dsn'),
                  $config->get('storage_user'),
                  $config->get('storage_pass')),
    $MESSAGES  = $config->get('messages');
    $ARCHIVE   = $config->get('archive');
    $LOG_PATH  = $config->get('log_path');
    $LOG_LEVEL = $config->get('log_level');
}

1;
