#
# Cookbook:: github_action_runners
# Resource:: ghe_windows_acrn
# Author:: d.naveenkashyap@gmail.com
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'json'

class Chef
  class Resource::GHEWindowsACRN < Resource::LWRPBase
    resource_name :ghe_windows_acrn
    provides :ghe_windows_acrn

    actions :create, :delete
    default_action :create

    property :install_dir, kind_of: String, default: 'C:\actions-runner'
    property :template_source, kind_of: String, default: 'powershell.erb'
    property :github_package, kind_of: String, default: 'nil'
    property :github_org, kind_of: String, default: 'nil'
    property :auth_token, kind_of: String, default: 'nil'
    property :builder_name, kind_of: String, default: 'nil'

    ### Create action runner in Github Enterprise##
    action :create do
      directory new_resource.install_dir do
        rights :full_control, 'Everyone'
      end
      poise_archive 'download media' do
        path new_resource.github_package
        destination new_resource.install_dir
        strip_components 0
        keep_existing true
      end
      template "#{new_resource.install_dir}\\powershell.ps1" do
        source new_resource.template_source
        mode '0755'
        sensitive true
        action :create
      end

      include_recipe 'github_action_runners::setup_jq'

      execute 'delete_old_token' do
        command "del #{new_resource.install_dir}\\token.txt"
        only_if { ::File.exist?("#{new_resource.install_dir}\\token.txt") }
      end
      execute 'create_token' do
        command "powershell.exe -ExecutionPolicy Unrestricted -File #{new_resource.install_dir}\\powershell.ps1 #{new_resource.auth_token} #{new_resource.github_org} | jq -r .token >> #{new_resource.install_dir}\\token.txt"
        action :run
        sensitive true
      end

      execute 'create_runner' do
        command lazy {
          token = IO.read("#{new_resource.install_dir}\\token.txt").strip
          "powershell.exe  #{new_resource.install_dir}\\config.cmd --url https://github.com/#{new_resource.github_org} --token #{token} --runasservice  --labels 'self-hosted,Windows,X64' --name #{new_resource.builder_name} --work _work --unattended"
        }
        sensitive true
        not_if { ::Win32::Service.exists?("actions.runner.#{new_resource.github_org}.#{new_resource.builder_name}") }
      end
    end

    action :delete do
      template "#{new_resource.install_dir}\\powershell.ps1" do
        source new_resource.template_source
        mode '0755'
        sensitive true
        action :create
      end
      execute 'delete_old_token' do
        command "del #{new_resource.install_dir}\\token.txt"
        only_if { ::File.exist?("#{new_resource.install_dir}\\token.txt") }
      end
      execute 'create_token' do
        command "powershell.exe -ExecutionPolicy Unrestricted -File #{new_resource.install_dir}\\powershell.ps1 #{new_resource.auth_token} #{new_resource.github_org} | jq -r .token >> #{new_resource.install_dir}\\token.txt"
        action :run
        sensitive true
      end
      execute 'delete_runner' do
        command lazy {
          token = IO.read("#{new_resource.install_dir}\\token.txt").strip
          "powershell.exe  #{new_resource.install_dir}\\config.cmd remove --url https://github.com/#{new_resource.github_org} --token #{token} --unattended"
        }
        sensitive true
        only_if { ::Win32::Service.exists?("actions.runner.#{new_resource.github_org}.#{new_resource.builder_name}") }
      end
      execute 'remove_everthingform_dir' do
        command "powershell.exe del '#{new_resource.install_dir}' -recurse -force"
        action :run
        only_if { ::Dir.exist?("#{new_resource.install_dir}/_diag") }
        sensitive true
      end
      cache = Chef::Config[:file_cache_path]
      execute 'delete_old_file' do
        command "powershell.exe del #{cache}/*.zip"
        not_if { ::Dir.exist?("#{new_resource.install_dir}/_work") }
        sensitive true
      end
    end
  end
end
