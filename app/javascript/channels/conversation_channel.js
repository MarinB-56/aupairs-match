import { createConsumer } from "@rails/actioncable"

document.addEventListener('turbo:load', () => {
  const messagesContainer = document.getElementById('messages');

  if (messagesContainer) {
    const conversationId = messagesContainer.dataset.conversationId;
    const consumer = createConsumer();

    if (window.App && window.App.conversationChannel) {
      consumer.subscriptions.remove(window.App.conversationChannel);
    }

    window.App = window.App || {};
    window.App.conversationChannel = consumer.subscriptions.create(
      { channel: "ConversationChannel", conversation_id: conversationId },
      {
        received(data) {
          messagesContainer.insertAdjacentHTML('beforeend', data.message);
          messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
      }
    );
  }
});
