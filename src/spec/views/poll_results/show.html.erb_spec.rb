require 'spec_helper'

describe "poll_results/show" do
  before(:each) do
    @poll_result = assign(:poll_result, stub_model(PollResult,
      :userId => 1,
      :questionId => 2,
      :choiceId => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
