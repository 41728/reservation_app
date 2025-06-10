import consumer from "./consumer"

document.addEventListener('turbo:load', () => {
  const messagesContainer = document.getElementById('messages');
  if (!messagesContainer) return;  // ここで存在しなければ処理終了

  const chatRoomId = messagesContainer.dataset.chatRoomId;
  if (!chatRoomId) return;

  consumer.subscriptions.create({ channel: "ChatRoomChannel", chat_room_id: chatRoomId }, {
    received(data) {
      messagesContainer.insertAdjacentHTML('beforeend', data.message);
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
  });
});
