## -*- mode: perl; coding: utf-8 -*-

requires 'perl', '5.010';

requires 'Apache2::Const';
requires 'Apache2::Filter';
requires 'Apache2::ServerRec';
requires 'Apache2::ServerUtil';
requires 'APR::Table';

requires 'Plack::Middleware::WOVN';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

