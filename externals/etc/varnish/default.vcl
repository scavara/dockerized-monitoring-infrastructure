# VCL configuration for OpenTSDB.
# based on
# http://opentsdb.net/docs/build/html/user_guide/utilities/varnish.html
# https://groups.google.com/forum/#!topic/opentsdb/vCHjJhcvvbk
vcl 4.0;
import std;
import directors;
#
backend foo {
    .host = "127.0.0.1";
    .port = "4242";
    .probe = {
        .url = "/version";
        .interval = 30s;
        .timeout = 10s;
        .window = 5;
        .threshold = 3;
    }
}

backend bar {
    .host = "127.0.0.1";
    .port = "24242";
    .probe = {
        .url = "/version";
        .interval = 30s;
        .timeout = 10s;
        .window = 5;
        .threshold = 3;
    }
}
sub vcl_init {
    new tsd = directors.round_robin();
    tsd.add_backend(foo);
    tsd.add_backend(bar);
}

sub vcl_recv {
    #set req.backend_hint = tsd.backend();
    # Make sure we hit the same backend based on the URL requested,
    # but ignore some parameters before hashing the URL.
    #set req.backend_hint = tsd.backend(regsuball(req.url, "&(o|ignore|png|json|html|y2?range|y2?label|y2?log|key|nokey)\b(=[^&]*)?", ""));
    set req.backend_hint = tsd.backend();
    set client.identity = regsuball(req.url, "&(o|ignore|png|json|html|y2?range|y2?label|y2?log|key|nokey)\b(=[^&]*)?", "");
}

sub vcl_hash {
    # Remove the `ignore' parameter from the URL we hash, so that two
    # identical requests modulo that parameter will hit Varnish's cache.
    hash_data(regsuball(req.url, "&ignore\b(=[^&]*)?", ""));
    if (req.http.host) {
        hash_data(req.http.host);
    } else {
        hash_data(server.ip);
    }

    return (lookup);
}

