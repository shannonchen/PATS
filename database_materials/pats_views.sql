-- VIEWS FOR PATS DATABASE
--
--

CREATE VIEW owners_view AS 
	SELECT o.id AS "owner id", o.last_name, o.first_name, o.street, o.city, o.state, o.zip, o.phone, o.email, o.active AS "owner active"
	, p.id AS "pet id", p.name, a.name AS "animal name", p.female, p.date_of_birth, p.active AS "pet active"
	, v.id AS "visit_id", v.date, v.weight, v.overnight_stay, v.total_charge 
	FROM owners o JOIN pets p ON o.id=p.owner_id JOIN animals a ON a.id=p.animal_id LEFT JOIN visits v ON v.pet_id = p.id
	ORDER BY o.last_name, o.first_name, p.name;



CREATE VIEW medicine_view AS
	SELECT m.id, m.name, m.description, m.stock_amount, m.method, m.unit, m.vaccine
	, mc.cost_per_unit, mc.start_date, mc.end_date, a.name AS "animal name", am.recommended_num_of_units
	FROM (medicines m JOIN medicine_costs mc ON m.id=mc.medicine_id) 
	JOIN (animal_medicines am JOIN animals a ON a.id=am.animal_id) on m.id=am.medicine_id
	ORDER BY m.name, a.name, mc.cost_per_unit;