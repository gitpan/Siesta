use strict;
package Siesta::Web;
use Apache::Constants qw( :common );
use Template;
use Apache::Session::SharedMem;
use Siesta;
use CGI;

use constant Cookie => 'siesta_session';

=head1 SYNOPSIS

 PerlModule          Siesta::Web
 <Files *.tt2>
     SetHandler      perl-script
     PerlHandler     Siesta::Web
 </Files>

=cut

my $tt;
sub handler {
    my $r = shift;

    my $file = $r->filename;
    $file =~ /\.tt2$/ or return DECLINED;

    my $cgi = CGI->new;
    my $session_id = $cgi->cookie( Cookie );
    tie my %session, 'Apache::Session::SharedMem', $session_id,
      +{ expires_in => 60 * 60 }; # 1 hour

    my @headers;
    push @headers, [ 'Set-Cookie' =>
                       $cgi->cookie(-name  => Cookie,
                                    -value => $session{_session_id}) ]
      unless $session_id;

    my $params = {
        set_header => sub { push @headers, @_; return },
        uri        => $r->uri,
        cgi        => $cgi,
        session    => \%session,
    };

    $tt ||= Template->new(
        ABSOLUTE     => 1,
        INCLUDE_PATH => join (':',
                              '/home/richardc/siesta-trunk/siesta/web-frontend/siesta',
                              '/home/richardc/siesta-trunk/siesta/web-frontend/lib' ),
       );

    my $out;
    $tt->process($file, $params, \$out)
      or do {
          $r->log_reason( $tt->error );
          return SERVER_ERROR;
      };

    $r->header_out( @$_ ) for @headers;
    $r->content_type('text/html');
    $r->send_http_header;
    $r->print( $out );

    return OK;
}

1;
