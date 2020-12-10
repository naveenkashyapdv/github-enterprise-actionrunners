name 'github_action_runners'
maintainer 'The Authors'
maintainer_email 'd.naveenkashyap@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures github_action_runners'
version '0.1.18'
chef_version '>= 15.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/github_action_runners/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/github_action_runners'

depends 'poise-archive', '~> 1.5.0'
depends 'poise-python'
