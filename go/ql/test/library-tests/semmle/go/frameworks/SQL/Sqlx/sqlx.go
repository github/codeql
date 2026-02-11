package sqlxtest

import (
	"github.com/jmoiron/sqlx"
)

func getUntrustedString() string {
	return "trouble"
}

func main() {

	db := sqlx.DB{}
	untrusted := getUntrustedString()
	db.Select(nil, untrusted)     // $ querystring=untrusted
	db.Get(nil, untrusted)        // $ querystring=untrusted
	db.MustExec(untrusted)        // $ querystring=untrusted
	db.Queryx(untrusted)          // $ querystring=untrusted
	db.NamedExec(untrusted, nil)  // $ querystring=untrusted
	db.NamedQuery(untrusted, nil) // $ querystring=untrusted

	tx := sqlx.Tx{}
	tx.Select(nil, untrusted)     // $ querystring=untrusted
	tx.Get(nil, untrusted)        // $ querystring=untrusted
	tx.MustExec(untrusted)        // $ querystring=untrusted
	tx.Queryx(untrusted)          // $ querystring=untrusted
	tx.NamedExec(untrusted, nil)  // $ querystring=untrusted
	tx.NamedQuery(untrusted, nil) // $ querystring=untrusted

}
