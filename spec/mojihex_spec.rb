# encoding: utf-8
require 'rspec'
require 'rack/test'

MY_APP = Rack::Builder.parse_file('config.ru').first

include Rack::Test::Methods
def app
  MY_APP
end

describe "MojiHex" do
  context "root" do
    it "last response ok?" do
      get '/'
      last_response.ok? == true
    end
  end

  context "convert" do
    it "last response ok?" do
      post '/convert'
      last_response.ok? == true
    end

    context "char to hex bytes" do
      it "insert space while char" do
        post '/convert', {"before" => "あいう",
                          "charset" => "UTF-8",
                          "mode" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>e38182 e38184 e38186</
      end

      it "encoding UTF-8" do
        post '/convert', {"before" => "あ",
                          "charset" => "UTF-8",
                          "mode" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>e38182</
      end

      it "encoding Shift_JIS" do
        post '/convert', {"before" => "あ",
                          "charset" => "Shift_JIS",
                          "mode" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>82a0</
      end

      it "encoding EUC-JP" do
        post '/convert', {"before" => "あ",
                          "charset" => "EUC-JP",
                          "mode" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>a4a2</
      end

      it "encoding CP930" do
        post '/convert', {"before" => "あ",
                          "charset" => "CP930",
                          "mode" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>0e44810f</
      end

      it "encoding UTF-16BE" do
        post '/convert', {"before" => "あ",
                          "charset" => "UTF-16BE",
                          "mode" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>3042</
      end

      it "invalid encoding" do
        post '/convert', {"before" => "あ",
                          "charset" => "UTF-9",
                          "mode" => "0"}
        last_response.ok? == false
        last_response.body.to_s.should =~ /Error: invalid encoding/
      end
    end

    context "hex bytes to char" do
      it "upper case" do
        post '/convert', {"before" => "E38182",
                          "charset" => "UTF-8",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あ</
      end

      it "lower case" do
        post '/convert', {"before" => "e38182",
                          "charset" => "UTF-8",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あ</
      end

      it "remove space between bytes" do
        post '/convert', {"before" => "e38182 e38184 e38186",
                          "charset" => "UTF-8",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あいう</
      end

      it "encoding UTF-8" do
        post '/convert', {"before" => "e38182",
                          "charset" => "UTF-8",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あ</
      end

      it "encoding Shift_JIS" do
        post '/convert', {"before" => "82a0",
                          "charset" => "Shift_JIS",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あ</
      end

      it "encoding EUC-JP" do
        post '/convert', {"before" => "a4a2",
                          "charset" => "EUC-JP",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あ</
      end

      it "encoding CP930" do
        post '/convert', {"before" => "0e44810f",
                          "charset" => "CP930",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あ</
      end

      it "encoding UTF-16BE" do
        post '/convert', {"before" => "3042",
                          "charset" => "UTF-16BE",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あ</
      end

      it "invalid byte sequence in UTF-8" do
        post '/convert', {"before" => "82a0",
                          "charset" => "UTF-8",
                          "mode" => "1"}
        last_response.ok? == false
        last_response.body.to_s.should =~ /Error: invalid byte sequence in UTF-8/
      end

      it "invalid encoding" do
        post '/convert', {"before" => "e38182",
                          "charset" => "UTF-9",
                          "mode" => "1"}
        last_response.ok? == false
        last_response.body.to_s.should =~ /Error: invalid encoding/
      end

      it "save params" do
        post '/convert', {"before" => "82a0",
                          "charset" => "Shift_JIS",
                          "mode" => "1"}
        last_response.ok? == false
        last_response.body.to_s.should =~ /selected.*>Shift_JIS</
        last_response.body.to_s.should =~ /selected.*>byte -> char</
        last_response.body.to_s.should =~ /before.*>82a0</
      end
    end
  end

  context "HTTP GET" do
    context "char to hex bytes" do
      it "encoding UTF-8" do
        get '/convert', {"before" => "あ",
                          "charset" => "UTF-8",
                          "mode" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>e38182</
      end

      it "invalid byte sequence in UTF-8" do
        get '/convert', {"before" => "82a0",
                          "charset" => "UTF-8",
                          "mode" => "1"}
        last_response.ok? == false
        last_response.body.to_s.should =~ /Error: invalid byte sequence in UTF-8/
      end

      it "invalid encoding" do
        post '/convert', {"before" => "e38182",
                          "charset" => "UTF-9",
                          "mode" => "1"}
        last_response.ok? == false
        last_response.body.to_s.should =~ /Error: invalid encoding/
      end
    end

    context "hex bytes to char" do
      it "encoding UTF-8" do
        get '/convert', {"before" => "e38182",
                          "charset" => "UTF-8",
                          "mode" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /after.*>あ</
      end
    end
  end
end

