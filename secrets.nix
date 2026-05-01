let
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEpKlxMKcFXjXrsQ2tMvuveVGjIMc6mfW90sqzfVVhP root@vmi3144119";
in
{
  "secrets/registry-htpasswd.age".publicKeys = [ server ];
  "secrets/rio-tinto-app-password.age".publicKeys = [ server ];
  "secrets/beszel-agent-key.age".publicKeys = [ server ];
  "secrets/beszel-agent-token.age".publicKeys = [ server ];
  "secrets/glance-env.age".publicKeys = [ server ];
  "secrets/rio-tinto-db-env.age".publicKeys = [ server ];
  "secrets/rio-tinto-api-env.age".publicKeys = [ server ];
  "secrets/impact-sphere-db-env.age".publicKeys = [ server ];
  "secrets/impact-sphere-env.age".publicKeys = [ server ];
  "secrets/populi-env.age".publicKeys = [ server ];
  "secrets/populi-db-env.age".publicKeys = [ server ];
}
