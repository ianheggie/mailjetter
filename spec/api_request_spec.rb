# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Mailjetter::ApiRequest do

  describe "#request_path" do
    let(:request) { Mailjetter::ApiRequest.new('method_name') }
    it "should return the path of the method" do
      request.send(:request_path).should == '/0.1/methodName?output=json'
    end

    it "should respect api_version" do
      Mailjetter.config.stub(:api_version).and_return(0.2)
      request.send(:request_path).should == '/0.2/methodName?output=json'
    end
  end

  describe "#request_port" do
    let(:request) { Mailjetter::ApiRequest.new('method_name') }
    it "should return 80 if use_https is false" do
      Mailjetter.config.use_https = false
      request.send(:request_port).should == 80
    end

    it "should return 443 if use_https is true" do
      Mailjetter.config.use_https = true
      request.send(:request_port).should == 443
    end
  end

  describe "#request" do
    it "should return an Http request" do
      request = Mailjetter::ApiRequest.new('method_name', {}, 'Post')
      request.send(:request).should be_a(Net::HTTP::Post)

      request = Mailjetter::ApiRequest.new('method_name', {}, 'Get')
      request.send(:request).should be_a(Net::HTTP::Get)
    end
  end

  describe "#response" do
    it "should raise an ApiError if authentication fails" do
      request = Mailjetter::ApiRequest.new('method_name', {}, 'Get')
      expect {
        request.response
      }.to raise_error(Mailjetter::ApiError)
    end

    it "should return a Hash with response values if request is ok" do
      request = Mailjetter::ApiRequest.new('user_infos', {}, 'Get')
      response = request.response
      response.should be_a(Hash)
      response['infos']['username'].should be_a(String)
    end
  end
end
