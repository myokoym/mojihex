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
    c2b(params[:before], params[:charset])
  else
    b2c(params[:before], params[:charset])
  end
end

def c2b(c, charset="UTF-8")
  c.split(//).map {|char|
    char.encode(charset).bytes.map {|b|
      b.to_s(16)
    }.join
  }.join(' ')
end

def b2c(b, charset="UTF-8")
  if charset == "UTF-8"
    [b.gsub(/\s+/, '')].pack("H*").force_encoding(charset)
  else
    Encoding::Converter.new(charset, "UTF-8").convert([b].pack("H*"))
  end
end
