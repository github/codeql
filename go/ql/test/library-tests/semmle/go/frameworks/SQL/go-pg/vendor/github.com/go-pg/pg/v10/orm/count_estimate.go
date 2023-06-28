package orm

import (
	"fmt"

	"github.com/go-pg/pg/v10/internal"
)

// Placeholder that is replaced with count(*).
const placeholder = `'_go_pg_placeholder'`

// https://wiki.postgresql.org/wiki/Count_estimate
//nolint
var pgCountEstimateFunc = fmt.Sprintf(`
CREATE OR REPLACE FUNCTION _go_pg_count_estimate_v2(query text, threshold int)
RETURNS int AS $$
DECLARE
  rec record;
  nrows int;
BEGIN
  FOR rec IN EXECUTE 'EXPLAIN ' || query LOOP
    nrows := substring(rec."QUERY PLAN" FROM ' rows=(\d+)');
    EXIT WHEN nrows IS NOT NULL;
  END LOOP;

  -- Return the estimation if there are too many rows.
  IF nrows > threshold THEN
    RETURN nrows;
  END IF;

  -- Otherwise execute real count query.
  query := replace(query, 'SELECT '%s'', 'SELECT count(*)');
  EXECUTE query INTO nrows;

  IF nrows IS NULL THEN
    nrows := 0;
  END IF;

  RETURN nrows;
END;
$$ LANGUAGE plpgsql;
`, placeholder)

// CountEstimate uses EXPLAIN to get estimated number of rows returned the query.
// If that number is bigger than the threshold it returns the estimation.
// Otherwise it executes another query using count aggregate function and
// returns the result.
//
// Based on https://wiki.postgresql.org/wiki/Count_estimate
func (q *Query) CountEstimate(threshold int) (int, error) {
	if q.stickyErr != nil {
		return 0, q.stickyErr
	}

	query, err := q.countSelectQuery(placeholder).AppendQuery(q.db.Formatter(), nil)
	if err != nil {
		return 0, err
	}

	for i := 0; i < 3; i++ {
		var count int
		_, err = q.db.QueryOneContext(
			q.ctx,
			Scan(&count),
			"SELECT _go_pg_count_estimate_v2(?, ?)",
			string(query), threshold,
		)
		if err != nil {
			if pgerr, ok := err.(internal.PGError); ok && pgerr.Field('C') == "42883" {
				// undefined_function
				err = q.createCountEstimateFunc()
				if err != nil {
					pgerr, ok := err.(internal.PGError)
					if !ok || !pgerr.IntegrityViolation() {
						return 0, err
					}
				}
				continue
			}
		}
		return count, err
	}

	return 0, err
}

func (q *Query) createCountEstimateFunc() error {
	_, err := q.db.ExecContext(q.ctx, pgCountEstimateFunc)
	return err
}
