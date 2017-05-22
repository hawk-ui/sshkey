#
# Cookbook Name:: sshkey
# Recipe:: default
#
# Copyright 2013-2014, Thomas Boerger <thomas@webhippie.de>
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
#

entries = if Chef::Config[:solo] and not (node.recipe?("chef-solo-search") || node.recipe?("chef-solo-search::default"))
  node["sshkey"]["users"]
else
  search(
    node["sshkey"]["data_bag"],
    "available:#{node["fqdn"]} OR available:default"
  )
end

entries.each do |user|
  sshkey user["username"] do
    group user["group"]
    home user["home"]

    keys user["keys"]
    private_key user["private_key"]
    public_key user["public_key"]
  end
end
