require 'rails_helper'

#happy 
RSpec.describe Api::AuthenticationController, type: :controller do
    describe "POST #signup" do
        context "with valid parameters" do
            let(:valid_params) do
                {
                    name: 'Test user',
                    email: 'tesuser@example.com',
                    password: '123@mksd',
                    password_confirmation: '123@mksd',
                    image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/fiels/me.png'), 'image/png')
                }
            end

            it "creates a new user" do
                expect {
                    post :signup, params: valid_params
                }.to change(User, :count).by(1)
            end

            it "returns a token and user data" do
                post :signup, params: valid_params
                json_response = JSON.parse(response.body)
                expect(response).to have_http_status(:created)
                expect(json_response).to include("token", "user")
            end
        end

        #unhappy
        context "with invalid parameters" do
            let(:invalid_params) do
                {
                    name: '',
                    email: 'this is my email.cmo',
                    password: 'muhmmad123',
                    password_confirmation: '123muhammad',
                    image: ''
                }
            end

            it "does not create a user" do
                expect {
                    post :signup, params: invalid_params
                }.not_to change(User, :count)
            end

            it "returns an error" do
                post :signup, params: invalid_params
                json_response = JSON.parse(response.body)

                expect(response).to have_http_status(:unprocessable_entity)
                expect(json_response["error"]).to eq('Something went wrong')
            end
        end
    end
end