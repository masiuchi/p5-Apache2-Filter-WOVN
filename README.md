# NAME

Apache::Filter2::WOVN - Translates output of Apache HTTP server by mod\_perl2 and WOVN.io.

# SYNOPSIS

    PerlPostConfigHandler   Apache2::Filter::WOVN::PostConfig
    PerlTransHandler        Apache2::Filter::WOVN::Trans
    PerlOutputFilterHandler Apache2::Filter::WOVN::OutputFilter

    PerlSetVar wovn_user_token  IRb6-
    PerlSetVar wovn_secret_key  secret
    PerlSetVar wovn_url_pattern path

    # PerlSwitches -I/home/username/p5-Apache2-Filter-WOVN/lib

# DESCRIPTION

Apache2::Filter::WOVN is ...

# LICENSE

Copyright (C) Masahiro Iuchi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Masahiro Iuchi &lt;masahiro.iuchi@gmail.com>
