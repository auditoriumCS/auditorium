module PollsHelper
  
  
  def add_choice_link(name)
    link_to_function(name, nil) do |page|
      page.insert_html :bottom, :choice, :partial => 'choice', :object => Choice.new
    end
  end
   # link_to_function("Show me more", nil, :id => "more_link") do |page|
  # page[:details].visual_effect :toggle_blind
  # page[:more_link].replace_html "Show me less"
  # end 

end
