# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


  # info and question details
jQuery ->

  $(".remove-cross").click ->
    if confirm "do you want to unsubscribe \"#{$(this).data('name')}\""
      alert "this has not been implemented yet"
    return false



  $(".question-details").hide()

  $("a.info, a.question").click ->
    link = $(this)
    course_id = link.data('id')
    type = link.data('type')

    if $("##{type}-details-#{course_id}").is ":hidden"
      $("##{type}-details-#{course_id}").slideDown()
      link.children(".chevron").addClass("icon-chevron-down")
      link.children(".chevron").removeClass("icon-chevron-right")
    else
      $("##{type}-details-#{course_id}").slideUp()
      link.children(".chevron").removeClass("icon-chevron-down")
      link.children(".chevron").addClass("icon-chevron-right")

    return false
