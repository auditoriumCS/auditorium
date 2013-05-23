function actualize() {
	var url = "poll_results/ajax_refresh";
	jQuery.post(
	url,
	{},
	function(s){
		var r = s.data;
		for(q in r){
			if(q.questiontext){
				var snippet = "";
				for(c in q.choices) if(c.id){
					snippet += '<div class="poll-result">';
					snippet += 	'<div class="poll-result-count">'+c.count+' of '+q.total+'  ( '+(c.count/q.total)*100+'% )</div>';
					snippet += 	'<h4>'+c.text+'</h4>';
					snippet += 	'<div class="poll-result-bar-wrap">';
					snippet += 	'<div class="poll-result-bar '+c.correct_class+'" style="width: '+(c.count/q.total)*100+'%"></div>';
					snippet += '</div>';
				}
				jQuery("#poll_result_"+q.id).html(snippet);
			}
		}
	});
	setTimeout('actualize',300);
}

jQuery(function(){
	actualize();
});