-- Trigger to prevent number of planets in a system exceeding sy_pnum
CREATE TRIGGER check_planet_count
BEFORE INSERT ON planet
BEGIN
    SELECT CASE
        WHEN (
            SELECT COUNT(*) + 1
            FROM planet
            WHERE hostname = NEW.hostname
        ) > (
            SELECT sy_pnum
            FROM system
            WHERE sys_name = NEW.hostname
        )
        THEN RAISE(ABORT, 'Number of planets cannot exceed system planet count (sy_pnum)')
    END;
END;

-- Another trigger to prevent number of planets in a system exceeding sy_pnum
CREATE TRIGGER check_planet_count_update
BEFORE UPDATE ON system
WHEN NEW.sy_pnum != OLD.sy_pnum
BEGIN
    SELECT CASE
        WHEN NEW.sy_pnum < (
            SELECT COUNT(*)
            FROM planet
            WHERE hostname = NEW.sys_name
        )
        THEN RAISE(ABORT, 'New system planet count cannot be less than the number of planets currently in the database')
    END;
END;

-- Trigger to cascade delete planet_has_molecule entries when a planet is deleted
CREATE TRIGGER cascade_delete_planet
BEFORE DELETE ON planet
BEGIN
    DELETE FROM planet_has_molecule
    WHERE pl_name = OLD.pl_name;
END;

-- Trigger to cascade delete planet_has_molecule entries when a molecule is deleted
CREATE TRIGGER cascade_delete_molecule
BEFORE DELETE ON molecule
BEGIN
    DELETE FROM planet_has_molecule 
    WHERE molecule_id = OLD.id;
END;

-- Trigger to ensure discovery date is not in the future
CREATE TRIGGER check_discovery_date
BEFORE INSERT ON discovery
BEGIN
    SELECT CASE
        WHEN NEW.disc_pubdate > date('now') 
        THEN RAISE(ABORT, 'Discovery date cannot be in the future')
    END;
END;

-- Trigger to validate discovery reference format
CREATE TRIGGER check_discovery_format_insert
BEFORE INSERT ON discovery
BEGIN
    SELECT CASE
        WHEN NEW.disc_refname NOT LIKE '<a refstr=%' 
        THEN RAISE(ABORT, 'Invalid discovery reference format')
    END;
END;

-- Trigger to validate discovery reference format
CREATE TRIGGER check_discovery_format_update
BEFORE UPDATE ON discovery
BEGIN
    SELECT CASE
        WHEN NEW.disc_refname NOT LIKE '<a refstr=%' 
        THEN RAISE(ABORT, 'Invalid discovery reference format')
    END;
END;
