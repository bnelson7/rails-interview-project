class WelcomeController < ApplicationController
  def index
    @total_users = User.all.length
    @total_questions = Question.all.length
    @total_answers = Answer.all.length
    @tenants = Tenant.all
    render :index
  end
end
