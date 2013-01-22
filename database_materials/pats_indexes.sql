-- INDEXES FOR PATS DATABASE
--
--
-- indexing all FKs (tend to be common queries)
--
CREATE INDEX pets_owners_idx ON pets(owner_id);

CREATE INDEX pets_animals_idx ON pets(animal_id);

CREATE INDEX visits_pets_idx ON visits(pet_id);

CREATE INDEX medicine_costs_medicines_idx ON medicine_costs(medicine_id);

CREATE INDEX animal_medicines_medicines_idx ON animal_medicines(medicine_id);

CREATE INDEX animal_medicines_animals_idx ON animal_medicines(animal_id);

CREATE INDEX visit_medicines_medicines_idx ON visit_medicines(medicine_id);

CREATE INDEX visit_medicines_visits_idx ON visit_medicines(visit_id);

CREATE INDEX treatments_visits_idx ON treatments(visit_id);

CREATE INDEX treatments_procedures_idx ON treatments(procedure_id);

CREATE INDEX procedure_costs_procedures_idx ON procedure_costs(procedure_id);

CREATE INDEX notes_users_idx ON notes(user_id);

--
-- indexing a few other common queries/sorts
--
CREATE INDEX owners_names_idx ON owners(lower(last_name), lower(first_name));

CREATE INDEX pets_names_idx ON pets(lower(name));

CREATE INDEX visits_dates_idx ON visits(date);