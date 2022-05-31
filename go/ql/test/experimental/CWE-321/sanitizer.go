package main

//go:generate depstubber -vendor github.com/cristalhq/jwt/v3 Signer NewSignerHS,HS256

import (
	crand "crypto/rand"
	"errors"
	"fmt"
	"math/big"
	"math/rand"
	"time"

	cristal "github.com/cristalhq/jwt/v3"
)

func cristalhq() (interface{}, error) {
	key := []byte(`key`)
	return cristal.NewSignerHS(cristal.HS256, key) // BAD
}

func GenerateRandomString(size int) string {
	const characters = `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`
	var bytes = make([]byte, size)
	crand.Read(bytes)
	for i, x := range bytes {
		bytes[i] = characters[x%byte(len(characters))]
	}
	return string(bytes)
}

func GenerateCryptoString2(n int) (string, error) {
	const chars = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-"
	ret := make([]byte, n)
	for i := range ret {
		num, err := crand.Int(crand.Reader, big.NewInt(int64(len(chars))))
		if err != nil {
			return "", err
		}
		ret[i] = chars[num.Int64()]
	}
	return string(ret), nil
}
func GenerateRandomString3(size int) string {
	const characters = `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`
	var bytes = make([]byte, size)
	crand.Read(bytes)
	for i, x := range bytes {
		bytes[i] = characters[x]
	}
	return string(bytes)
}

func RandAuthToken() string {
	buf := make([]byte, 32)
	_, err := crand.Read(buf)
	if err != nil {
		return RandString(64)
	}

	return fmt.Sprintf("%x", buf)
}

func RandString(length int64) string {
	sources := []byte("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
	var result []byte
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	sourceLength := len(sources)
	var i int64 = 0
	for ; i < length; i++ {
		result = append(result, sources[r.Intn(sourceLength)])
	}

	return string(result)
}
func genKey(size int) (string, error) {
	if size < 10 {
		err := errors.New("size too small")
		return "", err
	} else {
		return "asd", nil
	}
}
func test1() {
	key := GenerateRandomString(32)
	return cristal.NewSignerHS(cristal.HS256, key) // GOOD
}

func test2() {
	key2, _ := GenerateCryptoString2(32)
	return cristal.NewSignerHS(cristal.HS256, key2) // GOOD
}

func test3() {
	key3 := RandAuthToken()
	return cristal.NewSignerHS(cristal.HS256, key3) // GOOD
}

func test4() (interface{}, error) {
	key4, err := genKey(21)
	if err != nil {
		return nil, err
	}

	return cristal.NewSignerHS(cristal.HS256, key4) // BAD
}

func test5() (interface{}, error) {
	temp := "test"
	if temp != "test" {
		return cristal.NewSignerHS(cristal.HS256, []byte(temp)), nil // GOOD
	} else {
		return nil, nil
	}
}
func test6() {
	key := GenerateRandomString3(32)
	return cristal.NewSignerHS(cristal.HS256, key) // GOOD
}

func main() {
	return
}
