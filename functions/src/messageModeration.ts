
const capitalizeSentence = require('capitalize-sentence');
const Filter = require('bad-words-br');
const badWordsFilter = new Filter();

function isShouting(message: String): boolean {
    return message.replace(/[^A-Z]/g, '').length > message.length / 2 || message.replace(/[^!]/g, '').length >= 3;
}

function stopShouting(message: String): String {
    return capitalizeSentence(message.toLowerCase()).replace(/!+/g, '.');
}

function containBadWords(message: String): boolean {
    return message !== badWordsFilter.clean(message);
}

function removeBadWords(message: String): String {
    return badWordsFilter.clean(message);
}
type fn = (data: String) => void;
export function moderateMessage(message: String, logger: fn): String {
    let moderated: String = message;
    if (isShouting(message)) {
        logger("O usuário está gritando...");
        moderated = stopShouting(message);
    }
    if (containBadWords(message)) {
        logger("O usuário tem boca suja...");
        moderated = removeBadWords(moderated);
    }

    return moderated;

}

