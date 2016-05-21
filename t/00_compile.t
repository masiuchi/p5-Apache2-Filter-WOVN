use strict;
use Test::More 0.98;

use_ok $_ for qw(
    Apache2::Filter::WOVN
    Apache2::Filter::WOVN::Headers
    Apache2::Filter::WOVN::OutputFilter
    Apache2::Filter::WOVN::PostConfig
    Apache2::Filter::WOVN::Trans
);

done_testing;

