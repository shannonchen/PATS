
-- Total Costs Option 2: set up triggers that fire after new
-- meds or treatments given (or revised).
-- Note point made in class about multiple triggers using the 
-- same function.

-- -------------------------
-- INSERT  & UPDATE TRIGGERS
-- -------------------------
CREATE OR REPLACE FUNCTION recalculate_total_costs() RETURNS TRIGGER AS $$
	DECLARE
	  for_visit_id integer;
		visit_date date;
		medicine_cost integer;
		treatment_cost integer;
		change_to integer;
	BEGIN
		for_visit_id = (NEW.visit_id);
		visit_date = (select date from visits where id = for_visit_id);
		medicine_cost = (
			select round(coalesce(sum((1.0 - discount) * units_given * cost_per_unit),0))
			from visit_medicines vm join medicine_costs mc on vm.medicine_id=mc.medicine_id 
			where vm.visit_id = for_visit_id and mc.start_date <= visit_date and (mc.end_date >= visit_date or mc.end_date is null)
			);
		treatment_cost = (
			select round(coalesce(sum((1.0 - discount) * cost),0))
			from treatments tr join procedure_costs pc on tr.procedure_id=pc.procedure_id 
			where tr.visit_id = for_visit_id and pc.start_date <= visit_date and (pc.end_date >= visit_date or pc.end_date is null)
			);
		change_to = medicine_cost + treatment_cost;
		update visits set total_charge = change_to where id = for_visit_id;
	  RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;

-- now the two triggers that use the function...
CREATE TRIGGER update_total_costs_for_medicines_on_insert
AFTER INSERT OR UPDATE ON visit_medicines
FOR EACH ROW EXECUTE PROCEDURE recalculate_total_costs();

CREATE TRIGGER update_total_costs_for_treatments_on_insert
AFTER INSERT OR UPDATE ON treatments
FOR EACH ROW EXECUTE PROCEDURE recalculate_total_costs();


-- ----------------
-- DELETE TRIGGERS
-- ----------------
-- Note point made in class as to why this function is slightly
-- different from the previous recalc function.

CREATE OR REPLACE FUNCTION recalculate_total_costs_after_deletion() RETURNS TRIGGER AS $$
	DECLARE
    for_visit_id integer;
		visit_date date;
		medicine_cost integer;
		treatment_cost integer;
		change_to integer;
	BEGIN
		for_visit_id = (OLD.visit_id);
		visit_date = (select date from visits where id = for_visit_id);
		medicine_cost = (
			select round(coalesce(sum((1.0 - discount) * units_given * cost_per_unit),0))
			from visit_medicines vm join medicine_costs mc on vm.medicine_id=mc.medicine_id 
			where vm.visit_id = for_visit_id and mc.start_date <= visit_date and (mc.end_date >= visit_date or mc.end_date is null)
			);
		treatment_cost = (
			select round(coalesce(sum((1.0 - discount) * cost),0))
			from treatments tr join procedure_costs pc on tr.procedure_id=pc.procedure_id 
			where tr.visit_id = for_visit_id and pc.start_date <= visit_date and (pc.end_date >= visit_date or pc.end_date is null)
			);
		change_to = medicine_cost + treatment_cost;
		update visits set total_charge = change_to where id = for_visit_id;
	  RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;

-- Now the two trigger that use the function...
CREATE TRIGGER update_total_costs_for_medicine_deleted
AFTER DELETE ON visit_medicines
FOR EACH ROW EXECUTE PROCEDURE recalculate_total_costs_after_deletion();

CREATE TRIGGER update_total_costs_for_treatment_deleted
AFTER DELETE ON treatments
FOR EACH ROW EXECUTE PROCEDURE recalculate_total_costs_after_deletion();


-- ------------------
-- OVERNIGHT TRIGGERS
-- ------------------
CREATE OR REPLACE FUNCTION recalculate_overnight_stay() RETURNS TRIGGER AS $$
	DECLARE
		sum_treatment_minutes integer;
	BEGIN
		sum_treatment_minutes = (
			select sum(length_of_time)
			from treatments tr join procedures pr on tr.procedure_id=pr.id 
			where tr.visit_id = NEW.visit_id 
			);
		IF sum_treatment_minutes > 719 THEN
		    update visits set overnight_stay = true where id = NEW.visit_id;
		ELSE
		    update visits set overnight_stay = false where id = NEW.visit_id;
		END IF;
	  RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;
	
CREATE TRIGGER update_overnight_stay_flag
AFTER INSERT OR UPDATE ON treatments
FOR EACH ROW EXECUTE PROCEDURE recalculate_overnight_stay();