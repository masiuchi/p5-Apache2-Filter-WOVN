# NAME

Apache2::Filter::WOVN - Translates output of Apache HTTP server by mod_perl2 and WOVN.io.

# SYNOPSYS

```
PerlPostConfigHandler   MyApache2::PostConfig
PerlTransHandler        MyApache2::Trans
PerlOutputFilterHandler MyApache2::OutputFilter

PerlSetVar wovn_user_token  IRb6-
PerlSetVar wovn_secret_key  secret
PerlSetVar wovn_url_pattern path
```
