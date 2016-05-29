## -*- mode: perl; coding: utf-8 -*-

requires 'perl', '5.010';
requires 'mod_perl2';
requires 'Plack::Middleware::WOVN';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

