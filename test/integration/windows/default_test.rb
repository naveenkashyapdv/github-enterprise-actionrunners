# # encoding: utf-8

# Inspec test for recipe github_action_runners::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

  describe user('github'), :skip do
    it { should exist }
  end

  describe directory('C:\actions-runner') do
    it { should exist }
    it { should be_directory }
  end
  
  describe directory('C:\actions-runner\externals') do
    it { should exist }
    it { should be_directory }
  end
  
  describe file('C:\actions-runner\.credentials') do
    it { should exist }
    it { should be_file }
    its('content') { should include "clientId" }
    its('content') { should include "authorizationUrl" }
    its('content') { should include "scheme" }
  end
  
  describe file('C:\actions-runner\.runner') do
    it { should exist }
    it { should be_file }
    its('content') { should include "poolName" }
    its('content') { should include "serverUrl" }
    its('content') { should include "gitHubUrl" }
  end

  describe file('C:\actions-runner\bin\Runner.Listener.exe') do
    it { should exist }
    it { should be_file }
  end  
