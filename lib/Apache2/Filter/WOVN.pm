package Apache2::Filter::WOVN;

use strict;
use warnings;

our $VERSION = '0.01';

our ( $STORE, $HEADERS, $LANG );

1;
__END__

=encoding utf-8

=head1 NAME

Apache2::Filter::WOVN - Translates output of Apache HTTP server by mod_perl2 and WOVN.io.

=head1 SYNOPSIS

  PerlPostConfigHandler   Apache2::Filter::WOVN::PostConfig
  PerlTransHandler        Apache2::Filter::WOVN::Trans
  PerlOutputFilterHandler Apache2::Filter::WOVN::OutputFilter

  PerlSetVar wovn_user_token   IRb6-
  PerlSetVar wovn_secret_key   secret
  PerlSetVar wovn_url_pattern  path
  PerlSetVar wovn_default_lang ja

  # PerlSwitches -I/home/username/p5-Apache2-Filter-WOVN/lib

=head1 DESCRIPTION

Apache2::Filter::WOVN is ...

=head1 LICENSE

Copyright (C) Masahiro Iuchi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Masahiro Iuchi E<lt>masahiro.iuchi@gmail.comE<gt>

=cut

