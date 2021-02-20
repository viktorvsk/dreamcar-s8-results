# frozen_string_literal: true

Bundler.require(:default)

require './application'
require './routes'

run Sinatra::Application
