class Question < Post
	def comments
		Post.where(post_type: 'comment', parent_id: self.id)
	end

	def answers
		Post.where(post_type: 'answer', parent_id: self.id)
	end

end
