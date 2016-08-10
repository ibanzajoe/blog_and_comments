Sequel.migration do
  up do
    create_table :docu_texts do
      primary_key :id
      String :title
      String :language
      String :tags
      String :answer
      String :context
      String :example
    end
  end

  down do
    drop_table :docu_texts
  end
end
