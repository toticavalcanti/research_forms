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
          get "/api/v1/forms/#{@form.friendly_id}", params: {id: @form.friendly_id}, headers: header_with_authentication(@user)
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

  describe "POST /forms" do

    context "With Invalid authentication headers" do
      it_behaves_like :deny_without_authorization, :post, "/api/v1/forms"
    end

    context "With valid authentication headers" do
      before do
        @user = create(:user)
      end

      context "And with valid params" do
        before do
          @form_attributes = attributes_for(:form)
          post "/api/v1/forms", params: {form: @form_attributes}, headers: header_with_authentication(@user)
        end

        it "returns 200" do
          expect_status(200)
        end

        it "form are created with correct data" do
          @form_attributes.each do |field|
            expect(Form.first[field.first]).to eql(field.last)
          end
        end

        it "Returned data is correct" do
          @form_attributes.each do |field|
            expect(json[field.first.to_s]).to eql(field.last)
          end
        end
      end

      context "And with invalid params" do
        before do
          @other_user = create(:user)
          post "/api/v1/forms", params: {form: {}}, headers: header_with_authentication(@user)
        end

        it "returns 400" do
          expect_status(400)
        end
      end
    end
  end

  describe "PUT /forms/:friendly_id" do

    context "With Invalid authentication headers" do
      it_behaves_like :deny_without_authorization, :put, "/api/v1/forms/questionary"
    end

    context "With valid authentication headers" do
      before do
        @user = create(:user)
      end

      context "When form exists" do

        context "And user is the owner" do
          before do
            @form = create(:form, user: @user)
            @form_attributes = attributes_for(:form, id: @form.id)
            put "/api/v1/forms/#{@form.friendly_id}", params: {form: @form_attributes}, headers: header_with_authentication(@user)
          end

          it "returns 200" do
            expect_status(200)
          end

          it "form are updated with correct data" do
            @form.reload
            @form_attributes.each do |field|
              expect(@form[field.first]).to eql(field.last)
            end
          end

          it "Returned data is correct" do
            @form_attributes.each do |field|
              expect(json[field.first.to_s]).to eql(field.last)
            end
          end
        end

        context "And user is not the owner" do
          before do
            @form = create(:form)
            @form_attributes = attributes_for(:form, id: @form.id)
            put "/api/v1/forms/#{@form.friendly_id}", params: {form: @form_attributes}, headers: header_with_authentication(@user)
          end

          it "returns 403" do
            expect_status(403)
          end
        end
      end

      context "When form dont exists" do
        before do
          @form_attributes = attributes_for(:form)
        end

        it "returns 404" do
          delete "/api/v1/forms/#{FFaker::Lorem.word}", params: {form: @form_attributes}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end
  end

  describe "DELETE /forms/:friendly_id" do
    before do
      @user = create(:user)
    end

    context "With Invalid authentication headers" do
      it_behaves_like :deny_without_authorization, :delete, "/api/v1/forms/questionary"
    end

    context "With valid authentication headers" do

      context "When form exists" do

        before do 
          @user = create(:user)
        end

        context "And user is the owner" do
          before do
            @form = create(:form, user: @user)
            delete "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
          end

          it "returns 200" do
            expect_status(200)
          end

          it "form are deleted" do
            expect(Form.all.count).to eql(0)
          end
        end

        context "And user is not the owner" do
          before do
            @form = create(:form)
            delete "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
          end

          it "returns 403" do
            expect_status(403)
          end
        end
      end

      context "When form don't exists" do
        
        before do 
          @user = create(:user)
        end
        
        it "returns 404" do
          delete "/api/v1/forms/#{FFaker::Lorem.word}", params: {}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end

      context "When form exists" do

        context "And user is the owner" do
          before do
            @form = create(:form, user: @user)
            delete "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
          end

          it "returns 200" do
            expect_status(200)
          end

          it "form are deleted" do
            expect(Form.all.count).to eql(0)
          end
        end

        context "And user is not the owner" do
          before do
            @form = create(:form)
            delete "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
          end

          it "returns 403" do
            expect_status(403)
          end
        end
      end

      context "When form dont exists" do
        it "returns 404" do
          delete "/api/v1/forms/#{FFaker::Lorem.word}", params: {}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end
  end
end