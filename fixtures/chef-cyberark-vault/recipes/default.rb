# FLPATH-3847 credential migration test

package 'x2a-cyberark-app'

directory '/etc/x2a-cyberark-app' do
  owner 'root'
  group 'root'
  mode '0750'
end

# These are safe fixture paths, not real CyberArk or Conjur secret values.
db_username = conjur_variable('x2a-test/production/database/username')
db_password = conjur_variable('x2a-test/production/database/password')

template node['x2a_cyberark_vault_fixture']['config_path'] do
  source 'database.conf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  sensitive true
  variables(
    database_username: db_username,
    database_password: db_password
  )
end

service node['x2a_cyberark_vault_fixture']['service_name'] do
  action [:enable, :start]
end
