#
# Cookbook Name:: github_action_runners
# Resource:: ghe_linux_acrn
# Author:: d.naveenkashyap@gmail.com
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'json'

class Chef
  class Resource::GHELinuxACRN < Resource::LWRPBase
    resource_name :ghe_linux_acrn
    provides :ghe_linux_acrn

    actions :create, :delete
    default_action :create

    property :install_dir, kind_of: String, default: '/app/actions-runner'
    property :template_source, kind_of: String, default: 'github_runner.erb'
    property :template_remove_source, kind_of: String, default: 'remove_runner.erb'
    property :github_package, kind_of: String, default: 'nil'
    property :service_user, kind_of: String, default: 'nil'
    property :service_group, kind_of: String, default: 'nil'
    property :root_user, kind_of: String, default: 'root'
    property :root_group, kind_of: String, default: 'root'
    property :github_org, kind_of: String, default: 'nil'
    property :auth_token, kind_of: String, default: 'nil'
    property :builder_name, kind_of: String, default: 'nil'

    ### Create action runner in Github Enterprise##
    action :create do
      user new_resource.service_user do
        comment 'created by chef'
        home  "/home/#{new_resource.service_user}"
        shell '/bin/bash'
        manage_home  true
        action :create
      end
      directory new_resource.install_dir do
        mode '0755'
        owner new_resource.service_user
        group new_resource.service_group
        recursive true
        action :create
        sensitive true
      end
      poise_archive 'download media' do
        path new_resource.github_package
        destination new_resource.install_dir
        strip_components 0
        keep_existing true
      end
      template "#{new_resource.install_dir}/github_runner.sh" do
        source new_resource.template_source
        user new_resource.service_user
        group new_resource.service_group
        mode '0755'
        sensitive true
        action :create
      end

      if node['platform'] == 'redhat' || node['platform'] == 'centos'
        %w(
          epel-release
          jq
          libicu
          lttng-ust
          userspace-rcu
        ).each do |pkg|
          package pkg do
            action :install
          end
        end
      else
        package %w(jq)
      end
      execute 'create action runner' do
        cwd new_resource.install_dir
        command "./github_runner.sh #{new_resource.github_org} #{new_resource.auth_token} #{new_resource.builder_name}"
        user new_resource.service_user
        group new_resource.service_group
        sensitive true
        not_if { ::File.exist?("#{new_resource.install_dir}/.credentials") }
        action :run
      end

      sudo new_resource.service_user do
        users new_resource.service_user
        nopasswd true
        sensitive true
      end

      execute 'create github as service' do
        cwd new_resource.install_dir
        command "sudo ./svc.sh install #{new_resource.service_user}"
        user new_resource.service_user
        group new_resource.service_group
        action :run
        not_if { ::File.exist?("#{new_resource.install_dir}/.service") }
      end

      ruby_block 'name' do
        block do
        githubservice = IO.read("#{new_resource.install_dir}/.service").strip
          service "#{githubservice}" do
            action :start
          end
        end
        action :run
      end
  end

    ### Delete action runner in Github Enterprise##
    action :delete do
      template "#{new_resource.install_dir}/remove_runner.sh" do
        source new_resource.template_remove_source
        user new_resource.service_user
        group new_resource.service_group
        mode '0755'
        action :create
        sensitive true
      end

      execute 'remove github service' do
        cwd new_resource.install_dir
        command "sudo ./svc.sh uninstall #{new_resource.service_user}"
        user new_resource.service_user
        group new_resource.service_group
        action :run
        only_if { ::File.exist?("#{new_resource.install_dir}/.service") }
      end

      execute 'delete action runner' do
        cwd new_resource.install_dir.to_s
        command "./remove_runner.sh #{new_resource.github_org} #{new_resource.auth_token}"
        user new_resource.service_user
        group new_resource.service_group
        only_if { ::File.exist?("#{new_resource.install_dir}/.credentials") }
        action :run
        sensitive true
      end
      cache = Chef::Config[:file_cache_path]
      execute 'del_instillation_dir' do
        cwd new_resource.install_dir.to_s
        command "rm -rf * ; rm -rf #{cache}"
        action :run
        sensitive true
      end
    end
  end
end
