# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'

get "/" do
  haml :index
end

post "/convert" do
  begin
    @after = convert(params)
    haml :index
  rescue
    ["だめです？",
     "おちるです？",
     "しんじゃうです？",
     "ふせいです？",
     "へんです？",
     "おかしいです？",
     "さよならです？"].sample
  end
end

get "/convert" do
  convert(params)
end

private
def convert(params)
  if params[:way] == "0"
    str2hex(params[:before], params[:charset])
  else
    hex2str(params[:before], params[:charset])
  end
end

def str2hex(str, charset="UTF-8")
  str.split(//).map {|char|
    char.encode(charset).bytes.map {|byte|
      byte.to_s(16)
    }.join
  }.join(' ')
end

def hex2str(hex, charset="UTF-8")
  if charset == "UTF-8"
    [hex.gsub(/\s+/, '')].pack("H*").force_encoding(charset)
  else
    Encoding::Converter.new(charset, "UTF-8").convert([hex].pack("H*"))
  end
end
