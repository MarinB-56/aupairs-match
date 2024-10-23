import { createConsumer } from "@rails/actioncable";

document.addEventListener('turbo:load', () => {
  const messagesContainer = document.getElementById('messages');

  if (messagesContainer) {
    const conversationId = messagesContainer.dataset.conversationId;
    const currentUserId = messagesContainer.dataset.userId; // ID de l'utilisateur courant
    const consumer = createConsumer();

    if (window.App && window.App.conversationChannel) {
      consumer.subscriptions.remove(window.App.conversationChannel);
    }

    window.App = window.App || {};
    window.App.conversationChannel = consumer.subscriptions.create(
      { channel: "ConversationChannel", conversation_id: conversationId },
      {
        received(data) {
          const messageHtml = data.message;
          const messageElement = document.createElement('div');
          messageElement.innerHTML = messageHtml;

          // Append the message
          messagesContainer.appendChild(messageElement.firstElementChild); // Correct node

          // Scroll to the bottom
          messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
      }
    );
  }
});
