// +build !amd64 !go1.16 go1.23

/*
 * Copyright 2022 ByteDance Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ast

import (
    `encoding/base64`
    `encoding/json`

    `github.com/bytedance/sonic/internal/native/types`
    `github.com/bytedance/sonic/internal/rt`
)

func init() {
    println("WARNING: sonic only supports Go1.16~1.22 && CPU amd64, but your environment is not suitable")
}

func quote(buf *[]byte, val string) {
    quoteString(buf, val)
}

func unquote(src string) (string, types.ParsingError) {
    sp := rt.IndexChar(src, -1)
    out, ok := unquoteBytes(rt.BytesFrom(sp, len(src)+2, len(src)+2))
    if !ok {
        return "", types.ERR_INVALID_ESCAPE
    }
    return rt.Mem2Str(out), 0
}

func decodeBase64(src string) ([]byte, error) {
    return base64.StdEncoding.DecodeString(src)
}

func encodeBase64(src []byte) string {
    return base64.StdEncoding.EncodeToString(src)
}

func (self *Parser) decodeValue() (val types.JsonState) {
    e, v := decodeValue(self.s, self.p, self.dbuf == nil)
    if e < 0 {
        return v
    }
    self.p = e
    return v
}

func (self *Parser) skip() (int, types.ParsingError) {
    e, s := skipValue(self.s, self.p)
    if e < 0 {
        return self.p, types.ParsingError(-e)
    }
    self.p = e
    return s, 0
}

func (self *Parser) skipFast() (int, types.ParsingError) {
    e, s := skipValueFast(self.s, self.p)
    if e < 0 {
        return self.p, types.ParsingError(-e)
    }
    self.p = e
    return s, 0
}

func (self *Node) encodeInterface(buf *[]byte) error {
    out, err := json.Marshal(self.packAny())
    if err != nil {
        return err
    }
    *buf = append(*buf, out...)
    return nil
}

func (self *Parser) getByPath(path ...interface{}) (int, types.ParsingError) {
    var err types.ParsingError
    for _, p := range path {
        if idx, ok := p.(int); ok && idx >= 0 {
            if err = self.searchIndex(idx); err != 0 {
                return -1, err
            }
        } else if key, ok := p.(string); ok {
            if err = self.searchKey(key); err != 0 {
                return -1, err
            }
        } else {
            panic("path must be either int(>=0) or string")
        }
    }

    var start int
    if start, err = self.skip(); err != 0 {
        return -1, err
    }
    return start, 0
}
