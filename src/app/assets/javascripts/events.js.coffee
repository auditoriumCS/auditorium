jQuery ->
  $('#studentview-event-details').hide()
  $('#toggle-event-details').click (e) ->
    e.preventDefault()
    $('#studentview-event-details').toggle()
    if $(this).text() == 'Show event details'
      $(this).text('Hide event details')
    else
      $(this).text('Show event details')
