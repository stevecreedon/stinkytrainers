class TutorialController < ApplicationController
  def index
    render params[:path]
  end
end
