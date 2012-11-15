# encoding: utf-8
require_relative 'minitest_helper'
module MongoLogger
  describe Logger do
    before :each do
      @logger = Logger.new("localhost:27017","mongo_logger_test")
      @logger.clear
    end

    it '#log' do
      @logger.debug( "hello, logging world", machine: "Shiki")
      @logger.coll.find().count.must_equal 1
      log = @logger.debug_logs.first
      log['message'].must_equal "hello, logging world"
      log['severity'].must_equal Logger::DEBUG
      log['extras']['machine'].must_equal 'Shiki'
    end

  end

end
