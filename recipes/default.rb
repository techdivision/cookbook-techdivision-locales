#
# Cookbook Name:: robertlemke-locales
# Recipe:: default
# Author:: Robert Lemke <rl@robertlemke.com>
#
# Copyright (c) 2013-2014 Robert Lemke
#
# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://opensource.org/licenses/MIT
#

execute "locale-gen" do
	action :nothing
	command "locale-gen --purge"
end

case node['platform_family']
when "debian"
	file "/etc/locale.gen" do
		action :create
		owner "root"
		group "root"
		mode "0644"
		content node['robertlemke-locales']['locales'].join("\n") + "\n"
		notifies :run, "execute[locale-gen]", :immediate
	end
else
	file "/var/lib/locales/supported.d/en" do
		action :delete
	end

	file "/var/lib/locales/supported.d/local" do
		action :create
		owner "root"
		group "root"
		mode "0644"
		content node['robertlemke-locales']['locales'].join("\n") + "\n"
		notifies :run, "execute[locale-gen]", :immediate
	end
end

