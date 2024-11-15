const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require("stripe")("sk_test_51QBJgjJ3Ccccrszu8Wv6WO6kfcoK7qPUAS8mhENATsTnqqsJz6NOPnbO1VZP7kYe0ESfmG6y9kX8bOiolMtqMG5e00Xz8oI4x7"); // Securely stored here

admin.initializeApp();

const firestore = admin.firestore();





exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  try {
    const { amount, currency } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: currency,
    });

    res.status(200).send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    res.status(400).send({ error: error.message });
  }
});

exports.sendCallNotification = functions.firestore
    .document('rooms/{callId}')
    .onCreate(async (snapshot, context) => {
        const callData = snapshot.data();
        if (!callData) {
            console.log('No data found in call document.');
            return;
        }

        const receiverId = callData.receiverId;
        const callerId = callData.callerId;
        const callId = context.params.callId;

        // Get the receiver's FCM token from Firestore
        const userSnapshot = await firestore.collection('users').doc(receiverId).get();
        const callerSnapshot = await firestore.collection('users').doc(callerId).get();
        const fcmToken = userSnapshot.get('notificationToken');
        const name = callerSnapshot.get("name");

        if (!fcmToken) {
            console.error('Receiver FCM token not found.');
            return;
        }

        // Send notification
        const message = {
            notification: {
                title: "Incoming Call",
                body: `${name} is video calling you! Tap to answer`,
            },
            data: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                status: 'recived',
                callId: callId,
                callerId,
                receiverId,
                name,
                callType: "video",
            },
            token: fcmToken,
            android: {
                notification: {
                    sound: "default",
                },
            },
        };
        admin
            .messaging()
            .send(message)
            .then((response) => {
                console.log("Successfully sent message:", response);
                return;
            })
            .catch((error) => {
                // eslint-disable-next-line no-console
                console.log("Error sending message:", error);
                return;
            });
    });




exports.sendVoiceNotification = functions.firestore
    .document('voiceRooms/{callId}')
    .onCreate(async (snapshot, context) => {
        const callData = snapshot.data();
        if (!callData) {
            console.log('No data found in call document.');
            return;
        }

        const receiverId = callData.receiverId;
        const callerId = callData.callerId;
        const callId = context.params.callId;

        // Get the receiver's FCM token from Firestore
        const userSnapshot = await firestore.collection('users').doc(receiverId).get();
        const callerSnapshot = await firestore.collection('users').doc(callerId).get();
        const fcmToken = userSnapshot.get('notificationToken');
        const name = callerSnapshot.get("name");

        if (!fcmToken) {
            console.error('Receiver FCM token not found.');
            return;
        }

        // Send notification
        const message = {
            notification: {
                title: "Incoming Call",
                body: `${name} is calling you! Tap to answer`,
            },
            data: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                status: 'recived',
                callId: callId,
                callerId,
                receiverId,
                name,
                callType: "audio",
            },
            token: fcmToken,
            android: {
                notification: {
                    sound: "default",
                },
            },
        };
        admin
            .messaging()
            .send(message)
            .then((response) => {
                console.log("Successfully sent message:", response);
                return;
            })
            .catch((error) => {
                // eslint-disable-next-line no-console
                console.log("Error sending message:", error);
                return;
            });
    });


    exports.sendNotification = functions.firestore
    .document('chats/{chatID}/messages/{messageID}')
    .onCreate(async (snapshot, context) => {
      const message = snapshot.data();
      if (!message) {
        console.error('No message data found in the snapshot.');
        return;
      }
  
      const senderId = message.sendTo;
      const recipientId = message.senderId;
      
      
      const chatID = context.params.chatID;
  
      if (!senderId || !recipientId) {
        console.error('Sender ID or Recipient ID is missing.');
        return;
      }
  
      try {
        // Retrieve the sender's details
        const senderDoc = await admin.firestore().collection('users').doc(senderId).get();
        if (!senderDoc.exists) {
          console.error(`Sender document with ID ${senderId} does not exist.`);
          return;
        }
  
        // Retrieve the recipient's details
        const recipientDoc = await admin.firestore().collection('users').doc(recipientId).get();
        if (!recipientDoc.exists) {
          console.error(`Recipient document with ID ${recipientId} does not exist.`);
          return;
        }
  
        const token = recipientDoc.data().fcmToken;
        const senderName = senderDoc.data().name;
  
        if (!token) {
          console.error(`FCM token for recipient with ID ${recipientId} not found.`);
          return;
        }
  
        const payload = {
          notification: {
            title: `Message from ${senderName}`,
            body: message.text,
          },
          data: {
            chatId: chatID,
            senderId:senderId,
            name:senderDoc.data().name,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            callType:"text",

          },
        };
  
        await admin.messaging().sendToDevice(token, payload);
        console.log('Notification sent successfully');
      } catch (error) {
        console.error('Error retrieving user details or sending notification:', error);
      }
    });
  