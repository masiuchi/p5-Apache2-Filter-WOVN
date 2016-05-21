package Apache2::Filter::WOVN::OutputFilter;

use strict;
use warnings;

use Apache2::Filter ();
use Apache2::Const -compile => qw( DECLINED );

use Plack::Middleware::WOVN;

use Apache2::Filter::WOVN;

use constant BUFF_LEN => 1024;

sub handler {
    my $f = shift;

    if ( lc( $f->r->content_type ) !~ /html/ || $f->r->status =~ /^1|302/ ) {
        return Apache2::Const::DECLINED;
    }

    unless ( $f->ctx ) {
        $f->r->headers_out->unset('Content-Length');
        $f->ctx(1);
    }

    my $values
        = $Apache2::Filter::WOVN::STORE->get_values(
        $Apache2::Filter::WOVN::HEADERS->redis_url );
    my $url = +{
        protocol => $Apache2::Filter::WOVN::HEADERS->protocol,
        host     => $Apache2::Filter::WOVN::HEADERS->host,
        pathname => $Apache2::Filter::WOVN::HEADERS->pathname,
    };

    my $body = '';
    while ( $f->read( my $buffer, BUFF_LEN ) ) {
        $body .= $buffer;
    }

    $Plack::Middleware::WOVN::STORE = $Apache2::Filter::WOVN::STORE;
    $body = Plack::Middleware::WOVN::switch_lang( $body, $values, $url,
        $Apache2::Filter::WOVN::LANG, $Apache2::Filter::WOVN::HEADERS );

    $f->print($body);
    return Apache2::Const::DECLINED;
}

1;

