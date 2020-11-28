# Cookbook:: github_action_runners
# Attributes:: default
# Copyright:: 2019, The Authors, All Rights Reserved.

default['git_action_runner_linux']['download_url']      = 'https://github.com/actions/runner/releases/download/v2.274.2/actions-runner-linux-x64-2.274.2.tar.gz'
default['git_action_runner_windows']['download_url']    = 'https://github.com/actions/runner/releases/download/v2.274.2/actions-runner-win-x64-2.274.2.zip'
default['github']['user']                               = 'github'
default['github']['group']                              = 'github'
default['github-runner_linux']['name']                  = 'dev-test'
default['github-runner_windows']['name']                = 'dev-test-windows'
default['jq']['url']                                    = 'https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe'
default['jq']['dir']                                    = 'C:\Program Files\jq'
default['jq']['install_dir']                            = 'C:\Program Files\jq\jq.exe'
default['github']['auth_token']                         = 'Enter your auth token here'
default['github']['org']                                = 'Enter your org name here'
