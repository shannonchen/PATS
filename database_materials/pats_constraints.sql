-- CONSTRAINTS FOR PATS DATABASE
--
-- (Note: both 'medicine_costs_medicine_id_fkey' and 'procedures_costs_procedure_id_fkey' 
--  are set for ON DELETE CASCADE, not the standard 'restrict')
--
-- FOREIGN KEYS:
--
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


--
-- CHECK CONSTRAINTS  (not exhaustive and not all required for credit in phase 2)
-- 
-- checks for consistency in medicine_costs and procedure_costs dates
ALTER TABLE medicine_costs ADD CONSTRAINT medicine_costs_check_date_order CHECK (end_date >= start_date);
ALTER TABLE procedure_costs ADD CONSTRAINT procedure_costs_check_date_order CHECK (end_date >= start_date);

-- checks that other dates are today or in the past  (nice, but not essential from grading perspective)
ALTER TABLE pets ADD CONSTRAINT pets_date_of_birth_not_in_future CHECK (date_of_birth <= current_date);
ALTER TABLE visits ADD CONSTRAINT visits_date_not_in_future CHECK (date <= current_date);
ALTER TABLE notes ADD CONSTRAINT notes_date_not_in_future CHECK (date <= current_date);

-- checks for positive (or nonnegative) numbers on key fields
ALTER TABLE procedure_costs ADD CONSTRAINT procedure_costs_cost_is_nonnegative CHECK (cost >= 0);
ALTER TABLE medicine_costs ADD CONSTRAINT medicine_costs_cost_is_nonnegative CHECK (cost_per_unit >= 0);
ALTER TABLE medicines ADD CONSTRAINT medicines_stock_amount_is_nonnegative CHECK (stock_amount >= 0);
ALTER TABLE animal_medicines ADD CONSTRAINT animal_medicines_rec_units_is_nonnegative CHECK (recommended_num_of_units >= 0);
ALTER TABLE procedures ADD CONSTRAINT procedures_length_of_time_is_nonnegative CHECK (length_of_time >= 0);
ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicines_units_given_is_positive CHECK (units_given > 0);

-- checks that discounts between 0 and 1
ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicines_discount_between_0_and_1 CHECK (discount >= 0.00 and discount <= 1.00);
ALTER TABLE treatments ADD CONSTRAINT treatments_discount_between_0_and_1 CHECK (discount >= 0.00 and discount <= 1.00);

-- check for phone being 10 digits
ALTER TABLE owners ADD CONSTRAINT owners_check_phone CHECK (((phone)::text ~* '^\d{10}$'::text));

-- skipping other regex checks on names, etc. (nice, but less value)