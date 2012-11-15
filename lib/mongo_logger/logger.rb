# encoding: utf-8
module MongoLogger
  class Logger

    attr_accessor :session, :coll

    # hosts - the String or Array hosts of mongodb
    # db - the String database name
    # coll_name - the String collection name of where the log go to
    def initialize(hosts = "localhost:27017", db = "mongo_logger", coll_name = 'mongo_logs')
      @session = Moped::Session.new(Array(hosts))
      @session.use db
      @coll = session[coll_name]
    end

    # DEBUG = :debug
    # def debug(message, extras = {})
    #   log(DEBUG, message, extras)
    # end

    [:debug, :info, :warn, :error, :fatal].each do |severity|
      const_set(severity.to_s.upcase, severity)

      define_method severity do |message, extras = {}|
        log(self.class.const_get(severity.to_s.upcase), message, extras)
      end

      define_method "#{severity}_logs" do |limit = 20|
        @coll.find(severity: self.class.const_get(severity.to_s.upcase)).limit(limit).to_a
      end

    end

    def log(severity, message, extras = {})
      @coll.insert(severity: severity, created_at: Time.now, message: message, extras: extras)
    end

    # clear all logs
    def clear
      @coll.drop
    end


  end

end
