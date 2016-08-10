Sequel.migration do
  up do
    create_table :blogs do
      primary_key :id
      String :title
      String :tags
      String :content
      Date :date
    end
  end

  down do
    drop_table :blogs
  end
end
