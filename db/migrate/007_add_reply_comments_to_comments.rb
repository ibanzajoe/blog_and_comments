Sequel.migration do
  up do
    alter_table(:comments) do
      add_column :child_of, Fixnum
    end
  end

  down do
    alter_table(:comments) do
      drop_column :child_of
    end
  end
end
