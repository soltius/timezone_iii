#
# Cookbook:: timezone_iii
# Recipe:: sles
#
# Copyright:: 2017, Corey Hemminger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This recipe sets the timezone on SLES12-2 and older (SUSE Enterprise Linux Server)
#
# If it is being run on SLES or newer, the recipe will be skipped and
# the "sles" recipe will be included instead.

# This sets the timezone on EL 7 distributions (e.g. RedHat and CentOS)
execute "timedatectl --no-ask-password set-timezone #{node['timezone_iii']['timezone']}"

template '/etc/sysconfig/clock' do
  source 'sles/clock.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[tzdata-update]'
end

# -- Novell (Suse's owner) has a package that updates the tzdata for suse
execute 'tzdata-update' do
  command 'zypper update timezone'
  action :nothing
end
