class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.string :new
      t.string :create
      t.string :destroy

      t.timestamps null: false
    end
  end
end
