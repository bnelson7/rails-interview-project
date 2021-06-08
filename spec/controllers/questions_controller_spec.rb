require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
    describe 'GET #index' do
        tenant = Tenant.create!(name: "test tenant")
        context 'with valid api key' do
            it 'renders questions with answers as json and tracks Tenants API request count' do
                request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{tenant.api_key}\""
                get :index, :format => :json
                response.header['Content-Type'].should include 'application/json'
                expect(response).to render_template(:index)
                expect(response).to have_http_status(200)
            end
            it "doesn't return private questions" do
                request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{tenant.api_key}\""
                user = User.create!(name: "guy")
                private_question = Question.create!(private: true, user_id: user.id, title: "question title?")
                public_question = Question.create!(private: false, user_id: user.id, title: "question title?")
                get :index, :format => :json
                expect(JSON.parse(response.body).key?("#{public_question.id}")).to be true
                expect(JSON.parse(response.body).key?("#{private_question.id}")).to be false
                response.header['Content-Type'].should include 'application/json'
                expect(response).to render_template(:index)
                expect(response).to have_http_status(200)
            end
            it 'update tenants request counts' do 
                request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{tenant.api_key}\""
                prev_count = tenant.request_count
                get :index, :format => :json
                tenant.reload 
                expect(tenant.request_count).to be(prev_count + 1)
                response.header['Content-Type'].should include 'application/json'
                expect(response).to render_template(:index)
                expect(response).to have_http_status(200)
            end
        end
        context 'without valid api key' do
            it 'renders questions with answers as json' do
                get :index, :format => :json
                expect(response).to have_http_status(401)
            end
        end
  end
end
