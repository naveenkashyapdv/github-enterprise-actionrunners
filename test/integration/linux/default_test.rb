# # encoding: utf-8

# Inspec test for recipe github_action_runners::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/app/actions-runner') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0755' }
end

describe directory('/app/actions-runner/_diag') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0755' }
end

describe user('github') do
  it { should exist }
end

describe group('github') do
  it { should exist }
end

describe directory('/app/actions-runner/bin') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0755' }
end

describe directory('/app/actions-runner/externals') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0755' }
end

describe file('/app/actions-runner/.credentials') do
  it { should exist }
  it { should be_file }
  its('content') { should include 'clientId' }
  its('content') { should include 'authorizationUrl' }
  its('content') { should include 'scheme' }
end

describe file('/app/actions-runner/.runner') do
  it { should exist }
  it { should be_file }
  its('content') { should include 'poolName' }
  its('content') { should include 'serverUrl' }
  its('content') { should include 'gitHubUrl' }
end

describe service('actionrunner') do
  it { should be_enabled }
  it { should be_running }
end
