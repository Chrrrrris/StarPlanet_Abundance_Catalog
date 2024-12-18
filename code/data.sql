CREATE VIEW KICNumbersView AS
SELECT 
    primary_id,
    SUBSTR(alternate_id, INSTR(alternate_id, 'KIC') + 4) AS kic_number
FROM 
    host_ids
WHERE 
    alternate_id LIKE 'KIC%';