require 'spec_helper'

describe "poll_results/index" do
  before(:each) do
    assign(:poll_results, [
      stub_model(PollResult,
        :userId => 1,
        :questionId => 2,
        :choiceId => 3
      ),
      stub_model(PollResult,
        :userId => 1,
        :questionId => 2,
        :choiceId => 3
      )
    ])
  end

  it "renders a list of poll_results" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
