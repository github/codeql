//go:generate swagger generate spec -o swagger.json

// Package classification Swagger Hotel Example.
// Swagger Hotel Example
//
//
//
//     Schemes: https
//     Host: hotel.example.revelframework.com
//     BasePath: /
//     Version: 1.0.0
//     License: MIT http://opensource.org/licenses/MIT
//     Contact: Name<email@somehwere.com> https://www.somewhere.com
//
//     Consumes:
//     - application/json
//     - application/x-www-form-urlencoded
//
//     Produces:
//     - text/html
//
//
//
//
// swagger:meta

package controllers

import (
	"fmt"
	"strings"

	"codeql-go-tests/frameworks/Revel/examples/booking/app/models"

	"github.com/revel/revel"
)

type Hotels struct {
	Application
}

func (c Hotels) checkUser() revel.Result {
	if user := c.connected(); user == nil {
		c.Flash.Error("Please log in first")
		return c.Redirect(nil)
	}
	return nil
}

func (c Hotels) Index() revel.Result {
	c.Log.Info("Fetching index")
	var bookings []*models.Booking

	return c.Render(bookings)
}

// swagger:route GET /hotels/ListJson enter demo
//
// Enter Demo
//
//
//     Consumes:
//     - application/x-www-form-urlencoded
//
//     Produces:
//     - text/html
//
//     Schemes: https
//
//
//     Responses:
//       200: Success
//       401: Invalid User

// swagger:operation GET /demo demo
//
// Enter Demo
//
//
// ---
// produces:
// - text/html
// parameters:
// - name: user
//   in: formData
//   description: user
//   required: true
//   type: string
// - name: demo
//   in: formData
//   description: demo
//   required: true
//   type: string
// responses:
//   '200':
//     description: Success
//   '401':
//     description: Invalid User
func (c Hotels) ListJson(search string, size, page uint64) revel.Result {
	if page == 0 {
		page = 1
	}
	nextPage := page + 1
	search = strings.TrimSpace(search)

	var hotels []*models.Hotel

	return c.RenderJSON(map[string]interface{}{"hotels": hotels, "search": search, "size": size, "page": page, "nextPage": nextPage}) // $ responsebody='map literal'
}
func (c Hotels) List(search string, size, page uint64) revel.Result {
	if page == 0 {
		page = 1
	}
	nextPage := page + 1
	search = strings.TrimSpace(search)

	var hotels []*models.Hotel

	return c.Render(hotels, search, size, page, nextPage)
}

func (c Hotels) loadHotelById(id int) *models.Hotel {
	var h interface{}
	if h == nil {
		return nil
	}
	return h.(*models.Hotel)
}

func (c Hotels) Show(id int) revel.Result {
	hotel := c.loadHotelById(id)
	if hotel == nil {
		return c.NotFound("Hotel %d does not exist", id)
	}
	title := hotel.Name
	return c.Render(title, hotel)
}

func (c Hotels) Settings() revel.Result {
	return c.Render()
}

func (c Hotels) SaveSettings(password, verifyPassword string) revel.Result {
	models.ValidatePassword(c.Validation, password)
	c.Validation.Required(verifyPassword).
		Message("Please verify your password")
	c.Validation.Required(verifyPassword == password).
		Message("Your password doesn't match")
	if c.Validation.HasErrors() {
		c.Validation.Keep()
		return c.Redirect(nil)
	}

	c.Flash.Success("Password updated")
	return c.Redirect(nil)
}

func (c Hotels) ConfirmBooking(id int, booking models.Booking) revel.Result {
	hotel := c.loadHotelById(id) // $ responsebody='call to loadHotelById'
	if hotel == nil {
		return c.NotFound("Hotel %d does not exist", id)
	}

	title := fmt.Sprintf("Confirm %s booking", hotel.Name)
	booking.Hotel = hotel
	booking.User = c.connected()
	booking.Validate(c.Validation)

	if c.Validation.HasErrors() || c.Params.Get("revise") != "" {
		c.Validation.Keep()
		c.FlashParams()
		return c.Redirect(nil)
	}

	if c.Params.Get("confirm") != "" {
		c.Flash.Success("Thank you, %s, your confirmation number for %s is %d",
			booking.User.Name, hotel.Name, booking.BookingId)
		return c.Redirect(nil)
	}

	return c.Render(title, hotel, booking)
}

func (c Hotels) CancelBooking(id int) revel.Result {
	c.Flash.Success(fmt.Sprintln("Booking cancelled for confirmation number", id))
	return c.Redirect(nil)
}

func (c Hotels) Book(id int) revel.Result {
	hotel := c.loadHotelById(id)
	if hotel == nil {
		return c.NotFound("Hotel %d does not exist", id)
	}

	title := "Book " + hotel.Name
	return c.Render(title, hotel)
}
