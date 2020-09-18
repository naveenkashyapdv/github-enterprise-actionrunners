# #
# # Cookbook:: github_action_runners
# # Recipe:: default
# Author:: d.naveenkashyap@gmail.com
# # Copyright:: 2020, The Authors, All Rights Reserved.

case node['platform']
when 'centos', 'redhat', 'ubuntu'
  ghe_linux_acrn 'Install GitHub Runner' do
    github_org (node['github']['org']).to_s
    auth_token (node['github']['auth_token']).to_s
    github_package (node['git_action_runner_linux']['download_url']).to_s
    builder_name "#{node['github-runner_linux']['name']}-#{node['hostname']}"
    service_user (node['github']['user']).to_s
    service_group (node['github']['user']).to_s
    action :create
  end
when 'windows'
  ghe_windows_acrn 'Install GitHub Runner for Windows' do
    github_org (node['github']['org']).to_s
    auth_token (node['github']['auth_token']).to_s
    github_package (node['git_action_runner_windows']['download_url']).to_s
    builder_name "#{node['github-runner_windows']['name']}-#{node['hostname']}"
    action :create
  end
end
