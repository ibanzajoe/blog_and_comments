Sequel.migration do
  up do
    create_table :comments do
      primary_key :id
      Fixnum :user_id
      String :subject
      String :tags
      String :content
      Boolean :op_yes_no
      String :next_down_comment_id
      String :num_of_views
      String :num_of_upvote
      String :num_of_downvote
      Date :date
    end
  end

  down do
    drop_table :comments
  end
end
