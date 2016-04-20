#!env/bin/python
# -*- coding: utf-8 -*-

import telepot
import time
import ConfigParser
from cobe.brain import Brain

config = ConfigParser.ConfigParser()
config.read("bot.cfg")

def handle(msg):
    content_type, chat_type, chat_id = telepot.glance(msg)
    if content_type == 'text':
        brain = Brain(config.get('Brain', 'path') + str(chat_id) + ".brain")
        brain.learn(msg['text'])
        if 'reply_to_message' in msg and msg['reply_to_message']['from']['username'] == "Braulio_bot":
            bot.sendMessage(chat_id,brain.reply(msg['text']),reply_to_message_id=msg['message_id'])
        elif 'braulio' in msg['text'].lower():
            bot.sendMessage(chat_id,brain.reply(msg['text']).replace("Braulio",msg['from']['first_name']))

token = config.get('General', 'token')
bot = telepot.Bot(token)
bot.notifyOnMessage(handle)

print('Listening')

while 1:
    time.sleep(10)

