class AddDistricts < SeedMigration::Migration
  def up
    District.create(name: 'Fisherman district', symbol: '🐟')
    District.create(name: 'Labor district', symbol: '⚒')
    District.create(name: 'Power district', symbol: '⚡️')
    District.create(name: 'Nature district', symbol: '🦋')
    District.create(name: 'Luxury district', symbol: '💎')
  end

  def down
    District.destroy_all
  end
end
