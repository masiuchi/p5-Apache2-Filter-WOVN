package Apache2::Filter::WOVN::Trans;

use strict;
use warnings;

use Apache2::RequestRec ();
use Apache2::Const -compile => qw(HTTP_TEMPORARY_REDIRECT DECLINED);
use APR::Table ();

use Apache2::Filter::WOVN;
use Apache2::Filter::WOVN::Headers;

sub handler {
    my $r = shift;

    $Apache2::Filter::WOVN::HEADERS
        = Apache2::Filter::WOVN::Headers->new( $r,
        $Apache2::Filter::WOVN::STORE->settings );

    if ( $Apache2::Filter::WOVN::HEADERS->path_lang eq
        $Apache2::Filter::WOVN::STORE->settings->{default_lang} )
    {
        $r->headers_out->set(
            Location => $Apache2::Filter::WOVN::HEADERS->redirect_location(
                $Apache2::Filter::WOVN::HEADERS->path_lang
            )
        );
        return Apache2::Const::HTTP_TEMPORARY_REDIRECT;
    }

    $Apache2::Filter::WOVN::LANG = $Apache2::Filter::WOVN::HEADERS->lang_code;

    $Apache2::Filter::WOVN::HEADERS->request_out;

    return Apache2::Const::DECLINED;
}

1;

