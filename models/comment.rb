class Comment < Sequel::Model
  def before_create
    super
    self.vote_count ||= 0
  end

end
