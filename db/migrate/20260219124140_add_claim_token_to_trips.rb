class AddClaimTokenToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :claim_token, :string
    add_index :trips, :claim_token, unique: true, where: "claim_token IS NOT NULL"
  end
end
