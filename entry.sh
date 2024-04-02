#!/bin/sh

cp /etc/consul.d/default.template /etc/consul.d/default.json

sed -i "s/%%CONSUL_HTTP_TOKEN%%/${CONSUL_HTTP_TOKEN}/g" "/etc/consul.d/default.json"

consul agent --config-file /etc/consul.d/default.json
