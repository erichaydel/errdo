require 'test_helper'

class Ability

  include CanCan::Ability

  def initialize(user)
    if user && user.loser?
      cannot :manage, Errdo::Error
    else
      can :manage, Errdo::Error
    end
  end

end

class AuthorizationIntegrationTest < ActionDispatch::IntegrationTest

  context "cancancan" do
    setup do
      Errdo.authorize_with :cancan

      @error = FactoryGirl.create(:error)
      @error_occurrence = FactoryGirl.create(:error_occurrence, error: @error)

      @errdo = Errdo::Engine.routes.url_helpers
    end

    context "unallowed user" do
      setup do
        @loser = users(:loser)
        _sign_in @loser
      end

      should "not be able to get the errors index" do
        get @errdo.root_path
        assert_response :redirect
      end

      should "not be able to get the error show page" do
        # For some reason, the first one always returns 404
        get @errdo.error_path(@error)
        assert_response :redirect
      end

      should "not be able to update the error" do
        put @errdo.error_path(@error), error: { status: "wontfix" }
        assert_response :redirect
        assert_not @error.reload.wontfix?
      end
    end

    context "allowed user" do
      # only test one thing because if one is good, they should all be good
      setup do
        @user = users(:user)
        _sign_in @user
      end

      should "be able to get the errors index" do
        get @errdo.root_path
        assert_response :success
      end
    end
  end

  context "custom authorization block" do
    setup do
      Errdo.authorize_with do
        redirect_to root_path if warden.user.loser?
      end

      @error = FactoryGirl.create(:error)
      @error_occurrence = FactoryGirl.create(:error_occurrence, error: @error)

      @errdo = Errdo::Engine.routes.url_helpers
    end

    context "unallowed user" do
      setup do
        @loser = users(:loser)
        _sign_in @loser
      end

      should "not be able to get the errors index" do
        get @errdo.root_path
        assert_response :redirect
      end

      should "not be able to get the error show page" do
        # For some reason, the first one always returns 404
        get @errdo.error_path(@error)
        assert_response :redirect
      end

      should "not be able to update the error" do
        put @errdo.error_path(@error), error: { status: "wontfix" }
        assert_response :redirect
        assert_not @error.reload.wontfix?
      end
    end

    context "allowed user" do
      # only test one thing because if one is good, they should all be good
      setup do
        @user = users(:user)
        _sign_in @user
      end

      should "be able to get the errors index" do
        get @errdo.root_path
        assert_response :success
      end
    end
  end

  private

  def _sign_in(user)
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => 'foobar'
  end

end
