# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'

get "/" do
  haml :index
end

post "/convert" do
  @after = convert(params)
  haml :index
end

get "/convert/:before" do |before|
  convert(before)
end

private
def convert(params)
  charset = params['charset']
  way = params['way']
  before = params['before']
  to_b(before)
end

def to_b(s)
  s.bytes.collect {|b| b.to_s(16) }.join
end

