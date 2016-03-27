// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
//
import {Socket} from "phoenix"

let socket = new Socket("/games", {params: {}})
socket.connect()
let gameId = window.location.pathname.split("/")[1]

let button = document.getElementById('new-number')
let channel = socket.channel("games:" + gameId, {})

channel.on("new_number", payload => {
  console.log("Update", payload)
})

if(button) {
  button.addEventListener('click', e => {
    channel.push('new_number', {})
  })
}

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
