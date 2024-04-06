# Consul and Registrator with ACL server and agent

Docker image for the Consul client that receives settings from Consul KV

**Configure**

| Variable             | Description          | Example                                         |
|----------------------|----------------------|-------------------------------------------------|
| CONSUL_KV            | Enable consul kv     | (on\off)                                        |
| CONSUL_KV_URL        | Consul kv url        | http://127.0.0.0:8500/v1/kv/consul/nodes/config |
| CONSUL_KV_TOKEN      | Consul kv token      | 20043832-4307-4BF5-8848-F728172085B8            |
| CONSUL_KV_TOKEN_FILE | Consul kv token file | /run/secrets/CONSUL_AGENT_TOKEN                 |

## Create the secret /run/secrets/CONSUL_AGENT_TOKEN

#### Create policy Consul

Name: `agent-policy-key-read`

```console
{
  "key_prefix": {
    "consul/nodes/config": {
      "policy": "read"
    }
  },
  "service_prefix": {
    "": {
      "policy": "write",
      "intentions": "read"
    }
  }
}
```

#### Create token

Create token with policy `agent-policy-key-read` and set the token in the secret

```console
echo -n "YourToken" | docker secret create CONSUL_AGENT_TOKEN -
**if exist secret, stop stack and `docker secret rm CONSUL_AGENT_TOKEN` **
```

##### Create the config

Create the config in the Consul KV

```console
{
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
      "agent": "%%СONSUL_AGENT_TOKEN%%"
    }
  },
  "log_level": "INFO",
  "domain": "consul",
  "client_addr": "0.0.0.0",
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




