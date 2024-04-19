// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package gsession

import (
	"context"
	"github.com/gogf/gf/errors/gcode"
	"github.com/gogf/gf/errors/gerror"
	"github.com/gogf/gf/internal/intlog"
	"time"

	"github.com/gogf/gf/container/gmap"
	"github.com/gogf/gf/container/gvar"
	"github.com/gogf/gf/os/gtime"
)

// Session struct for storing single session data, which is bound to a single request.
// The Session struct is the interface with user, but the Storage is the underlying adapter designed interface
// for functionality implements.
type Session struct {
	id      string          // Session id.
	ctx     context.Context // Context for current session, note that: one session one context.
	data    *gmap.StrAnyMap // Session data.
	dirty   bool            // Used to mark session is modified.
	start   bool            // Used to mark session is started.
	manager *Manager        // Parent manager.

	// idFunc is a callback function used for creating custom session id.
	// This is called if session id is empty ever when session starts.
	idFunc func(ttl time.Duration) (id string)
}

// init does the lazy initialization for session.
// It here initializes real session if necessary.
func (s *Session) init() {
	if s.start {
		return
	}
	var err error
	if s.id != "" {
		// Retrieve memory session data from manager.
		if r, _ := s.manager.sessionData.Get(s.id); r != nil {
			s.data = r.(*gmap.StrAnyMap)
			intlog.Print(s.ctx, "session init data:", s.data)
		}
		// Retrieve stored session data from storage.
		if s.manager.storage != nil {
			if s.data, err = s.manager.storage.GetSession(s.ctx, s.id, s.manager.ttl, s.data); err != nil && err != ErrorDisabled {
				intlog.Errorf(s.ctx, "session restoring failed for id '%s': %v", s.id, err)
				panic(err)
			}
		}
	}
	// Use custom session id creating function.
	if s.id == "" && s.idFunc != nil {
		s.id = s.idFunc(s.manager.ttl)
	}
	// Use default session id creating function of storage.
	if s.id == "" {
		s.id, err = s.manager.storage.New(s.ctx, s.manager.ttl)
		if err != nil && err != ErrorDisabled {
			intlog.Errorf(s.ctx, "create session id failed: %v", err)
			panic(err)
		}
	}
	// Use default session id creating function.
	if s.id == "" {
		s.id = NewSessionId()
	}
	if s.data == nil {
		s.data = gmap.NewStrAnyMap(true)
	}
	s.start = true

}

// Close closes current session and updates its ttl in the session manager.
// If this session is dirty, it also exports it to storage.
//
// NOTE that this function must be called ever after a session request done.
func (s *Session) Close() {
	if s.start && s.id != "" {
		size := s.data.Size()
		if s.manager.storage != nil {
			if s.dirty {
				if err := s.manager.storage.SetSession(s.ctx, s.id, s.data, s.manager.ttl); err != nil {
					panic(err)
				}
			} else if size > 0 {
				if err := s.manager.storage.UpdateTTL(s.ctx, s.id, s.manager.ttl); err != nil {
					panic(err)
				}
			}
		}
		if s.dirty || size > 0 {
			s.manager.UpdateSessionTTL(s.id, s.data)
		}
	}
}

// Set sets key-value pair to this session.
func (s *Session) Set(key string, value interface{}) error {
	s.init()
	if err := s.manager.storage.Set(s.ctx, s.id, key, value, s.manager.ttl); err != nil {
		if err == ErrorDisabled {
			s.data.Set(key, value)
		} else {
			return err
		}
	}
	s.dirty = true
	return nil
}

// Sets batch sets the session using map.
// Deprecated, use SetMap instead.
func (s *Session) Sets(data map[string]interface{}) error {
	return s.SetMap(data)
}

// SetMap batch sets the session using map.
func (s *Session) SetMap(data map[string]interface{}) error {
	s.init()
	if err := s.manager.storage.SetMap(s.ctx, s.id, data, s.manager.ttl); err != nil {
		if err == ErrorDisabled {
			s.data.Sets(data)
		} else {
			return err
		}
	}
	s.dirty = true
	return nil
}

// Remove removes key along with its value from this session.
func (s *Session) Remove(keys ...string) error {
	if s.id == "" {
		return nil
	}
	s.init()
	for _, key := range keys {
		if err := s.manager.storage.Remove(s.ctx, s.id, key); err != nil {
			if err == ErrorDisabled {
				s.data.Remove(key)
			} else {
				return err
			}
		}
	}
	s.dirty = true
	return nil
}

// Clear is alias of RemoveAll.
func (s *Session) Clear() error {
	return s.RemoveAll()
}

// RemoveAll deletes all key-value pairs from this session.
func (s *Session) RemoveAll() error {
	if s.id == "" {
		return nil
	}
	s.init()
	if err := s.manager.storage.RemoveAll(s.ctx, s.id); err != nil {
		if err == ErrorDisabled {
			s.data.Clear()
		} else {
			return err
		}
	}
	s.dirty = true
	return nil
}

// Id returns the session id for this session.
// It creates and returns a new session id if the session id is not passed in initialization.
func (s *Session) Id() string {
	s.init()
	return s.id
}

// SetId sets custom session before session starts.
// It returns error if it is called after session starts.
func (s *Session) SetId(id string) error {
	if s.start {
		return gerror.NewCode(gcode.CodeInvalidOperation, "session already started")
	}
	s.id = id
	return nil
}

// SetIdFunc sets custom session id creating function before session starts.
// It returns error if it is called after session starts.
func (s *Session) SetIdFunc(f func(ttl time.Duration) string) error {
	if s.start {
		return gerror.NewCode(gcode.CodeInvalidOperation, "session already started")
	}
	s.idFunc = f
	return nil
}

