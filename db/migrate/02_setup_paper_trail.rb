class SetupPaperTrail < ActiveRecord::Migration

  def self.up

    create_table :versions do |t|
      t.string   :item_type, null: false
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.integer  :transaction_id
      t.text     :object
      t.text     :object_changes
      t.datetime :created_at
    end

    add_index :versions, [:transaction_id]

    create_table :version_associations do |t|
      t.integer  :version_id
      t.string   :foreign_key_name, null: false
      t.integer  :foreign_key_id
    end

    add_index :version_associations, [:version_id]
    add_index :version_associations,
      [:foreign_key_name, :foreign_key_id],
      name: "index_version_associations_on_foreign_key"
  end

end
