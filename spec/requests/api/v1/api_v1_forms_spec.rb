require 'rails_helper'

RSpec.describe "Api::V1::Forms", type: :request do
  describe "GET /forms" do
    context "With Invalid authentication headers" do
      it_behaves_like :deny_without_authorization, :get, "/api/v1/forms"
    end

    context "With Valid authentication headers" do
      before do
        @user = create(:user)
        @form1 = create(:form, user: @user)
        @form2 = create(:form, user: @user)

        get "/api/v1/forms", params: {}, headers: header_with_authentication(@user)
      end

      it "returns 200" do
        expect_status(200)
      end

      it "returns Form list with 2 forms" do
        expect(json.count).to eql(2)
      end

      it "returned Forms have right datas" do
        expect(json[0]).to eql(JSON.parse(@form1.to_json))
        expect(json[1]).to eql(JSON.parse(@form2.to_json))
      end
    end
  end

  describe "GET /forms/:friendly_id" do
    before do
      @user = create(:user)
    end
 
    context "When form exists" do
 
      context "And is enable" do
        before do
          @form = create(:form, user: @user, enable: true)
        end
 
        it "returns 200" do
          get "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
          expect_status(200)
        end
 
        it "returned Form with right datas" do
          get "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
          expect(json).to eql(JSON.parse(@form.to_json))
        end
      end
 
      context "And is unable" do
        before do
          @form = create(:form, user: @user, enable: false)
        end
 
        it "returns 404" do
          get "/api/v1/forms/#{FFaker::Lorem.word}", params: {id: @form.friendly_id}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end
 
    context "When form dont exists" do
      it "returns 404" do
        get "/api/v1/forms/#{FFaker::Lorem.word}", params: {}, headers: header_with_authentication(@user)
        expect_status(404)
      end
    end
  end
end