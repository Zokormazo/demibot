#!env/bin/python
# -*- coding: utf-8 -*-

import telepot
import time
import os
from cobe.brain import Brain

token = os.environ.get("DEMIBOT_API_TOKEN", None)
brain_path = os.environ.get("DEMIBOT_BRAIN_PATH", None)

def handle(msg):
    content_type, chat_type, chat_id = telepot.glance(msg)
    if content_type == 'text':
        brain = Brain(brain_path + "/" + str(chat_id) + ".brain")
        msg['text'] = msg['text'].replace(u'@',u'')
        brain.learn(msg['text'])
        
        # Delete possible mentions in the response
        msg_reply = brain.reply(msg['text']).replace(u'@',u'')
        if 'reply_to_message' in msg and msg['reply_to_message']['from']['username'] == "Braulio_bot":
            bot.sendMessage(chat_id,msg_reply,reply_to_message_id=msg['message_id'])
        elif 'braulio' in msg['text'].lower():
            bot.sendMessage(chat_id,msg_reply.replace("Braulio",msg['from']['first_name']))

bot = telepot.Bot(token)
bot.message_loop(handle)

print('Listening')

while 1:
    time.sleep(10)

