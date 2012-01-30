require 'rubygems'
require 'bundler'
Bundler.setup

require "sinatra"

disable :run

require './server.rb'

run Sinatra::Application