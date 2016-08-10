Sequel.migration do
  up do
    create_table :topics do
      primary_key :id
      Fixnum :comment_id
      String :topic_title
      String :tags
      String :topic_information
      String :num_comments
    end
  end

  down do
    drop_table :topics
  end
end
