module OpenCage
  class Error < StandardError
    attr_reader :code

    InvalidRequest = Class.new(self)
    AuthenticationError = Class.new(self)
    QuotaExceeded = Class.new(self)
    Forbidden = Class.new(self)
    InvalidEndpoint = Class.new(self)
    NotAllowedMethod = Class.new(self)
    Timeout = Class.new(self)
    RequestTooLong = Class.new(self)
    UpgradeRequired = Class.new(self)
    TooManyRequests = Class.new(self)
    InternalServer = Class.new(self)

    def initialize(message:, code: nil)
      super(message)
      @code = code
    end

    ERRORS = {
      0 => OpenCage::Error,
      400 => OpenCage::Error::InvalidRequest,
      401 => OpenCage::Error::AuthenticationError,
      402 => OpenCage::Error::QuotaExceeded,
      403 => OpenCage::Error::Forbidden,
      404 => OpenCage::Error::InvalidEndpoint,
      405 => OpenCage::Error::NotAllowedMethod,
      408 => OpenCage::Error::Timeout,
      410 => OpenCage::Error::RequestTooLong,
      426 => OpenCage::Error::UpgradeRequired,
      429 => OpenCage::Error::TooManyRequests,
      503 => OpenCage::Error::InternalServer
    }
  end
end