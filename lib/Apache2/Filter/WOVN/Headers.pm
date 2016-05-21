package Apache2::Filter::WOVN::Headers;

use strict;
use warnings;
use utf8;
use v5.10;

use parent qw( Plack::Middleware::WOVN::Headers );

use Plack::Middleware::WOVN::Lang;

__PACKAGE__->mk_accessors(qw/ req /);

sub new {
    my $class = shift;
    my ( $req, $settings ) = @_;

    my $self = bless +{
        req      => $req,
        settings => $settings,
        },
        __PACKAGE__;

    if ( $req->subprocess_env('https') ) {
        $self->protocol('https');
    }
    else {
        $self->protocol('http');
    }

    $self->unmasked_host( $req->hostname );

    unless ( $req->uri ) {
        my $req_uri = join '',
            (
            ( $req->path_info || '' ) =~ /^[^\/]/ ? '/' : '',
            $req->path_info, length $req->args ? '?' . $req->args : '',
            );
        $req->uri($req_uri);
    }
    if ( $req->uri =~ /:\/\// ) {
        $req->uri =~ s/^.*:\/\/[^\/]+//;
    }

    my ($unmasked_pathname) = split /\?/, $req->uri;
    $unmasked_pathname .= '/'
        unless $unmasked_pathname =~ /\/$/
        || $unmasked_pathname =~ /\/[^\/.]+\.[^\/.]+$/;
    $self->unmasked_pathname($unmasked_pathname);

    $self->unmasked_url( $self->protocol . '://'
            . $self->unmasked_host
            . $self->unmasked_pathname );

    if ( $settings->{url_pattern} eq 'subdomain' ) {
        $self->host(
            $self->remove_lang( $self->unmasked_host, $self->lang_code ) );
    }
    else {
        $self->host( $self->unmasked_host );
    }

    my ( $pathname, $query ) = split /\?/, $req->uri;
    if ( $settings->{url_pattern} eq 'path' ) {
        $self->pathname( $self->remove_lang( $pathname, $self->lang_code ) );
    }
    else {
        $self->pathname($pathname);
    }
    $self->query( $query || '' );

    my $url = join '',
        (
        $self->host, $self->pathname,
        length $self->query ? '?' : '',
        $self->remove_lang( $self->query, $self->lang_code ),
        );
    $self->url($url);

    if ( @{ $settings->{query} || [] } ) {
        my @query_vals;
        for my $qv ( @{ $settings->{query} } ) {
            my $reg = "(^|&)(?<query_val>" . $qv . "[^&]+)(&|$)/";
            if ( $self->query =~ /$reg/ && $+{query_val} ) {
                push @query_vals, $+{query_val};
            }
        }
        if (@query_vals) {
            $self->query( join '&', sort(@query_vals) );
        }
        else {
            $self->query('');
        }
    }
    else {
        $self->query('');
    }
    $self->query( $self->remove_lang( $self->query, $self->lang_code ) );

    $pathname = $self->pathname;
    $pathname =~ s/\/+$//;
    $self->pathname($pathname);

    $self->redis_url( $self->host . $self->pathname . $self->query );

    $self;
}

sub path_lang {
    my $self = shift;

    if ( $self->{path_lang} ) {
        return $self->{path_lang};
    }

    my $url = $self->req->hostname . $self->req->uri;
    my $reg = $self->settings->{url_pattern_reg};
    if (   $url =~ /$reg/
        && $+{lang}
        && Plack::Middleware::WOVN::Lang->get_lang( $+{lang} ) )
    {
        $self->{path_lang}
            = Plack::Middleware::WOVN::Lang->get_code( $+{lang} );
    }
    else {
        $self->{path_lang} = '';
    }

    $self->{path_lang};
}

sub browser_lang {
    my $self = shift;

    if ( $self->{browser_lang} ) {
        return $self->{browser_lang};
    }

    if ( ( $ENV{HTTP_COOKIE} || '' )
        =~ /wovn_selected_lang\s*=\s*(?<lang>[^;\s]+)/ )
    {
        $self->{browser_lang} = $+{lang};
    }
    else {
        $self->{browser_lang} = '';
    }

    $self->{browser_lang};
}

sub request_out {
    my ( $self, $def_lang ) = @_;

    unless ( defined $def_lang ) {
        $def_lang = $self->settings->{default_lang};
    }

    my $req = $self->req;

    if ( $self->settings->{url_pattern} eq 'query' ) {
        if ( $req->uri ) {
            $req->uri( $self->remove_lang( $req->uri ) );
        }
        if ( $req->args ) {
            $req->args( $self->remove_lang( $req->args ) );
        }
    }
    elsif ( $self->settings->{url_pattern} eq 'subdomain' ) {
        if ( $req->hostname ) {
            $req->hostname( $self->remove_lang( $req->hostname ) );
        }
    }
    else {
        if ( $req->uri ) {
            $req->uri( $self->remove_lang( $req->uri ) );
        }
        if ( $req->path_info ) {
            $req->path_info( $self->remove_lang( $req->path_info ) );
        }
    }
}

1;

