package pg

import (
	"bufio"
	"context"
	"crypto/md5" //nolint
	"crypto/tls"
	"encoding/binary"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"strings"

	"mellium.im/sasl"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/orm"
	"github.com/go-pg/pg/v10/types"
)

// https://www.postgresql.org/docs/current/protocol-message-formats.html
const (
	commandCompleteMsg  = 'C'
	errorResponseMsg    = 'E'
	noticeResponseMsg   = 'N'
	parameterStatusMsg  = 'S'
	authenticationOKMsg = 'R'
	backendKeyDataMsg   = 'K'
	noDataMsg           = 'n'
	passwordMessageMsg  = 'p'
	terminateMsg        = 'X'

	saslInitialResponseMsg        = 'p'
	authenticationSASLContinueMsg = 'R'
	saslResponseMsg               = 'p'
	authenticationSASLFinalMsg    = 'R'

	authenticationOK                = 0
	authenticationCleartextPassword = 3
	authenticationMD5Password       = 5
	authenticationSASL              = 10

	notificationResponseMsg = 'A'

	describeMsg             = 'D'
	parameterDescriptionMsg = 't'

	queryMsg              = 'Q'
	readyForQueryMsg      = 'Z'
	emptyQueryResponseMsg = 'I'
	rowDescriptionMsg     = 'T'
	dataRowMsg            = 'D'

	parseMsg         = 'P'
	parseCompleteMsg = '1'

	bindMsg         = 'B'
	bindCompleteMsg = '2'

	executeMsg = 'E'

	syncMsg  = 'S'
	flushMsg = 'H'

	closeMsg         = 'C'
	closeCompleteMsg = '3'

	copyInResponseMsg  = 'G'
	copyOutResponseMsg = 'H'
	copyDataMsg        = 'd'
	copyDoneMsg        = 'c'
)

var errEmptyQuery = internal.Errorf("pg: query is empty")

func (db *baseDB) startup(
	c context.Context, cn *pool.Conn, user, password, database, appName string,
) error {
	err := cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		writeStartupMsg(wb, user, database, appName)
		return nil
	})
	if err != nil {
		return err
	}

	return cn.WithReader(c, db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		for {
			typ, msgLen, err := readMessageType(rd)
			if err != nil {
				return err
			}

			switch typ {
			case backendKeyDataMsg:
				processID, err := readInt32(rd)
				if err != nil {
					return err
				}
				secretKey, err := readInt32(rd)
				if err != nil {
					return err
				}
				cn.ProcessID = processID
				cn.SecretKey = secretKey
			case parameterStatusMsg:
				if err := logParameterStatus(rd, msgLen); err != nil {
					return err
				}
			case authenticationOKMsg:
				err := db.auth(c, cn, rd, user, password)
				if err != nil {
					return err
				}
			case readyForQueryMsg:
				_, err := rd.ReadN(msgLen)
				return err
			case noticeResponseMsg:
				// If we encounter a notice message from the server then we want to try to log it as it might be
				// important for the client. If something goes wrong with this we want to fail. At the time of writing
				// this the client will fail just encountering a notice during startup. So failing if a bad notice is
				// sent is probably better than not failing, especially if we can try to log at least some data from the
				// notice.
				if err := db.logStartupNotice(rd); err != nil {
					return err
				}
			case errorResponseMsg:
				e, err := readError(rd)
				if err != nil {
					return err
				}
				return e
			default:
				return fmt.Errorf("pg: unknown startup message response: %q", typ)
			}
		}
	})
}

func (db *baseDB) enableSSL(c context.Context, cn *pool.Conn, tlsConf *tls.Config) error {
	err := cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		writeSSLMsg(wb)
		return nil
	})
	if err != nil {
		return err
	}

	err = cn.WithReader(c, db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		c, err := rd.ReadByte()
		if err != nil {
			return err
		}
		if c != 'S' {
			return errors.New("pg: SSL is not enabled on the server")
		}
		return nil
	})
	if err != nil {
		return err
	}

	cn.SetNetConn(tls.Client(cn.NetConn(), tlsConf))
	return nil
}

