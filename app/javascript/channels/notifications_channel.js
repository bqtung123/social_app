import consumer from "./consumer";

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("you are connected to NotificationsChannel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data);

    const element = document.getElementById("count");
    const new_count = parseInt(element.innerText) + 1;
    element.textContent = new_count;

    const box = document.getElementById("count-box");
    box.classList.add("bg-danger");
    box.classList.remove("bg-primary");

    $("#notifications").prepend(data.message);
    // Called when there's incoming data on the websocket for this channel
  },
});
