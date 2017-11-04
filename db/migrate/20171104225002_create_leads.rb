class CreateLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :leads do |t|
      t.string :subject
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