func (db *baseDB) auth(
	c context.Context, cn *pool.Conn, rd *pool.ReaderContext, user, password string,
) error {
	num, err := readInt32(rd)
	if err != nil {
		return err
	}

	switch num {
	case authenticationOK:
		return nil
	case authenticationCleartextPassword:
		return db.authCleartext(c, cn, rd, password)
	case authenticationMD5Password:
		return db.authMD5(c, cn, rd, user, password)
	case authenticationSASL:
		return db.authSASL(c, cn, rd, user, password)
	default:
		return fmt.Errorf("pg: unknown authentication message response: %q", num)
	}
}

// logStartupNotice will handle notice messages during the startup process. It will parse them and log them for the
// client. Notices are not common and only happen if there is something the client should be aware of. So logging should
// not be a problem.
// Notice messages can be seen in startup: https://www.postgresql.org/docs/13/protocol-flow.html
// Information on the notice message format: https://www.postgresql.org/docs/13/protocol-message-formats.html
// Note: This is true for earlier versions of PostgreSQL as well, I've just included the latest versions of the docs.
func (db *baseDB) logStartupNotice(
	rd *pool.ReaderContext,
) error {
	message := make([]string, 0)
	// Notice messages are null byte delimited key-value pairs. Where the keys are one byte.
	for {
		// Read the key byte.
		fieldType, err := rd.ReadByte()
		if err != nil {
			return err
		}

		// If they key byte (the type of field this data is) is 0 then that means we have reached the end of the notice.
		// We can break our loop here and throw our message data into the logger.
		if fieldType == 0 {
			break
		}

		// Read until the next null byte to get the data for this field. This does include the null byte at the end of
		// fieldValue so we will trim it off down below.
		fieldValue, err := readString(rd)
		if err != nil {
			return err
		}

		// Just throw the field type as a string and its value into an array.
		// Field types can be seen here: https://www.postgresql.org/docs/13/protocol-error-fields.html
		// TODO This is a rare occurrence as is, would it be worth adding something to indicate what the field names
		//  are? Or is PostgreSQL documentation enough for a user at this point?
		message = append(message, fmt.Sprintf("%s: %s", string(fieldType), fieldValue))
	}

	// Tell the client what PostgreSQL told us. Warning because its probably something the client should at the very
	// least adjust.
	internal.Warn.Printf("notice during startup: %s", strings.Join(message, ", "))

	return nil
}

func (db *baseDB) authCleartext(
	c context.Context, cn *pool.Conn, rd *pool.ReaderContext, password string,
) error {
	err := cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		writePasswordMsg(wb, password)
		return nil
	})
	if err != nil {
		return err
	}
	return readAuthOK(rd)
}

func (db *baseDB) authMD5(
	c context.Context, cn *pool.Conn, rd *pool.ReaderContext, user, password string,
) error {
	b, err := rd.ReadN(4)
	if err != nil {
		return err
	}

	secret := "md5" + md5s(md5s(password+user)+string(b))
	err = cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		writePasswordMsg(wb, secret)
		return nil
	})
	if err != nil {
		return err
	}

	return readAuthOK(rd)
}

func readAuthOK(rd *pool.ReaderContext) error {
	c, _, err := readMessageType(rd)
	if err != nil {
		return err
	}

	switch c {
	case authenticationOKMsg:
		c0, err := readInt32(rd)
		if err != nil {
			return err
		}
		if c0 != 0 {
			return fmt.Errorf("pg: unexpected authentication code: %q", c0)
		}
		return nil
	case errorResponseMsg:
		e, err := readError(rd)
		if err != nil {
			return err
		}
		return e
	default:
		return fmt.Errorf("pg: unknown password message response: %q", c)
	}
}

