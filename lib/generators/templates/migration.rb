class CreateResqueBackup < ActiveRecord::Migration
  def up
    create_table :resque_backups do |t|
      t.column :queue, :string
      t.column :klass, :string
      t.column :payload, :string
    end

    add_index :resque_backups, :queue
  end

  def down
    remove_table :resque_backups
  end
end
