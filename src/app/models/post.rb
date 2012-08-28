class Post < ActiveRecord::Base
  belongs_to :parent, class_name: 'Post'
  has_many :children, foreign_key: :parent_id, class_name: 'Post', :dependent => :destroy

  belongs_to :answer_to, class_name: 'Post'
  has_one :answer, foreign_key: :answer_to_id, class_name: 'Post'

  belongs_to :course
  belongs_to :author, class_name: 'User'
   
  has_many :tags 
   
  attr_accessible :body, :subject, :post_type, :parent_id, :course_id, :author_id, :answer_to_id

  validates :post_type, presence: true, inclusion: { in: %w{question answer info comment} }
  validates :subject, presence: true
  validates :course, presence: true
  validates :body, presence: true
  validates :author, presence: true

  define_index do
    indexes subject
    indexes body
    set_property :enable_star => true
    set_property :min_infix_len => 2
  end

  after_save do
    author.update_score if rating_changed?
  end

  # TODO think about private posts again
  
  # get answers and comments to this post if any
   def answers
     Post.find_all_by_post_type_and_parent_id('answer', self.id)
   end

   def comments
     Post.find_all_by_post_type_and_parent_id('comment', self.id)
   end
  
   def is_parent?
     self.parent_id == nil
   end
  
    def author_name
      if not self.author.nil?
        return self.author.full_name
      else
        return "deleted person"
      end        
    end
end