func (db *baseDB) authSASL(
	c context.Context, cn *pool.Conn, rd *pool.ReaderContext, user, password string,
) error {
	var saslMech sasl.Mechanism

loop:
	for {
		s, err := readString(rd)
		if err != nil {
			return err
		}

		switch s {
		case "":
			break loop
		case sasl.ScramSha256.Name:
			saslMech = sasl.ScramSha256
		case sasl.ScramSha256Plus.Name:
			// ignore
		default:
			return fmt.Errorf("got %q, wanted %q", s, sasl.ScramSha256.Name)
		}
	}

	creds := sasl.Credentials(func() (Username, Password, Identity []byte) {
		return []byte(user), []byte(password), nil
	})
	client := sasl.NewClient(saslMech, creds)

	_, resp, err := client.Step(nil)
	if err != nil {
		return err
	}

	err = cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		wb.StartMessage(saslInitialResponseMsg)
		wb.WriteString(saslMech.Name)
		wb.WriteInt32(int32(len(resp)))
		_, err := wb.Write(resp)
		if err != nil {
			return err
		}
		wb.FinishMessage()
		return nil
	})
	if err != nil {
		return err
	}

	typ, n, err := readMessageType(rd)
	if err != nil {
		return err
	}

	switch typ {
	case authenticationSASLContinueMsg:
		c11, err := readInt32(rd)
		if err != nil {
			return err
		}
		if c11 != 11 {
			return fmt.Errorf("pg: SASL: got %q, wanted %q", typ, 11)
		}

		b, err := rd.ReadN(n - 4)
		if err != nil {
			return err
		}

		_, resp, err = client.Step(b)
		if err != nil {
			return err
		}

		err = cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
			wb.StartMessage(saslResponseMsg)
			_, err := wb.Write(resp)
			if err != nil {
				return err
			}
			wb.FinishMessage()
			return nil
		})
		if err != nil {
			return err
		}

		return readAuthSASLFinal(rd, client)
	case errorResponseMsg:
		e, err := readError(rd)
		if err != nil {
			return err
		}
		return e
	default:
		return fmt.Errorf(
			"pg: SASL: got %q, wanted %q", typ, authenticationSASLContinueMsg)
	}
}

func readAuthSASLFinal(rd *pool.ReaderContext, client *sasl.Negotiator) error {
	c, n, err := readMessageType(rd)
	if err != nil {
		return err
	}

	switch c {
	case authenticationSASLFinalMsg:
		c12, err := readInt32(rd)
		if err != nil {
			return err
		}
		if c12 != 12 {
			return fmt.Errorf("pg: SASL: got %q, wanted %q", c, 12)
		}

		b, err := rd.ReadN(n - 4)
		if err != nil {
			return err
		}

		_, _, err = client.Step(b)
		if err != nil {
			return err
		}

		if client.State() != sasl.ValidServerResponse {
			return fmt.Errorf("pg: SASL: state=%q, wanted %q",
				client.State(), sasl.ValidServerResponse)
		}
	case errorResponseMsg:
		e, err := readError(rd)
		if err != nil {
			return err
		}
		return e
	default:
		return fmt.Errorf(
			"pg: SASL: got %q, wanted %q", c, authenticationSASLFinalMsg)
	}

	return readAuthOK(rd)
}

func md5s(s string) string {
	//nolint
	h := md5.Sum([]byte(s))
	return hex.EncodeToString(h[:])
}

func writeStartupMsg(buf *pool.WriteBuffer, user, database, appName string) {
	buf.StartMessage(0)
	buf.WriteInt32(196608)
	buf.WriteString("user")
	buf.WriteString(user)
	buf.WriteString("database")
	buf.WriteString(database)
	if appName != "" {
		buf.WriteString("application_name")
		buf.WriteString(appName)
	}
	buf.WriteString("")
	buf.FinishMessage()
}

func writeSSLMsg(buf *pool.WriteBuffer) {
	buf.StartMessage(0)
	buf.WriteInt32(80877103)
	buf.FinishMessage()
}

func writePasswordMsg(buf *pool.WriteBuffer, password string) {
	buf.StartMessage(passwordMessageMsg)
	buf.WriteString(password)
	buf.FinishMessage()
}

func writeFlushMsg(buf *pool.WriteBuffer) {
	buf.StartMessage(flushMsg)
	buf.FinishMessage()
}

func writeCancelRequestMsg(buf *pool.WriteBuffer, processID, secretKey int32) {
	buf.StartMessage(0)
	buf.WriteInt32(80877102)
	buf.WriteInt32(processID)
	buf.WriteInt32(secretKey)
	buf.FinishMessage()
}

