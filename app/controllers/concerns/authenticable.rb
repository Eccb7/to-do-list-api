module Authenticable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user
    before_action :authenticate_request
  end

  private

  def authenticate_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end
