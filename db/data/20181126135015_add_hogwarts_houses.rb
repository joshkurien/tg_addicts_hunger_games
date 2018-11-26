class AddHogwartsHouses < SeedMigration::Migration
  def up
    Group.destroy_all
    Group.create(id: 1, name: 'Gryffindor', symbol: '🦁')
    Group.create(id: 2, name: 'Ravenclaw', symbol: '🦅')
    Group.create(id: 3, name: 'Slytherin', symbol: '🐍')
    Group.create(id: 4, name: 'Hufflepuff', symbol: '🐿')
  end

  def down
    Group.destroy_all
  end
end