func writeQueryMsg(
	buf *pool.WriteBuffer,
	fmter orm.QueryFormatter,
	query interface{},
	params ...interface{},
) error {
	buf.StartMessage(queryMsg)
	bytes, err := appendQuery(fmter, buf.Bytes, query, params...)
	if err != nil {
		return err
	}
	buf.Bytes = bytes
	err = buf.WriteByte(0x0)
	if err != nil {
		return err
	}
	buf.FinishMessage()
	return nil
}

func appendQuery(fmter orm.QueryFormatter, dst []byte, query interface{}, params ...interface{}) ([]byte, error) {
	switch query := query.(type) {
	case orm.QueryAppender:
		if v, ok := fmter.(*orm.Formatter); ok {
			fmter = v.WithModel(query)
		}
		return query.AppendQuery(fmter, dst)
	case string:
		if len(params) > 0 {
			model, ok := params[len(params)-1].(orm.TableModel)
			if ok {
				if v, ok := fmter.(*orm.Formatter); ok {
					fmter = v.WithTableModel(model)
					params = params[:len(params)-1]
				}
			}
		}
		return fmter.FormatQuery(dst, query, params...), nil
	default:
		return nil, fmt.Errorf("pg: can't append %T", query)
	}
}

func writeSyncMsg(buf *pool.WriteBuffer) {
	buf.StartMessage(syncMsg)
	buf.FinishMessage()
}

func writeParseDescribeSyncMsg(buf *pool.WriteBuffer, name, q string) {
	buf.StartMessage(parseMsg)
	buf.WriteString(name)
	buf.WriteString(q)
	buf.WriteInt16(0)
	buf.FinishMessage()

	buf.StartMessage(describeMsg)
	buf.WriteByte('S') //nolint
	buf.WriteString(name)
	buf.FinishMessage()

	writeSyncMsg(buf)
}

func readParseDescribeSync(rd *pool.ReaderContext) ([]types.ColumnInfo, error) {
	var columns []types.ColumnInfo
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return nil, err
		}
		switch c {
		case parseCompleteMsg:
			_, err = rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
		case rowDescriptionMsg: // Response to the DESCRIBE message.
			columns, err = readRowDescription(rd, pool.NewColumnAlloc())
			if err != nil {
				return nil, err
			}
		case parameterDescriptionMsg: // Response to the DESCRIBE message.
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
		case noDataMsg: // Response to the DESCRIBE message.
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
		case readyForQueryMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if firstErr != nil {
				return nil, firstErr
			}
			return columns, err
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return nil, err
			}
			if firstErr == nil {
				firstErr = e
			}
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return nil, err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return nil, err
			}
		default:
			return nil, fmt.Errorf("pg: readParseDescribeSync: unexpected message %q", c)
		}
	}
}

// Writes BIND, EXECUTE and SYNC messages.
func writeBindExecuteMsg(buf *pool.WriteBuffer, name string, params ...interface{}) error {
	buf.StartMessage(bindMsg)
	buf.WriteString("")
	buf.WriteString(name)
	buf.WriteInt16(0)
	buf.WriteInt16(int16(len(params)))
	for _, param := range params {
		buf.StartParam()
		bytes := types.Append(buf.Bytes, param, 0)
		if bytes != nil {
			buf.Bytes = bytes
			buf.FinishParam()
		} else {
			buf.FinishNullParam()
		}
	}
	buf.WriteInt16(0)
	buf.FinishMessage()

	buf.StartMessage(executeMsg)
	buf.WriteString("")
	buf.WriteInt32(0)
	buf.FinishMessage()

	writeSyncMsg(buf)

	return nil
}

func writeCloseMsg(buf *pool.WriteBuffer, name string) {
	buf.StartMessage(closeMsg)
	buf.WriteByte('S') //nolint
	buf.WriteString(name)
	buf.FinishMessage()
}

func readCloseCompleteMsg(rd *pool.ReaderContext) error {
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return err
		}
		switch c {
		case closeCompleteMsg:
			_, err := rd.ReadN(msgLen)
			return err
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return err
			}
			return e
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return err
			}
		default:
			return fmt.Errorf("pg: readCloseCompleteMsg: unexpected message %q", c)
		}
	}
}

