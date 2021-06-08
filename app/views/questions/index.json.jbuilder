@questions.each do |question|
    json.set! question.id do
        json.author question.user, partial: '/users/user', as: :user
        json.partial! '/questions/question', question: question 
        json.answers do
            question.answers.each do |answer|
                json.author answer.user, partial: '/users/user', as: :user
                json.partial! '/answers/answer', answer: answer
            end
        end
    end
end