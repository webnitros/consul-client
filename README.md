# Consul and Registrator with ACL server and agent

```console
cp config/consul.json.template config/consul.json
```

**Configure**

Replace the `YOUR_CONSUL_AGENT_TOKEN` and `YOUR_NODE_IP`, and `ADD_NODE_IP` in the [config/consul.json](config/consul.json) file.

Set token `CONSUL_HTTP_TOKEN` or secret file `CONSUL_HTTP_TOKEN_FILE` in the [docker-compose.yml](docker-compose.yml) file.

## Docker swarm deploy

```shell
docker stack deploy -c docker-compose.yml consul-agent
docker stack rm consul-agent
```
