Sequel.migration do
  up do
    alter_table(:comments) do
      drop_column :num_of_upvote
      drop_column :num_of_downvote
      add_column :vote_count, Integer
    end
  end

  down do
    alter_table(:comments) do
      add_column :num_of_upvote, String
      add_column :num_of_downvote, String
      drop_column :vote_count
    end
  end
end
