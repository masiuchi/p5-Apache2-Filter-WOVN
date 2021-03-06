package Apache2::Filter::WOVN::PostConfig;

use strict;
use warnings;

use Apache2::ServerRec  ();
use Apache2::ServerUtil ();
use Apache2::Const -compile => qw( OK );

use Plack::Middleware::WOVN::Store;

use Apache2::Filter::WOVN;

sub handler {
    my ( $conf_pool, $log_pool, $temp_pool, $s ) = @_;

    if ($Apache2::Filter::WOVN::Store) {
        return Apache2::Const::OK;
    }

    my $user_token   = $s->dir_config('wovn_user_token');
    my $secret_key   = $s->dir_config('wovn_secret_key');
    my $url_pattern  = $s->dir_config('wovn_url_pattern');
    my $default_lang = $s->dir_config('wovn_default_lang');

    my $settings = +{
        user_token => $user_token,
        secret_key => $secret_key,
        $url_pattern  ? ( url_pattern  => $url_pattern )  : (),
        $default_lang ? ( default_lang => $default_lang ) : (),
    };

    $Apache2::Filter::WOVN::STORE
        = Plack::Middleware::WOVN::Store->new( { settings => $settings } );

    return Apache2::Const::OK;
}

1;

