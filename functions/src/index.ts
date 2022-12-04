import * as functions from "firebase-functions";
import { sendGoodbyeEmail, sendWelcomeEmail } from "./emailSender";
import { moderateMessage } from "./messageModeration";


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//     functions.logger.info("Hello logs!", { structuredData: true });
//     response.send("Hello from Firebase!");
// });
export const welcomeUser = functions.auth.user().onCreate(async user => {
    let user_email = user.email || "";
    let username = user.displayName || "";

    await sendWelcomeEmail(user_email, username);
});

export const goodbyeUser = functions.auth.user().onDelete(async user => {
    let user_email = user.email || "";
    let username = user.displayName || "";

    await sendGoodbyeEmail(user_email, username);
});

export const sanitizeMessages = functions.database.ref("messages/{conversaId}/{mensagem}").onWrite(async mensagem => {
    const message = mensagem.after.val();

    if (message && !message.sanitized) {
        // Retrieved the message values.
        functions.logger.log('Esta mensagem será sanitizada: ', message.content);

        // Run moderation checks on on the message and moderate if needed.
        const moderatedMessage = moderateMessage(message.content, (data: String) => {
            functions.logger.log(data);
        });

        // Update the Firebase DB with checked message.
        functions.logger.log(
            'A Mensagem foi moderada, salvando no DB: ',
            moderatedMessage
        );
        return mensagem.after.ref.update({
            content: moderatedMessage,
            sanitized: true,
            moderated: message.content !== moderatedMessage,
        });
    }
    return null;
})



