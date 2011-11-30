#!/usr/bin/env rake
require "bundler/gem_tasks"

desc 'Clean up test account'
task :clean_et do
  Bundler.require :default, :development
  require './spec/spec_helper'
  api = Cupid::Test
  api.delete_emails *api.emails
  api.delete_folders *api.folders.reject(&:root?)
end
