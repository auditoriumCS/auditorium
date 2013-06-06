module PollsHelper
  
  #link_to_function "Greeting", "alert('Hello world!')", :class => "nav_link"
  # => <a class="nav_link" href="#" onclick="alert('Hello world!'); return false;">Greeting</a>
  
  # Choices FORM
  def link_to_remove_fields(name, f, options)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", options)
  end
  
  # Choices FORM
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

end
