# Chef CyberArk/Conjur credential fixture

This minimal role is test data for FLPATH-3847. It contains placeholder
credential handling and passes the resulting values to a template resource.
No real CyberArk, Conjur, or application credential is included.

Expected analysis marker:

`FLPATH-3847 credential migration test`
`FLPATH-3351-TC-07-RULE`

## Requirements

- Ansible 2.9 or higher
- Access to AAP credential variables

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| chef_cyberark_vault_fixture_config_path | /etc/x2a-cyberark-app/database.conf | Path to the database configuration file |
| chef_cyberark_vault_fixture_service_name | x2a-cyberark-app | Name of the CyberArk application service |

## AAP Credential Variables

This role requires the following credential variables to be injected by AAP:

- `username`: Database username
- `password`: Database password
- `conjur_path_prefix`: Conjur path prefix

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: chef_cyberark_vault_fixture
```

## License

Apache-2.0