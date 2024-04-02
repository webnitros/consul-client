# Consul - сервер и агент

Для соединения сервера и агента используется механизм авторизации acl.

```shell
cp -f .env.example .env
```

# Переменные окружения

| Переменная            | Описание                                   | Пример                                                                                                      |
|-----------------------|--------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| CONSUL_HTTP_TOKEN     | Токен для доступа к Consul API             | [https://generate-random.org/api-token-generator?count=1&length=64&type=upper-letters&prefix=  ](генератор) |
| LEADER_SERVER_IP      | IP-адрес сервера, который является лидером |                                                                                                             |
| DATACENTER            | Название датацентра                        | test-dc                                                                                                     |
| SERVER_NODE_NAME      | Имя сервера                                | consul-server-1                                                                                             |
| SERVER_ADVERTISE_ADDR | IP-адрес сервера                           |                                                                                                             |
| AGENT_NODE_NAME       | Имя агента                                 | consul-agent-1                                                                                              |
| AGENT_ADVERTISE_ADDR  | IP-адрес агента                            |                                                                                                             |
