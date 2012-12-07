class AddFkeys < ActiveRecord::Migration
  def up

  	add_foreign_key(:pets, :owners)
	add_foreign_key(:pets, :animals)
	add_foreign_key(:visits, :pets)
	add_foreign_key(:animal_medicines, :animals)
	add_foreign_key(:animal_medicines, :medicines)
	add_foreign_key(:visit_medicines, :visits)
	add_foreign_key(:visit_medicines, :medicines)
	add_foreign_key(:treatments, :visits)
	add_foreign_key(:treatments, :procedures)
	add_foreign_key(:procedure_costs, :procedures)
	add_foreign_key(:medicine_costs, :medicines)
	add_foreign_key(:notes, :users)
	
  end

  def down
  end
end

