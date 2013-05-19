function actualize() {
	jQuery.post('',
	function(s){
		var r = s.data;
		for(q in r){
			if(q.questiontext){
				
			}
		}
	});
	setTimeout('actualize',300);
}