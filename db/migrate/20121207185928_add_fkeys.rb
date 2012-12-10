class AddFkeys < ActiveRecord::Migration
  def up
  	EXECUTE <<-SQL

		ALTER TABLE pets ADD CONSTRAINT pets_owner_id_fkey FOREIGN KEY (owner_id)
		REFERENCES owners (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE pets ADD CONSTRAINT pets_animal_id_fkey FOREIGN KEY (animal_id)
		REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE visits ADD CONSTRAINT visits_pet_id_fkey FOREIGN KEY (pet_id)
		REFERENCES pets (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE medicine_costs ADD CONSTRAINT medicine_costs_medicine_id_fkey FOREIGN KEY (medicine_id)
		REFERENCES medicines (id) ON DELETE CASCADE ON UPDATE CASCADE;

		ALTER TABLE animal_medicines ADD CONSTRAINT animal_medicines_medicine_id_fkey FOREIGN KEY (medicine_id)
		REFERENCES medicines (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE animal_medicines ADD CONSTRAINT animal_medicines_animal_id_fkey FOREIGN KEY (animal_id)
		REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicines_medicine_id_fkey FOREIGN KEY (medicine_id)
		REFERENCES medicines (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicines_visit_id_fkey FOREIGN KEY (visit_id)
		REFERENCES visits (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE treatments ADD CONSTRAINT treatments_visit_id_fkey FOREIGN KEY (visit_id)
		REFERENCES visits (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE treatments ADD CONSTRAINT treatments_procedure_id_fkey FOREIGN KEY (procedure_id)
		REFERENCES procedures (id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE procedure_costs ADD CONSTRAINT procedures_costs_procedure_id_fkey FOREIGN KEY (procedure_id)
		REFERENCES procedures (id) ON DELETE CASCADE ON UPDATE CASCADE;

		ALTER TABLE notes ADD CONSTRAINT notes_user_id_fkey FOREIGN KEY (user_id)
		REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE;
			
	SQL
  end 
end