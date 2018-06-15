class AddDistricts < SeedMigration::Migration
  def up
    District.destroy_all
    District.create(id: 1, name: 'Fisherman district', symbol: '🐟')
    District.create(id: 2, name: 'Labor district', symbol: '⚒')
    District.create(id: 3, name: 'Power district', symbol: '⚡️')
    District.create(id: 4, name: 'Nature district', symbol: '🦋')
    District.create(id: 5, name: 'Luxury district', symbol: '💎')
  end

  def down
    District.destroy_all
  end
end
