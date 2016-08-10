Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :first_name
      String :last_name
      String :password
      String :username
      String :user_bio
      Date :created_date

    end
  end

  down do
    drop_table :users
  end
end
