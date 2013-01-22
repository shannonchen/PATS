-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
-- -----------------------------------------
--
-- Total Costs Option 1: create functions that can be called within a transaction
-- (...see EOF for option 2 with triggers)
-- calculate total costs 
CREATE OR REPLACE FUNCTION recalculate_total_costs(v_id int) RETURNS INTEGER AS $$
	DECLARE
		visit_date date;
		medicine_costs integer;
		treatment_costs integer;
		total integer;
	BEGIN
		visit_date = (select date from visits where id = v_id);
		medicine_costs = (
			select round(coalesce(sum((1.0 - discount) * units_given * cost_per_unit),0))
			from visit_medicines vm join medicine_costs mc on vm.medicine_id=mc.medicine_id 
			where vm.visit_id = v_id and mc.start_date <= visit_date and (mc.end_date >= visit_date or mc.end_date is null)
			);
		treatment_costs = (
			select round(coalesce(sum((1.0 - discount) * cost),0))
			from treatments tr join procedure_costs pc on tr.procedure_id=pc.procedure_id 
			where tr.visit_id = v_id and pc.start_date <= visit_date and (pc.end_date >= visit_date or pc.end_date is null)
			);
		total = medicine_costs + treatment_costs;
		update visits set total_charge = total where id = v_id;
	  RETURN total;
	END;
	$$ LANGUAGE plpgsql;


-- calculate_overnight_stay
CREATE OR REPLACE FUNCTION calculate_overnight_stay(v_id int) RETURNS INTEGER AS $$
	DECLARE
		sum_treatment_minutes integer;
	BEGIN
		sum_treatment_minutes = (
			select sum(length_of_time)
			from treatments tr join procedures pr on tr.procedure_id=pr.id 
			where tr.visit_id = v_id 
			);
		IF sum_treatment_minutes > 719 THEN
		    update visits set overnight_stay = true where id = v_id;
		ELSE
		    update visits set overnight_stay = false where id = v_id;
		END IF;
	  RETURN sum_treatment_minutes;
	END;
	$$ LANGUAGE plpgsql;


-- set_end_date_for_medicine_costs
CREATE OR REPLACE FUNCTION set_end_date_for_medicine_costs() RETURNS TRIGGER AS $$
	DECLARE 
		newest_record_id integer;
		medicine_id_changed integer;
		previous_record_id integer;
	BEGIN
		newest_record_id = (select currval('medicine_costs_id_seq'));
		medicine_id_changed = (select medicine_id from medicine_costs where id = newest_record_id);
		previous_record_id = (select id from medicine_costs where medicine_id = medicine_id_changed and end_date is null and id != newest_record_id);
		update medicine_costs set end_date = current_date where id = previous_record_id;
	  RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER set_end_date_for_previous_medicine_cost
AFTER INSERT ON medicine_costs
EXECUTE PROCEDURE set_end_date_for_medicine_costs();


-- set_end_date_for_procedure_costs
CREATE OR REPLACE FUNCTION set_end_date_for_procedure_costs() RETURNS TRIGGER AS $$
DECLARE 
	newest_record_id integer;
	procedure_id_changed integer;
	previous_record_id integer;
BEGIN
	newest_record_id = (select currval('procedure_costs_id_seq'));
	procedure_id_changed = (select procedure_id from procedure_costs where id = newest_record_id);
	previous_record_id = (select id from procedure_costs where procedure_id = procedure_id_changed and end_date is null and id != newest_record_id);
	update procedure_costs set end_date = current_date where id = previous_record_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_end_date_for_previous_procedure_cost
AFTER INSERT ON procedure_costs
EXECUTE PROCEDURE set_end_date_for_procedure_costs();


-- decrease_stock_amount_after_dosage
CREATE OR REPLACE FUNCTION decrease_stock_amount_after_dosage() RETURNS TRIGGER AS $$
	DECLARE
		last_vm_id integer;
		medicine_id_given integer;
		current_stock integer;
		amount_given integer;
		decrease_to integer;
	BEGIN
		last_vm_id = (select currval('visit_medicines_id_seq'));
		medicine_id_given = (select medicine_id from visit_medicines where id = last_vm_id);
		current_stock = (select stock_amount from medicines where id = medicine_id_given);
		amount_given = (select units_given from visit_medicines where id = last_vm_id);
		decrease_to = current_stock - amount_given;
		update medicines set stock_amount = decrease_to where id = medicine_id_given;
	  RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stock_amount_for_medicines
AFTER INSERT ON visit_medicines
EXECUTE PROCEDURE decrease_stock_amount_after_dosage();


-- verify_that_medicine_requested_in_stock
CREATE OR REPLACE FUNCTION verify_that_medicine_requested_in_stock(medicine_id int, units_requested int) RETURNS BOOLEAN AS $$
	DECLARE
		current_stock integer;
		enough boolean;
	BEGIN
		current_stock = (select stock_amount from medicines where id = medicine_id);
		IF units_requested > current_stock THEN 
			enough = FALSE;
		ELSE
			enough = TRUE;
		END IF;
	  RETURN enough;
	END;
	$$ LANGUAGE plpgsql;


-- verify_that_medicine_is_appropriate_for_pet
CREATE OR REPLACE FUNCTION verify_that_medicine_is_appropriate_for_pet(medicine_id int, pet_id int) RETURNS BOOLEAN AS $$
	DECLARE
    pet_animal_id integer;
		is_listed integer;
		approved boolean;
	BEGIN
		pet_animal_id = (select animal_id from pets where id = pet_id);
		is_listed = (select count(*) from animal_medicines where animal_id = pet_animal_id and medicine_id = medicine_id);
		IF is_listed = 0 THEN 
			approved = FALSE;
		ELSE
			approved = TRUE;
		END IF;
	  RETURN approved;
	END;
	$$ LANGUAGE plpgsql;

