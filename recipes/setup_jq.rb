#
# Cookbook:: github_action_runners
# Recipe:: setup_jq
# Author:: d.naveenkashyap@gmail.com
# Copyright:: 2020, The Authors, All Rights Reserved.

directory (node['jq']['dir']).to_s do
  rights :full_control, 'Everyone'
  sensitive true
end

remote_file (node['jq']['install_dir']).to_s do
  source (node['jq']['url']).to_s
  mode '0755'
  action :create_if_missing
  sensitive true
end

jq_path = "#{ENV['SYSTEMDRIVE']}\\Program Files\\jq "

windows_path 'update_path_for_system' do
  action :add
  path jq_path
end
