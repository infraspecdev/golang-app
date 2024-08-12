package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestGreet(t *testing.T) {
	req, err := http.NewRequest("GET", "/John", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(greet)

	handler.ServeHTTP(rr, req)

	expected := "Hello, John!"
	if !strings.Contains(rr.Body.String(), expected) {
		t.Errorf("handler returned unexpected body: got %v want %v",
			rr.Body.String(), expected)
	}
}

func TestGreetDefault(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(greet)

	handler.ServeHTTP(rr, req)

	expected := "Hello, Infraspec!"
	if !strings.Contains(rr.Body.String(), expected) {
		t.Errorf("handler returned unexpected body: got %v want %v",
			rr.Body.String(), expected)
	}
}

func TestVersion(t *testing.T) {
	req, err := http.NewRequest("GET", "/version", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(version)

	handler.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			rr.Code, http.StatusOK)
	}

	if !strings.Contains(rr.Body.String(), "path") {
		t.Errorf("handler returned unexpected body: got %v",
			rr.Body.String())
	}
}