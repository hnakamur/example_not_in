class Post < ActiveRecord::Base
  acts_as_voteable
  scope :voted_by, lambda{|voter_id|
    joins(:votes).where(votes: {voter_id: voter_id})
  }
  scope :not_voted_by, lambda{|voter_id|
    where("NOT EXISTS (SELECT * FROM votes WHERE votes.voteable_id = posts.id AND votes.voteable_type = ? AND votes.voter_id = ?)", 'Post', voter_id)
  }
end
