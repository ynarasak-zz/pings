require 'net/http'
class PingWorker
  include Sidekiq::Worker

  sidekiq_options queue: :ping

  def perform(*args)
    # do something
    #u = User.new
    str = (0...8).map{ (65 + rand(26)).chr }.join
    #u.save
    uri = URI.parse("https://nara-sample.herokuapp.com/static_pages/archives/"+str)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    p http.get(uri.request_uri)

    uri = URI.parse("http://nara-pings.herokuapp.com/sidekiq/scheduled")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    p "self -> "+http.get(uri.request_uri)
  end
end
