require 'test_helper'

class ViewsHelperTest < ActionView::TestCase

  include Errdo::Helpers::ViewsHelper

  context "methods" do
    context "user_show_string" do
      should "default to email" do
        @user = users(:user)
        assert_equal @user.email, user_show_string(@user)
      end

      should "correctly respond to changing the user_string_method" do
        @user = users(:user)
        Errdo.stub :user_string_method, :user_string do
          assert_equal @user.user_string, user_show_string(@user)
        end
      end
    end

    context "user_show_path" do
      should "default to nil when nothing set" do
        @user = users(:user)
        Errdo.stub :user_show_path, nil do
          assert_nil user_show_path(@user)
        end
      end

      should "correctly respond to changing the user_show_page" do
        @user = users(:user)
        Errdo.stub :user_show_path, "user_path" do
          assert_equal user_path(@user.id), user_show_path(@user)
        end
      end
    end
  end

end