func readSimpleQuery(rd *pool.ReaderContext) (*result, error) {
	var res result
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return nil, err
		}

		switch c {
		case commandCompleteMsg:
			b, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if err := res.parse(b); err != nil && firstErr == nil {
				firstErr = err
			}
		case readyForQueryMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if firstErr != nil {
				return nil, firstErr
			}
			return &res, nil
		case rowDescriptionMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
		case dataRowMsg:
			if _, err := rd.Discard(msgLen); err != nil {
				return nil, err
			}
			res.returned++
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return nil, err
			}
			if firstErr == nil {
				firstErr = e
			}
		case emptyQueryResponseMsg:
			if firstErr == nil {
				firstErr = errEmptyQuery
			}
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return nil, err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return nil, err
			}
		default:
			return nil, fmt.Errorf("pg: readSimpleQuery: unexpected message %q", c)
		}
	}
}

func readExtQuery(rd *pool.ReaderContext) (*result, error) {
	var res result
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return nil, err
		}

		switch c {
		case bindCompleteMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
		case dataRowMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			res.returned++
		case commandCompleteMsg: // Response to the EXECUTE message.
			b, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if err := res.parse(b); err != nil && firstErr == nil {
				firstErr = err
			}
		case readyForQueryMsg: // Response to the SYNC message.
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if firstErr != nil {
				return nil, firstErr
			}
			return &res, nil
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return nil, err
			}
			if firstErr == nil {
				firstErr = e
			}
		case emptyQueryResponseMsg:
			if firstErr == nil {
				firstErr = errEmptyQuery
			}
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return nil, err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return nil, err
			}
		default:
			return nil, fmt.Errorf("pg: readExtQuery: unexpected message %q", c)
		}
	}
}

func readRowDescription(
	rd *pool.ReaderContext, columnAlloc *pool.ColumnAlloc,
) ([]types.ColumnInfo, error) {
	numCol, err := readInt16(rd)
	if err != nil {
		return nil, err
	}

	for i := 0; i < int(numCol); i++ {
		b, err := rd.ReadSlice(0)
		if err != nil {
			return nil, err
		}

		col := columnAlloc.New(int16(i), b[:len(b)-1])

		if _, err := rd.ReadN(6); err != nil {
			return nil, err
		}

		dataType, err := readInt32(rd)
		if err != nil {
			return nil, err
		}
		col.DataType = dataType

		if _, err := rd.ReadN(8); err != nil {
			return nil, err
		}
	}

	return columnAlloc.Columns(), nil
}

func readDataRow(
	ctx context.Context,
	rd *pool.ReaderContext,
	columns []types.ColumnInfo,
	scanner orm.ColumnScanner,
) error {
	numCol, err := readInt16(rd)
	if err != nil {
		return err
	}

	if h, ok := scanner.(orm.BeforeScanHook); ok {
		if err := h.BeforeScan(ctx); err != nil {
			return err
		}
	}

	var firstErr error

	for colIdx := int16(0); colIdx < numCol; colIdx++ {
		n, err := readInt32(rd)
		if err != nil {
			return err
		}

		var colRd types.Reader
		if int(n) <= rd.Buffered() {
			colRd = rd.BytesReader(int(n))
		} else {
			rd.SetAvailable(int(n))
			colRd = rd
		}

		column := columns[colIdx]
		if err := scanner.ScanColumn(column, colRd, int(n)); err != nil && firstErr == nil {
			firstErr = internal.Errorf(err.Error())
		}

		if rd == colRd {
			if rd.Available() > 0 {
				if _, err := rd.Discard(rd.Available()); err != nil && firstErr == nil {
					firstErr = err
				}
			}
			rd.SetAvailable(-1)
		}
	}

	if h, ok := scanner.(orm.AfterScanHook); ok {
		if err := h.AfterScan(ctx); err != nil {
			return err
		}
	}

	return firstErr
}

func newModel(mod interface{}) (orm.Model, error) {
	m, err := orm.NewModel(mod)
	if err != nil {
		return nil, err
	}
	return m, m.Init()
}

