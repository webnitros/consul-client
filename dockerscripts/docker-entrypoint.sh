#!/bin/sh
#

##############################################
##############################################
######### Export
##############################################
##############################################

readFromSecret() {
  # Поддерживает чтение пути из секретов Docker, имя файла
  # относительно позиции /run/secrets/.
  local sp="$1"
  if [ -f "/run/secrets/$sp" ]; then
    sp="/run/secrets/$sp"
  fi
  if [ -f "$sp" ]; then
    credBuf=$(cat "$sp")
    echo "$credBuf" | awk '{$1=$1;print}' # Удаляем пробельные символы по краям строки
  fi
}

export_env_variables() {
  if [ -f "$1" ]; then
    while IFS='=' read -r key value; do
      # Игнорируем строки, начинающиеся с #
      if [[ "$key" =~ ^#.* ]]; then
        continue
      fi
      # Удаляем пробельные символы из значения переменной
      value=$(echo "$value" | awk '{$1=$1;print}')
      export "$key"="$value"
    done <"$1"
  else
    echo "Файл $1 не существует или не доступен для чтения."
  fi
}

# CONSUL_CONFIG_FILE is not empty
if [ -n "${CONSUL_CONFIG_FILE}" ]; then

  # and if file exists
  # Пример использования:
  secret_value=$(readFromSecret "${CONSUL_CONFIG_FILE}")

  if [ -n "$secret_value" ]; then
    source <(echo "$secret_value")
    #echo "Значение секрета: $secret_value"
  else
    echo "Секрет не найден или не удалось прочитать его."
  fi

fi

##############################################
##############################################
##############################################
##############################################
if [ -z "${TYPE_SERVICE}" ]; then
  TYPE_SERVICE="agent"
fi

echo "Starting Consul... ${TYPE_SERVICE}"
echo "AGENT_ADVERTISE_ADDR... ${AGENT_ADVERTISE_ADDR}"


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

mkdir -p /etc/consul.d/

cp /template/${TYPE_SERVICE}/consul.json /etc/consul.d/default.json

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


  echo "JOIN_SERVER_IP... ${JOIN_SERVER_IP}"

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
