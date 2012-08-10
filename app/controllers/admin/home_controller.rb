class Admin::HomeController < Admin::BaseController
  before_filter {|c| c.send(:require_role, :admin, :editor, :contributor)}

  def index
  end
end
