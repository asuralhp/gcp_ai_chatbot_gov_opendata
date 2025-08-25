package main

import (
	"net/http"
	"net/url"
	"bytes"
    "encoding/json"
)


func AskChatbot(ask Call, UrlPath string, apikey string) (Call, error){
	var ans Call
	

	// data := url.Values{}
	// data.Set("name", "foo")
	// data.Set("surname", "bar")
	
	apiurl := urlTemplate(GATEWAY_URL, UrlPath, apikey)
	
	
	requestBodyBytes, err := json.Marshal(ask)
	req, err := http.NewRequest("POST", apiurl, bytes.NewBuffer(requestBodyBytes))
	if err != nil {
		return ans, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return ans, err
	}
	
	println(resp.Status)
	err = json.NewDecoder(resp.Body).Decode(&ans)
	if err != nil {
		return ans, err
	}
	return ans, err
}



func urlTemplate(domain string, UrlPath string, api_key string) string  {
	u, _ := url.ParseRequestURI(domain)
	u.Path = UrlPath
	q := u.Query()
	q.Add("api_key", api_key)
	u.RawQuery = q.Encode()
	return u.String() 
}