func readSimpleQueryData(
	ctx context.Context, rd *pool.ReaderContext, mod interface{},
) (*result, error) {
	var columns []types.ColumnInfo
	var res result
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return nil, err
		}

		switch c {
		case rowDescriptionMsg:
			columns, err = readRowDescription(rd, rd.ColumnAlloc)
			if err != nil {
				return nil, err
			}

			if res.model == nil {
				var err error
				res.model, err = newModel(mod)
				if err != nil {
					if firstErr == nil {
						firstErr = err
					}
					res.model = Discard
				}
			}
		case dataRowMsg:
			scanner := res.model.NextColumnScanner()
			if err := readDataRow(ctx, rd, columns, scanner); err != nil {
				if firstErr == nil {
					firstErr = err
				}
			} else if err := res.model.AddColumnScanner(scanner); err != nil {
				if firstErr == nil {
					firstErr = err
				}
			}

			res.returned++
		case commandCompleteMsg:
			b, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if err := res.parse(b); err != nil && firstErr == nil {
				firstErr = err
			}
		case readyForQueryMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if firstErr != nil {
				return nil, firstErr
			}
			return &res, nil
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return nil, err
			}
			if firstErr == nil {
				firstErr = e
			}
		case emptyQueryResponseMsg:
			if firstErr == nil {
				firstErr = errEmptyQuery
			}
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return nil, err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return nil, err
			}
		default:
			return nil, fmt.Errorf("pg: readSimpleQueryData: unexpected message %q", c)
		}
	}
}

func readExtQueryData(
	ctx context.Context, rd *pool.ReaderContext, mod interface{}, columns []types.ColumnInfo,
) (*result, error) {
	var res result
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return nil, err
		}

		switch c {
		case bindCompleteMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
		case dataRowMsg:
			if res.model == nil {
				var err error
				res.model, err = newModel(mod)
				if err != nil {
					if firstErr == nil {
						firstErr = err
					}
					res.model = Discard
				}
			}

			scanner := res.model.NextColumnScanner()
			if err := readDataRow(ctx, rd, columns, scanner); err != nil {
				if firstErr == nil {
					firstErr = err
				}
			} else if err := res.model.AddColumnScanner(scanner); err != nil {
				if firstErr == nil {
					firstErr = err
				}
			}

			res.returned++
		case commandCompleteMsg: // Response to the EXECUTE message.
			b, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if err := res.parse(b); err != nil && firstErr == nil {
				firstErr = err
			}
		case readyForQueryMsg: // Response to the SYNC message.
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if firstErr != nil {
				return nil, firstErr
			}
			return &res, nil
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return nil, err
			}
			if firstErr == nil {
				firstErr = e
			}
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return nil, err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return nil, err
			}
		default:
			return nil, fmt.Errorf("pg: readExtQueryData: unexpected message %q", c)
		}
	}
}

func readCopyInResponse(rd *pool.ReaderContext) error {
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return err
		}

		switch c {
		case copyInResponseMsg:
			_, err := rd.ReadN(msgLen)
			return err
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return err
			}
			if firstErr == nil {
				firstErr = e
			}
		case readyForQueryMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return err
			}
			return firstErr
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return err
			}
		default:
			return fmt.Errorf("pg: readCopyInResponse: unexpected message %q", c)
		}
	}
}

func readCopyOutResponse(rd *pool.ReaderContext) error {
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return err
		}

		switch c {
		case copyOutResponseMsg:
			_, err := rd.ReadN(msgLen)
			return err
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return err
			}
			if firstErr == nil {
				firstErr = e
			}
		case readyForQueryMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return err
			}
			return firstErr
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return err
			}
		default:
			return fmt.Errorf("pg: readCopyOutResponse: unexpected message %q", c)
		}
	}
}

func readCopyData(rd *pool.ReaderContext, w io.Writer) (*result, error) {
	var res result
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return nil, err
		}

		switch c {
		case copyDataMsg:
			for msgLen > 0 {
				b, err := rd.ReadN(msgLen)
				if err != nil && err != bufio.ErrBufferFull {
					return nil, err
				}

				_, err = w.Write(b)
				if err != nil {
					return nil, err
				}

				msgLen -= len(b)
			}
		case copyDoneMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
		case commandCompleteMsg:
			b, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if err := res.parse(b); err != nil && firstErr == nil {
				firstErr = err
			}
		case readyForQueryMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if firstErr != nil {
				return nil, firstErr
			}
			return &res, nil
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return nil, err
			}
			return nil, e
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return nil, err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return nil, err
			}
		default:
			return nil, fmt.Errorf("pg: readCopyData: unexpected message %q", c)
		}
	}
}

