acl = "read"
agent_prefix "" {
	policy = "read"
}
event_prefix "" {
	policy = "read"
}
key_prefix "" {
	policy = "read"
	required_acl_token = "correct_server_token"
}
keyring = "read"
node_prefix "" {
	policy = "read"
	required_acl_token = "correct_server_token"
}
operator = "read"
query_prefix "" {
	policy = "read"
}
service_prefix "" {
	policy = "read"
	intentions = "read"
}
session_prefix "" {
	policy = "read"
}
