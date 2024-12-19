-- query APOGEE abundances following Reeves et al. 2023 for curated stellar elemental abundances based on inference flags
SELECT a.apogee_id, b.ra, b.dec, b.glon, b.glat, b.snr, b.extratarg,
CASE WHEN (((a.teff_flag & 87903) = 0) AND (a.teff > -9999))
THEN a.teff ELSE null END AS teff,
CASE WHEN (((a.teff_flag & 87903) = 0) AND (a.teff > -9999))
THEN a.teff_err ELSE null END AS teff_err,
CASE WHEN (((a.logg_flag & 87903) = 0) AND (a.logg > -9999))
THEN a.logg ELSE null END AS logg,
CASE WHEN (((a.logg_flag & 87903) = 0) AND (a.logg > -9999))
THEN a.logg_err ELSE null END AS logg_err,
CASE WHEN (((a.m_h_flag & 87903) = 0) AND (a.m_h > -9999))
THEN a.m_h ELSE null END AS m_h,
CASE WHEN (((a.m_h_flag & 87903) = 0) AND (a.m_h > -9999))
THEN a.m_h_err ELSE null END AS m_h_err,
CASE WHEN (((a.fe_h_flag & 87903) = 0) AND (fe_h > -9999))
THEN fe_h ELSE null END AS fe_h,
CASE WHEN (((a.fe_h_flag & 87903) = 0) AND (fe_h > -9999))
THEN fe_h_err ELSE null END AS fe_h_err,
CASE WHEN (((a.o_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.o_fe > -9999) AND (a.fe_h > -9999))
THEN a.o_fe ELSE null END AS o_fe,
CASE WHEN (((a.o_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.o_fe > -9999) AND (a.fe_h > -9999))
THEN a.o_fe_err ELSE null END AS o_fe_err,
CASE WHEN (((a.na_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.na_fe > -9999) AND (a.fe_h > -9999))
THEN a.na_fe ELSE null END AS na_fe,
CASE WHEN (((a.na_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.na_fe > -9999) AND (a.fe_h > -9999))
THEN a.na_fe_err ELSE null END AS na_fe_err,
CASE WHEN (((a.mg_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.mg_fe > -9999) AND (a.fe_h > -9999))
THEN a.mg_fe ELSE null END AS mg_fe,
CASE WHEN (((a.mg_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.mg_fe > -9999) AND (a.fe_h > -9999))
THEN a.mg_fe_err ELSE null END AS mg_fe_err,
CASE WHEN (((a.al_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.al_fe > -9999) AND (a.fe_h > -9999))
THEN a.al_fe ELSE null END AS al_fe,
CASE WHEN (((a.al_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.al_fe > -9999) AND (a.fe_h > -9999))
THEN a.al_fe_err ELSE null END AS al_fe_err,
CASE WHEN (((a.k_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.k_fe > -9999) AND (a.fe_h > -9999))
THEN a.k_fe ELSE null END AS k_fe,
CASE WHEN (((a.k_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.k_fe > -9999) AND (a.fe_h > -9999))
THEN a.k_fe_err ELSE null END AS k_fe_err,
CASE WHEN (((a.co_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.co_fe > -9999) AND (a.fe_h > -9999))
THEN a.co_fe ELSE null END AS co_fe,
CASE WHEN (((a.co_fe_flag & 87903) = 0) AND ((a.fe_h_flag & 87903) = 0)
AND (a.co_fe > -9999) AND (a.fe_h > -9999))
THEN a.co_fe_err ELSE null END AS co_fe_err
FROM aspcapStar a
INNER JOIN apogeeStar b ON a.apstar_id = b.apstar_id
WHERE (a.aspcapflag & 261033871) = 0
AND (b.extratarg & 16) = 0
AND a.logg < 3.8

