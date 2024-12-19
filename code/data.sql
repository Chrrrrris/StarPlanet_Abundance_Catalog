CREATE VIEW KICNumbersView AS
SELECT 
    primary_id,
    SUBSTR(alternate_id, INSTR(alternate_id, 'KIC') + 4) AS kic_number
FROM 
    host_ids
WHERE 
    alternate_id LIKE 'KIC%';

CREATE VIEW PlanetStarAbundance AS
SELECT
    p.pl_name AS Planet_Name,
    p.hostname AS Star_Name,
    p.mass AS Planet_Mass,
    p.radius AS Planet_Radius,
    json_group_array(DISTINCT m.name) AS Detected_Molecules,
    (SELECT json_group_object(ea.Element_Ratio, ea.Abundance) 
     FROM elemental_abundances ea 
     WHERE ea.StellarID = p.hostname) AS Star_Elemental_Abundances,
    (SELECT json_group_object(ea.Element_Ratio || '_e', ea.Error) 
     FROM elemental_abundances ea 
     WHERE ea.StellarID = p.hostname) AS Star_Elemental_Abundance_Errors,
    bsp.Teff AS Star_Teff,
    bsp.log_g AS Star_log_g,
    bsp.Mass AS Stellar_Mass,
    bsp.l_Mass AS Stellar_Mass_Lower_Bound,
    bsp.u_Mass AS Stellar_Mass_Upper_Bound,
    bsp.Age AS Stellar_Age,
    bsp.l_Age AS Stellar_Age_Lower_Bound,
    bsp.u_Age AS Stellar_Age_Upper_Bound,
    bsp.M_H AS Metallicity,
    bsp.e_M_H AS Metallicity_Error,
    (SELECT Name FROM abundance_surveys WHERE SurveyID = 
        (SELECT SurveyID FROM elemental_abundances WHERE StellarID = p.hostname LIMIT 1)
    ) AS Abundance_Source
FROM 
    planet p
JOIN 
    planet_has_molecule phm ON p.pl_name = phm.pl_name
JOIN 
    molecule m ON phm.molecule_id = m.id
JOIN 
    host_ids hid ON hid.primary_id = p.hostname 
JOIN 
    brewer_stellar_property bsp ON bsp.StellarID = hid.alternate_id
GROUP BY
    p.pl_name, p.hostname, p.mass, p.radius, bsp.Teff, bsp.log_g, bsp.Mass,
    bsp.l_Mass, bsp.u_Mass, bsp.Age, bsp.l_Age, bsp.u_Age, bsp.M_H, bsp.e_M_H;



-- DELIMITER //

-- CREATE PROCEDURE SystemsWithFeature(IN FeatureName VARCHAR(100))
-- BEGIN
--     SELECT 
--         v.Planet_Name,
--         v.Star_Name,
--         v.Detected_Molecules,
--         v.Star_Elemental_Abundances,
--     FROM 
--         PlanetStarAbundance v
--     JOIN 

--     JOIN 
--         elemental_abundances ea ON json_extract(v.Star_Elemental_Abundances, '$.C_H') = ea.Abundance
--     WHERE 
--         ea.Element_Ratio = 'C_H'
--         AND json_extract(v.Star_Elemental_Abundances, '$.C_H') IS NOT NULL;
-- END //
-- DELIMITER ;


-- SELECT 
--     v.Planet_Name,
--     v.Star_Name,
--     v.Detected_Molecules,
--     v.Star_Elemental_Abundances,
--     ea.*
-- FROM 
--     PlanetStarAbundance v
-- JOIN 
--     elemental_abundances ea ON json_extract(v.Star_Elemental_Abundances, '$.C_H') = ea.Abundance
-- WHERE 
--     ea.Element_Ratio = 'C_H'
--     AND json_extract(v.Star_Elemental_Abundances, '$.C_H') IS NOT NULL;