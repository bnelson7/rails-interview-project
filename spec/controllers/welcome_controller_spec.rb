require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
    describe 'GET #index' do
        it 'render dashboard' do
            get :index
            expect(response).to render_template(:index)
            expect(response).to have_http_status(200)
            response.header['Content-Type'].should include 'text/html'
        end
    end
end
