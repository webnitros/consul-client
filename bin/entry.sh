#!/bin/sh

cp /etc/consul.d/default.template /etc/consul.d/default.json

sed -i "s/%%CONSUL_HTTP_TOKEN%%/${CONSUL_HTTP_TOKEN}/g" "/etc/consul.d/default.json"
sed -i "s/%%DATACENTER%%/${DATACENTER}/g" "/etc/consul.d/default.json"
sed -i "s/%%AGENT_NODE_NAME%%/${AGENT_NODE_NAME}/g" "/etc/consul.d/default.json"
sed -i "s/%%AGENT_ADVERTISE_ADDR%%/${AGENT_ADVERTISE_ADDR}/g" "/etc/consul.d/default.json"
sed -i "s/%%SERVER_NODE_NAME%%/${SERVER_NODE_NAME}/g" "/etc/consul.d/default.json"
sed -i "s/%%SERVER_ADVERTISE_ADDR%%/${SERVER_ADVERTISE_ADDR}/g" "/etc/consul.d/default.json"

if [ "${TYPE_SERVICE}" = "server" ]; then
  consul agent --config-file /etc/consul.d/default.json
elif [ "${TYPE_SERVICE}" = "agent" ]; then
  consul agent -server -bootstrap-expect=1 --config-file /etc/consul.d/default.json
fi
