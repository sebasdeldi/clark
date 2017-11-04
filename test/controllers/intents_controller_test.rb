require 'test_helper'

class IntentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get intents_index_url
    assert_response :success
  end

end
