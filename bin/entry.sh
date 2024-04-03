#!/bin/sh

echo "Starting Consul... ${TYPE_SERVICE}"

if [ -z "${TYPE_SERVICE}" ]; then
  TYPE_SERVICE="agent"
fi

if [ "${TYPE_SERVICE}" = "server" ]; then
  cp /etc/consul.d/default.server.template /etc/consul.d/default.json
elif [ "${TYPE_SERVICE}" = "agent" ]; then
  cp /etc/consul.d/default.agent.template /etc/consul.d/default.json
fi

# CONSUL_HTTP_TOKEN_FILE not empty
if [ -n "${CONSUL_HTTP_TOKEN_FILE}" ]; then
  if [ -f "${CONSUL_HTTP_TOKEN_FILE}" ]; then
    CONSUL_HTTP_TOKEN=$(cat ${CONSUL_HTTP_TOKEN_FILE})
  else
    echo "CONSUL_HTTP_TOKEN_FILE not found"
    exit 1
  fi
else
  # if empty CONSUL_HTTP_TOKEN
  if [ -z "${CONSUL_HTTP_TOKEN}" ]; then
    echo "CONSUL_HTTP_TOKEN is empty. Please set it in .env file"
    exit 1
  fi
fi

echo "TYPE_SERVICE: ${TYPE_SERVICE}"

sed -i "s/%%CONSUL_HTTP_TOKEN%%/${CONSUL_HTTP_TOKEN}/g" "/etc/consul.d/default.json"

if [ "${TYPE_SERVICE}" = "server" ]; then

  # if empty SERVER_NODE_NAME
  if [ -z "${SERVER_NODE_NAME}" ]; then
    echo "SERVER_NODE_NAME is empty. Please set it in .env file"
    exit 1
  fi

  # if empty SERVER_ADVERTISE_ADDR
  if [ -z "${SERVER_ADVERTISE_ADDR}" ]; then
    echo "SERVER_ADVERTISE_ADDR is empty. Please set it in .env file"
    exit 1
  fi

  if [ -z "${BOOTSTRAP_EXPECT}" ]; then
    BOOTSTRAP_EXPECT=1
  fi

  sed -i "s/%%SERVER_NODE_NAME%%/${SERVER_NODE_NAME}/g" "/etc/consul.d/default.json"
  sed -i "s/%%SERVER_ADVERTISE_ADDR%%/${SERVER_ADVERTISE_ADDR}/g" "/etc/consul.d/default.json"
  sed -i "s/\"%%BOOTSTRAP_EXPECT%%\"/${BOOTSTRAP_EXPECT}/g" "/etc/consul.d/default.json"

  consul agent --config-file /etc/consul.d/default.json
elif [ "${TYPE_SERVICE}" = "agent" ]; then

  # if empty AGENT_NODE_NAME
  if [ -z "${AGENT_NODE_NAME}" ]; then
    echo "AGENT_NODE_NAME is empty. Please set it in .env file"
    exit 1
  fi

  # if empty AGENT_ADVERTISE_ADDR
  if [ -z "${AGENT_ADVERTISE_ADDR}" ]; then
    echo "AGENT_ADVERTISE_ADDR is empty. Please set it in .env file"
    exit 1
  fi

  # if empty JOIN_SERVER_IP
  if [ -z "${JOIN_SERVER_IP}" ]; then
    echo "JOIN_SERVER_IP is empty. Please set it in .env file"
    exit 1
  fi

  sed -i "s/%%AGENT_NODE_NAME%%/${AGENT_NODE_NAME}/g" "/etc/consul.d/default.json"
  sed -i "s/%%AGENT_ADVERTISE_ADDR%%/${AGENT_ADVERTISE_ADDR}/g" "/etc/consul.d/default.json"

  consul agent -join ${JOIN_SERVER_IP} --config-file /etc/consul.d/default.json
fi
