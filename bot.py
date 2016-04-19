#!env/bin/python
# -*- coding: utf-8 -*-

import telepot
import time
import ConfigParser
from cobe.brain import Brain

config = ConfigParser.ConfigParser()
config.read("bot.cfg")

def handle(msg):
    print msg
    content_type, chat_type, chat_id = telepot.glance(msg)
    if content_type == 'text':
        brain = Brain(config.get('Brain', 'path') + str(chat_id) + ".brain")
        brain.learn(msg['text'])
        if 'braulio' in msg['text'].lower():
            bot.sendMessage(chat_id,brain.reply(msg['text']))

token = config.get('General', 'token')
bot = telepot.Bot(token)
bot.notifyOnMessage(handle)

print('Listening')

while 1:
    time.sleep(10)

