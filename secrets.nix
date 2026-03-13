let
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEpKlxMKcFXjXrsQ2tMvuveVGjIMc6mfW90sqzfVVhP root@vmi3144119";
in
{
  "secrets/registry-htpasswd.age".publicKeys = [ server ];
  "secrets/rio-tinto-app-password.age".publicKeys = [ server ];
}
