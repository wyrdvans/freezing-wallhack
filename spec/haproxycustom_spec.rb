require 'spec_helper'

describe "the haproxycustom grok pattern" do

  before do
    @grok = Grok.new
    @grok.add_patterns_from_file("logstash/patterns/grok-patterns")
    @grok.add_patterns_from_file("logstash/patterns/haproxy")
    @grok.add_patterns_from_file("patterns/haproxycustom")
    @grok.compile('%{HAPROXYCUSTOM}')
  end

  describe "with a standard haproxy log line" do
    before do
      log_line = 'Feb 18 12:52:25 api3.cloudmine.me haproxy[31165]: 108.242.22.84:4471 [18/Feb/2014:12:52:25.367] sslapi~ api-pool/API_6.1.2 196/0/2/58/256 200 425 - - ---- 186/186/5/0/0 0/0 {0|} {ec59b4bf-edbe} "GET /v1/app/245008ea0b494bdca5874e80e2bc1c69/search?q=%5B__class__%20%3D%20%22Message%22%2C%20dest%20%3D%20%22agent%22%2C%20custid%20%3D%20%22hlgx9azb%22%2C%20locid%20%3D%20%221%22%5D HTTP/1.1"'
      @match = @grok.match(log_line)
    end

    it "should have an entry date" do
      @match.should have_logstash_field("entry_date").with_value("Feb 18 12:52:25")
    end

    it "should have a haproxy server" do
      @match.should have_logstash_field("haproxy_server").with_value("api3.cloudmine.me")
    end

    it "should have a remote server" do
      @match.should have_logstash_field("remote_server").with_value("108.242.22.84:4471")
    end

    it "should have an accept date" do
      @match.should have_logstash_field("accept_date").with_value("18/Feb/2014:12:52:25.367")
    end

    it "should have a frontend server" do
      @match.should have_logstash_field("frontend_server").with_value("sslapi~")
    end

    it "should have a backend cluster server" do
      @match.should have_logstash_field("backend_cluster_server").with_value("api-pool/API_6.1.2")
    end

    it "should have times" do
      @match.should have_logstash_field("times").with_value("196/0/2/58/256")
    end

    it "should have a http status code" do
      @match.should have_logstash_field("http_status_code").with_value("200")
    end

    it "should have bytes read" do
      @match.should have_logstash_field("bytes_read").with_value("425")
    end

    it "should have request headers content length" do
      @match.should have_logstash_field("request_headers_content_length").with_value("{0|}")
    end

    it "should have response headers request id" do
      @match.should have_logstash_field("response_headers_request_id").with_value("{ec59b4bf-edbe}")
    end

    it "should have a http method" do
      @match.should have_logstash_field("http_method").with_value("GET")
    end

    it "should have a http uri" do
      @match.should have_logstash_field("http_uri").with_value("/v1/app/245008ea0b494bdca5874e80e2bc1c69/search?q=%5B__class__%20%3D%20%22Message%22%2C%20dest%20%3D%20%22agent%22%2C%20custid%20%3D%20%22hlgx9azb%22%2C%20locid%20%3D%20%221%22%5D")
    end
  end
end
