# Consul and Registrator with ACL server and agent

Docker image for the Consul client that receives settings from Consul KV

Create secret for dev file

```console
uuidgen > consul.token
# configuration
echo -n "http://127.0.0.0:8500/v1/kv/consul/nodes/config" > consul.url
```

######

the [docker-compose.yml](docker-compose.yml) file

```console
secrets:
    CONSUL_KV_URL:
        file: ./consul.url
    CONSUL_KV_TOKEN:
        file: ./consul.token
```

# Prod

**if exist secret, stop stack and `docker secret rm CONSUL_KV_TOKEN` **

##### Config client consul

Config that should be stored in http://127.0.0.0:8500/v1/kv/consul/nodes/config

```console
{
  "node_name": "node-1",
  "datacenter": "dc-test",
  "primary_datacenter": "dc-test",
  "data_dir": "/tmp/data",
  "server": false,
  "ui": false,
  "enable_script_checks": true,
  "acl": {
    "enabled": true,
    "default_policy": "deny",
    "tokens": {
      "agent": "YOUR_TOKEN"
    }
  },
  "log_level": "INFO",
  "domain": "consul",
  "client_addr": "0.0.0.0",
  "advertise_addr": "YOUR_IP",
  "ports": {
    "dns": 9600,
    "http": 9500,
    "https": -1,
    "serf_lan": 9301,
    "serf_wan": 9302,
    "server": 9300
  },
  "retry_join": [
    "YOUR_CLUSTER_IP"
  ]
}
```