func writeCopyData(buf *pool.WriteBuffer, r io.Reader) error {
	buf.StartMessage(copyDataMsg)
	_, err := buf.ReadFrom(r)
	buf.FinishMessage()
	return err
}

func writeCopyDone(buf *pool.WriteBuffer) {
	buf.StartMessage(copyDoneMsg)
	buf.FinishMessage()
}

func readReadyForQuery(rd *pool.ReaderContext) (*result, error) {
	var res result
	var firstErr error
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return nil, err
		}

		switch c {
		case commandCompleteMsg:
			b, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if err := res.parse(b); err != nil && firstErr == nil {
				firstErr = err
			}
		case readyForQueryMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return nil, err
			}
			if firstErr != nil {
				return nil, firstErr
			}
			return &res, nil
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return nil, err
			}
			if firstErr == nil {
				firstErr = e
			}
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return nil, err
			}
		case parameterStatusMsg:
			if err := logParameterStatus(rd, msgLen); err != nil {
				return nil, err
			}
		default:
			return nil, fmt.Errorf("pg: readReadyForQueryOrError: unexpected message %q", c)
		}
	}
}

func readNotification(rd *pool.ReaderContext) (channel, payload string, err error) {
	for {
		c, msgLen, err := readMessageType(rd)
		if err != nil {
			return "", "", err
		}

		switch c {
		case commandCompleteMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return "", "", err
			}
		case readyForQueryMsg:
			_, err := rd.ReadN(msgLen)
			if err != nil {
				return "", "", err
			}
		case errorResponseMsg:
			e, err := readError(rd)
			if err != nil {
				return "", "", err
			}
			return "", "", e
		case noticeResponseMsg:
			if err := logNotice(rd, msgLen); err != nil {
				return "", "", err
			}
		case notificationResponseMsg:
			_, err := readInt32(rd)
			if err != nil {
				return "", "", err
			}
			channel, err = readString(rd)
			if err != nil {
				return "", "", err
			}
			payload, err = readString(rd)
			if err != nil {
				return "", "", err
			}
			return channel, payload, nil
		default:
			return "", "", fmt.Errorf("pg: readNotification: unexpected message %q", c)
		}
	}
}

var terminateMessage = []byte{terminateMsg, 0, 0, 0, 4}

func terminateConn(cn *pool.Conn) error {
	// Don't use cn.Buf because it is racy with user code.
	_, err := cn.NetConn().Write(terminateMessage)
	return err
}

//------------------------------------------------------------------------------

func logNotice(rd *pool.ReaderContext, msgLen int) error {
	_, err := rd.ReadN(msgLen)
	return err
}

func logParameterStatus(rd *pool.ReaderContext, msgLen int) error {
	_, err := rd.ReadN(msgLen)
	return err
}

func readInt16(rd *pool.ReaderContext) (int16, error) {
	b, err := rd.ReadN(2)
	if err != nil {
		return 0, err
	}
	return int16(binary.BigEndian.Uint16(b)), nil
}

func readInt32(rd *pool.ReaderContext) (int32, error) {
	b, err := rd.ReadN(4)
	if err != nil {
		return 0, err
	}
	return int32(binary.BigEndian.Uint32(b)), nil
}

func readString(rd *pool.ReaderContext) (string, error) {
	b, err := rd.ReadSlice(0)
	if err != nil {
		return "", err
	}
	return string(b[:len(b)-1]), nil
}

func readError(rd *pool.ReaderContext) (error, error) {
	m := make(map[byte]string)
	for {
		c, err := rd.ReadByte()
		if err != nil {
			return nil, err
		}
		if c == 0 {
			break
		}
		s, err := readString(rd)
		if err != nil {
			return nil, err
		}
		m[c] = s
	}
	return internal.NewPGError(m), nil
}

func readMessageType(rd *pool.ReaderContext) (byte, int, error) {
	c, err := rd.ReadByte()
	if err != nil {
		return 0, 0, err
	}
	l, err := readInt32(rd)
	if err != nil {
		return 0, 0, err
	}
	return c, int(l) - 4, nil
}
