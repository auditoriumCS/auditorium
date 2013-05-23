function actualize(eId) {
	var url = "/poll_results/refresh/"+eId;
	jQuery.get(
	url,
	{},
	function(s){
		var r = s;
		for(q in r){
			if(r[q].text){
				var snippet = "";
				var pie = "";
				for(c in r[q].choices) if(r[q].choices[c].text){
					snippet += '<div class="poll-result">';
					snippet += 	'<div class="poll-result-count">'+r[q].choices[c].count+' of '+r[q].total+'  ( '+Math.floor((r[q].choices[c].count/r[q].total)*100+'% ))</div>';
					snippet += 	'<h4>'+r[q].choices[c].text+'</h4>';
					snippet += 	'<div class="poll-result-bar-wrap">';
					snippet += 	'<div class="poll-result-bar '+r[q].choices[c].correct_class+'" style="width: '+(r[q].choices[c].count/r[q].total)*100+'%"></div>';
					if(c < r[q].choices.length)
						pie += r[q].choices[c].count + ",";
					else
						pie += r[q].choices[c].count;
					snippet += '</div>';
				}
				snippet +=  '<span class="sparklines" sparkType="pie" sparkBarColor="red"><!-- '+pie+' --></span>'
				jQuery("#poll_result_"+q).html(snippet);
				jQuery(".sparklines").sparkline({width:200,height:200});
			}
		}
	});
	setTimeout(function(){actualize(eId)},1500);
}