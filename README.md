# Github Self-Hosted Runners

## Fully functioning cookbook to install github self-hosted runners for Organization-level 

This cookbook install, manage, and manipulate github hosted runners. Provide authtoken to generate registration-token for github runner

## About self-hosted runners

Self-hosted runners offer more control of hardware, operating system, and software tools than GitHub-hosted runners provide. With self-hosted runners, you can choose to create a custom hardware configuration with more processing power or memory to run larger jobs, install software available on your local network, and choose an operating system not offered by GitHub-hosted runners. Self-hosted runners can be physical, virtual, in a container, on-premises, or in a cloud.

You can add self-hosted runners at various levels in the management hierarchy:

* Repository-level runners are dedicated to a single repository.
* Organization-level runners can process jobs for multiple repositories in an organization.
* Enterprise-level runners can be assigned to multiple organizations in an enterprise account


## Requirements for self-hosted runner machines

* You can use any machine as a self-hosted runner as long at it meets these requirements:

* You can install and run the self-hosted runner application on the machine. For more information, see ["Supported operating systems for self-hosted runners."](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/about-self-hosted-runners#supported-operating-systems-for-self-hosted-runners)


* The machine can communicate with GitHub Actions. For more information, see ["Communication between self-hosted runners and GitHub."](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/about-self-hosted-runners#communication-between-self-hosted-runners-and-github)

* The machine has enough hardware resources for the type of workflows you plan to run. The self-hosted runner application itself only requires minimal resources.
If you want to run workflows that use Docker container actions or service containers, you must use a Linux machine and Docker must be installed.


## Usage limits

There are some limits on GitHub Actions usage when using self-hosted runners. These limits are subject to change.

* Workflow run time - Each workflow run is limited to 72 hours. If a workflow run reaches this limit, the workflow run is cancelled.
* Job queue time - Each job for self-hosted runners can be queued for a maximum of 24 hours. If a self-hosted runner does not start executing the job within this ∂limit, the job is terminated and fails to complete.
* API requests - You can execute up to 1000 API requests in an hour across all actions within a repository. If exceeded, additional API calls will fail, which might cause jobs to fail.
* Job matrix - A job matrix can generate a maximum of 256 jobs per workflow run. This limit also applies to self-hosted runners.


## Supported operating systems for self-hosted runners


The following operating systems are supported for the self-hosted runner application.

* Linux
   * Red Hat Enterprise Linux 7, 8
   * CentOS 7, 8
   * Ubuntu 16.04 or later

* Windows
  * Windows Server 2012 R2 64-bit
  * Windows Server 2016 64-bit
  * Windows Server 2019 64-bit

### Chef

- Chef 15.0+

## Usage 
 ### Create Runner 

 * LINUX 

```ruby
  ghe_linux_acrn 'Install GitHub Runner' do
    github_org (node['github']['org']).to_s
    auth_token (node['github']['auth_token']).to_s
    github_package (node['git_action_runner_linux']['download_url']).to_s
    builder_name "#{node['github-runner_linux']['name']}-#{node['hostname']}"
    service_user (node['github']['user']).to_s
    service_group (node['github']['user']).to_s
    action :create
  end
  ```

  * WINDOWS

```ruby
  ghe_windows_acrn 'Install GitHub Runner for Windows' do
    github_org (node['github']['org']).to_s
    auth_token (node['github']['auth_token']).to_s
    github_package (node['git_action_runner_windows']['download_url']).to_s
    builder_name "#{node['github-runner_windows']['name']}-#{node['hostname']}"
    action :create
  end
  ```

 ### Delete Runner 

 * LINUX 

```ruby
  ghe_linux_acrn 'Install GitHub Remove Runner' do
    github_org (node['github']['org']).to_s
    auth_token (node['github']['auth_token']).to_s
    service_user (node['github']['user']).to_s
    service_group (node['github']['user']).to_s
    action :delete
  end
  ```

  * WINDOWS

```ruby
  ghe_windows_acrn 'Install GitHub Runner for Windows' do
    github_org (node['github']['org']).to_s
    auth_token (node['github']['auth_token']).to_s
    github_package (node['git_action_runner_windows']['download_url']).to_s
    builder_name "#{node['github-runner_windows']['name']}-#{node['hostname']}"
    action :delete
  end
  ```



