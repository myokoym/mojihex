# encoding: utf-8
require 'rspec'
require 'rack/test'

MY_APP = Rack::Builder.parse_file('config.ru').first

include Rack::Test::Methods
def app
  MY_APP
end

describe "Convchar" do
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
                          "way" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='e38182 e38184 e38186'/
      end

      it "encoding UTF-8" do
        post '/convert', {"before" => "あ",
                          "charset" => "UTF-8",
                          "way" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='e38182'/
      end

      it "encoding Shift_JIS" do
        post '/convert', {"before" => "あ",
                          "charset" => "Shift_JIS",
                          "way" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='82a0'/
      end

      it "encoding EUC-JP" do
        post '/convert', {"before" => "あ",
                          "charset" => "EUC-JP",
                          "way" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='a4a2'/
      end
    end

    context "hex bytes to char" do
      it "upper case" do
        post '/convert', {"before" => "E38182",
                          "charset" => "UTF-8",
                          "way" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='あ'/
      end

      it "lower case" do
        post '/convert', {"before" => "e38182",
                          "charset" => "UTF-8",
                          "way" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='あ'/
      end

      it "encoding UTF-8" do
        post '/convert', {"before" => "e38182",
                          "charset" => "UTF-8",
                          "way" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='あ'/
      end

      it "encoding Shift_JIS" do
        post '/convert', {"before" => "82a0",
                          "charset" => "Shift_JIS",
                          "way" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='あ'/
      end

      it "encoding EUC-JP" do
        post '/convert', {"before" => "a4a2",
                          "charset" => "EUC-JP",
                          "way" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /value='あ'/
      end
    end
  end

  context "api" do
    context "char to hex bytes" do
      it "encoding UTF-8" do
        get '/convert', {"before" => "あ",
                          "charset" => "UTF-8",
                          "way" => "0"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /\Ae38182\z/
      end
    end

    context "hex bytes to char" do
      it "encoding UTF-8" do
        get '/convert', {"before" => "e38182",
                          "charset" => "UTF-8",
                          "way" => "1"}
        last_response.ok? == true
        last_response.body.to_s.should =~ /\Aあ\z/
      end
    end
  end
end

