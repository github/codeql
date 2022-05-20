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
	db.Select(nil, untrusted)
	db.Get(nil, untrusted)
	db.MustExec(untrusted)
	db.Queryx(untrusted)
	db.NamedExec(untrusted, nil)
	db.NamedQuery(untrusted, nil)

	tx := sqlx.Tx{}
	tx.Select(nil, untrusted)
	tx.Get(nil, untrusted)
	tx.MustExec(untrusted)
	tx.Queryx(untrusted)
	tx.NamedExec(untrusted, nil)
	tx.NamedQuery(untrusted, nil)

}
