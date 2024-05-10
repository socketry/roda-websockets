# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019, by Shannon Skipper.
# Copyright, 2024, by Samuel Williams.

source 'https://rubygems.org'

gemspec

group :maintenance, optional: true do
	gem "bake-gem"
	gem "bake-modernize"
	
	gem "utopia-project"
end

group :test do
	gem "sus"
	gem "covered"
	
	gem "sus-fixtures-async"
	gem "sus-fixtures-async-http"
	
	gem "bake-test"
	gem "bake-test-external"
end