// Map returns all data as map.
// Note that it's using value copy internally for concurrent-safe purpose.
func (s *Session) Map() map[string]interface{} {
	if s.id != "" {
		s.init()
		data, err := s.manager.storage.GetMap(s.ctx, s.id)
		if err != nil && err != ErrorDisabled {
			intlog.Error(s.ctx, err)
		}
		if data != nil {
			return data
		}
		return s.data.Map()
	}
	return nil
}

// Size returns the size of the session.
func (s *Session) Size() int {
	if s.id != "" {
		s.init()
		size, err := s.manager.storage.GetSize(s.ctx, s.id)
		if err != nil && err != ErrorDisabled {
			intlog.Error(s.ctx, err)
		}
		if size >= 0 {
			return size
		}
		return s.data.Size()
	}
	return 0
}

// Contains checks whether key exist in the session.
func (s *Session) Contains(key string) bool {
	s.init()
	return s.Get(key) != nil
}

// IsDirty checks whether there's any data changes in the session.
func (s *Session) IsDirty() bool {
	return s.dirty
}

// Get retrieves session value with given key.
// It returns `def` if the key does not exist in the session if `def` is given,
// or else it returns nil.
func (s *Session) Get(key string, def ...interface{}) interface{} {
	if s.id == "" {
		return nil
	}
	s.init()
	v, err := s.manager.storage.Get(s.ctx, s.id, key)
	if err != nil && err != ErrorDisabled {
		intlog.Error(s.ctx, err)
	}
	if v != nil {
		return v
	}
	if v := s.data.Get(key); v != nil {
		return v
	}
	if len(def) > 0 {
		return def[0]
	}
	return nil
}

func (s *Session) GetVar(key string, def ...interface{}) *gvar.Var {
	return gvar.New(s.Get(key, def...), true)
}

func (s *Session) GetString(key string, def ...interface{}) string {
	return s.GetVar(key, def...).String()
}

func (s *Session) GetBool(key string, def ...interface{}) bool {
	return s.GetVar(key, def...).Bool()
}

func (s *Session) GetInt(key string, def ...interface{}) int {
	return s.GetVar(key, def...).Int()
}

func (s *Session) GetInt8(key string, def ...interface{}) int8 {
	return s.GetVar(key, def...).Int8()
}

func (s *Session) GetInt16(key string, def ...interface{}) int16 {
	return s.GetVar(key, def...).Int16()
}

func (s *Session) GetInt32(key string, def ...interface{}) int32 {
	return s.GetVar(key, def...).Int32()
}

func (s *Session) GetInt64(key string, def ...interface{}) int64 {
	return s.GetVar(key, def...).Int64()
}

func (s *Session) GetUint(key string, def ...interface{}) uint {
	return s.GetVar(key, def...).Uint()
}

func (s *Session) GetUint8(key string, def ...interface{}) uint8 {
	return s.GetVar(key, def...).Uint8()
}

func (s *Session) GetUint16(key string, def ...interface{}) uint16 {
	return s.GetVar(key, def...).Uint16()
}

func (s *Session) GetUint32(key string, def ...interface{}) uint32 {
	return s.GetVar(key, def...).Uint32()
}

func (s *Session) GetUint64(key string, def ...interface{}) uint64 {
	return s.GetVar(key, def...).Uint64()
}

func (s *Session) GetFloat32(key string, def ...interface{}) float32 {
	return s.GetVar(key, def...).Float32()
}

func (s *Session) GetFloat64(key string, def ...interface{}) float64 {
	return s.GetVar(key, def...).Float64()
}

func (s *Session) GetBytes(key string, def ...interface{}) []byte {
	return s.GetVar(key, def...).Bytes()
}

func (s *Session) GetInts(key string, def ...interface{}) []int {
	return s.GetVar(key, def...).Ints()
}

func (s *Session) GetFloats(key string, def ...interface{}) []float64 {
	return s.GetVar(key, def...).Floats()
}

func (s *Session) GetStrings(key string, def ...interface{}) []string {
	return s.GetVar(key, def...).Strings()
}

func (s *Session) GetInterfaces(key string, def ...interface{}) []interface{} {
	return s.GetVar(key, def...).Interfaces()
}

func (s *Session) GetTime(key string, format ...string) time.Time {
	return s.GetVar(key).Time(format...)
}

func (s *Session) GetGTime(key string, format ...string) *gtime.Time {
	return s.GetVar(key).GTime(format...)
}

func (s *Session) GetDuration(key string, def ...interface{}) time.Duration {
	return s.GetVar(key, def...).Duration()
}

func (s *Session) GetMap(key string, tags ...string) map[string]interface{} {
	return s.GetVar(key).Map(tags...)
}

func (s *Session) GetMapDeep(key string, tags ...string) map[string]interface{} {
	return s.GetVar(key).MapDeep(tags...)
}

func (s *Session) GetMaps(key string, tags ...string) []map[string]interface{} {
	return s.GetVar(key).Maps(tags...)
}

func (s *Session) GetMapsDeep(key string, tags ...string) []map[string]interface{} {
	return s.GetVar(key).MapsDeep(tags...)
}

func (s *Session) GetStruct(key string, pointer interface{}, mapping ...map[string]string) error {
	return s.GetVar(key).Struct(pointer, mapping...)
}

func (s *Session) GetStructs(key string, pointer interface{}, mapping ...map[string]string) error {
	return s.GetVar(key).Structs(pointer, mapping...)
}
