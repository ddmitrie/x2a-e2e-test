---
source-path: fixtures/chef-cyberark-vault
---

# Migration Plan: chef-cyberark-vault-fixture

**TLDR**: This cookbook installs and configures a CyberArk application that retrieves database credentials from CyberArk Conjur. It installs a package, creates a configuration directory, deploys a configuration file with credentials from Conjur, and ensures the service is enabled and running.

## Service Type and Instances

**Service Type**: Application Server (CyberArk credential management application)

**Configured Instances**:
- **x2a-cyberark-app**: A single instance of the CyberArk application
  - Location/Path: Configuration at `/etc/x2a-cyberark-app/database.conf`
  - Key Config: Database credentials retrieved from CyberArk Conjur

## File Structure

```
fixtures/chef-cyberark-vault/recipes/default.rb
fixtures/chef-cyberark-vault/templates/default/database.conf.erb
fixtures/chef-cyberark-vault/attributes/default.rb
/workspace/source/migration-dependencies/cookbooks/cyberark/attributes/default.rb
```

## Module Explanation

The cookbook performs operations in this order:

1. **default** (`fixtures/chef-cyberark-vault/recipes/default.rb`):
   - Installs the x2a-cyberark-app package
   - Creates directory `/etc/x2a-cyberark-app` with mode 0750, owned by root:root
   - Retrieves database credentials from CyberArk Conjur:
     - Username from path: `x2a-test/production/database/username`
     - Password from path: `x2a-test/production/database/password`
   - Deploys database configuration template to `/etc/x2a-cyberark-app/database.conf`
     - Template: database.conf.erb → `/etc/x2a-cyberark-app/database.conf`
     - Sets file permissions to 0600, owned by root:root
     - Marks the template as sensitive (contains credentials)
     - Passes database credentials as template variables
   - Enables and starts the x2a-cyberark-app service
   - Resources: package (1), directory (1), template (1), service (1)

## Dependencies

**External cookbook dependencies**:
- cyberark cookbook (provides the conjur_variable function)

**System package dependencies**:
- x2a-cyberark-app

**Service dependencies**:
- x2a-cyberark-app service

## Credentials

**Detection Summary**: 2 credentials detected across 2 files

**Source**:
  - **Provider**: CyberArk Conjur
  - **Path**: Conjur secrets at paths `x2a-test/production/database/username` and `x2a-test/production/database/password`

### Database Username

- **Variable(s)**: `db_username`, `database_username` (in template)
- **Source file(s)**: `fixtures/chef-cyberark-vault/recipes/default.rb`, `fixtures/chef-cyberark-vault/templates/default/database.conf.erb`
- **Current storage**: conjur_variable function call
- **Usage context**: Database authentication - username for database connection

### Database Password

- **Variable(s)**: `db_password`, `database_password` (in template)
- **Source file(s)**: `fixtures/chef-cyberark-vault/recipes/default.rb`, `fixtures/chef-cyberark-vault/templates/default/database.conf.erb`
- **Current storage**: conjur_variable function call
- **Usage context**: Database authentication - password for database connection

## Checks for the Migration

**Files to verify**:
- `/etc/x2a-cyberark-app/database.conf`

**Service endpoints to check**:
- Service status: x2a-cyberark-app

**Templates rendered**:
- database.conf.erb → `/etc/x2a-cyberark-app/database.conf` (rendered once)

## Pre-flight checks:
```bash
# Package installation
dpkg -l | grep x2a-cyberark-app || rpm -q x2a-cyberark-app

# Directory permissions
ls -la /etc/x2a-cyberark-app
# Should show: drwxr-x--- root root /etc/x2a-cyberark-app

# Configuration file
ls -la /etc/x2a-cyberark-app/database.conf
# Should show: -rw------- root root /etc/x2a-cyberark-app/database.conf

# Configuration content (without showing sensitive data)
grep -v password /etc/x2a-cyberark-app/database.conf
# Should show database_username line but not the password line

# Service status
systemctl status x2a-cyberark-app
# Should show service is active (running)

# Service enabled
systemctl is-enabled x2a-cyberark-app
# Should return "enabled"

# Process check
ps aux | grep x2a-cyberark-app
# Should show running process

# Logs
journalctl -u x2a-cyberark-app -n 50
# Check for any errors in service logs

# Verify Conjur connectivity (if possible)
# This would depend on how the application authenticates with Conjur
# You may need specific Conjur CLI tools to verify this connection
```