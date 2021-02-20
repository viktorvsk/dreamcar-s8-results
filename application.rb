# frozen_string_literal: true

require 'csv'
require 'json'

REDIS = Redis.new(url: ENV['REDIS_URL'])
