class AddCapitolDistrict < SeedMigration::Migration
  def up
    District.create(id: 0, name: 'Capitol district', symbol: '👑')
  end

  def down
    District.find(0).destroy
  end
end
