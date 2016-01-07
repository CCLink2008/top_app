# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/




$ -> alert "It works!"


data = "http://www.baidu.com"
url = "/todo_items/#{id}"
$.ajax
type: 'POST'
url: url
data: data

$ -> alert data 