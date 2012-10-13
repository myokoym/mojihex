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
    char2hex(char, charset)
  }.join(' ')
end

def char2hex(char, charset)
  char.encode(charset).bytes.map {|byte|
    "%02x" % byte
  }.join
rescue Encoding::ConverterNotFoundError
  require 'iconv'
  Iconv.conv(charset, "UTF-8", char).unpack("H*")
end

def hex2str(hex, charset="UTF-8")
  if charset == "UTF-8"
    hex2bytes(hex).force_encoding(charset)
  else
    Encoding::Converter.new(charset, "UTF-8").convert(hex2bytes(hex))
  end
rescue EncodingError
  require 'iconv'
  Iconv.conv("UTF-8", charset, hex2bytes(hex))
end

def hex2bytes(hex)
  [hex.gsub(/\s+/, '')].pack("H*")
end
