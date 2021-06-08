class QuestionsController < ApplicationController

    before_action :authorization

    def index
        query_items = ["id", "title", "user_id", "private"]
        query_string = nil
        query_items.each { |query| query_string = query if params.key?(query) }
        if query_string
            @questions = query_string == "title" ?
            Question.where("lower(title) LIKE ?", "%#{params[query_string].downcase}%") :
            Question.where("#{query_string} = '#{params[query_string]}'")
            if @questions.length > 0
                render :index
            else
                render status: 404
            end
        else
            @questions = Question.all.where(private: false)
            render :index
        end
    end

end
