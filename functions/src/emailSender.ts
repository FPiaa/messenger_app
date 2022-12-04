const nodemailer = require("nodemailer");
import * as functions from "firebase-functions";


const user = functions.config().gmail.email;
const pass = functions.config().gmail.password;

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user,
        pass
    }
});

const APP_NAME = 'Meu Aplicativo';


export async function sendWelcomeEmail(email: String, displayName: String) {

    const mailOptions = {
        from: `${APP_NAME} <noreply@firebase.com>`,
        to: email,
        subject: "",
        text: ""
    };

    mailOptions.subject = `Bem-vindo ao ${APP_NAME}!`;
    mailOptions.text = `Olá ${displayName || ''}! Bem-vindo ao ${APP_NAME}. Esperamos que aproveite bem os nossos serviços`;
    await transporter.sendMail(mailOptions);
    functions.logger.log('Email de boas vindas enviado para: ', email);
    return null;
}

// Sends a goodbye email to the given user.
export async function sendGoodbyeEmail(email: String, displayName: String) {
    const mailOptions = {
        from: `${APP_NAME} <noreply@firebase.com>`,
        to: email,
        subject: "",
        text: ""
    };

    mailOptions.subject = `Adeus :(`;
    mailOptions.text = `Olá ${displayName || ''}...!, Nós excluimos a sua conta no ${APP_NAME}.\nAté mais...`;
    await transporter.sendMail(mailOptions);
    functions.logger.log('Email de deleção de conta enviado para: ', email);
    return null;
}