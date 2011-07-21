# encoding: utf-8

module Mailjetter
  autoload :Configuration, 'configuration'
  autoload :ApiRequest, 'api_request'
  
  # configiration shortcuts
  def self.configure
    yield Mailjetter::Configuration
  end

  def self.config
    Mailjetter::Configuration
  end
end