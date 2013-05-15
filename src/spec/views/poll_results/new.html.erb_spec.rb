require 'spec_helper'

describe "poll_results/new" do
  before(:each) do
    assign(:poll_result, stub_model(PollResult,
      :userId => 1,
      :questionId => 1,
      :choiceId => 1
    ).as_new_record)
  end

  it "renders new poll_result form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", poll_results_path, "post" do
      assert_select "input#poll_result_userId[name=?]", "poll_result[userId]"
      assert_select "input#poll_result_questionId[name=?]", "poll_result[questionId]"
      assert_select "input#poll_result_choiceId[name=?]", "poll_result[choiceId]"
    end
  end
end
