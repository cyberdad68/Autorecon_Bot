#!/usr/bin/env python
# pylint: disable=C0116,W0613
# This program is dedicated to the public domain under the CC0 license.
from datetime import datetime,time
from fileinput import filename
import logging
from time import sleep
import subprocess
import pytz
import yaml
import os
import re
from functools import wraps
from threading import Thread

from telegram import Update, ForceReply
from telegram.ext import (
    Updater,
    CommandHandler,
    Application,
    InlineQueryHandler,
    CallbackQueryHandler,
    MessageHandler,
    ConversationHandler,
    CallbackContext,
    filters,
    JobQueue
)
# from telegram.ext import Application, ContextTypes, MessageHandler, filters

# Enable logging
logging.basicConfig(filename='bot.log',
                          filemode='a',
                          datefmt='%m/%d/%Y %I:%M:%S',
  format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)



def restricted(func):
    """Restrict usage of func to allowed users only and replies if necessary"""
    @wraps(func)
    async def wrapped(Update, CallbackContext, *args, **kwargs):
        user_id = Update.effective_user.username
        name = Update.effective_user.name
        base_path = os.path.dirname(os.path.abspath(__file__))
        config = yaml.load(open(os.path.join(base_path , 'config.yaml')).read() , Loader=yaml.FullLoader)
        if user_id not in config['general']['username']:
            # print("WARNING: Unauthorized access denied for {}.".format(user_id))
            await Update.message.reply_text('You are Not Authorised to use this bot. contact @ayushhsinghh')
            logger.info(f"User {name}:{user_id} is not authorished to this Bot")
            return  # quit function
        return await func(Update, CallbackContext, *args, **kwargs)
    return wrapped



# Define a few command handlers. These usually take the two arguments update and
# context.
@restricted
async def start(update: Update, context: CallbackContext) -> None:
    """Send a message when the command /start is issued."""
    user = update.effective_user
    name = update.effective_user.first_name
    logger.info(f"User {name} started TeleCon Bot")
    # context.job_queue.run_daily(callback=send_log , time=time(hour=12, minute=00, tzinfo=pytz.timezone('Asia/Kolkata')) , days=(0, 1, 2, 3, 4, 5, 6) , context=update.message.chat_id)
    await update.message.reply_markdown_v2(
        f'Hi {user.mention_markdown_v2()}\!',
        reply_markup=ForceReply(selective=True),
    )
    # def thread1(update: Updater, context: CallbackContext):
    #     while True:
    #         update.message.reply_text('I am from thread 1. going to sleep now.')
    #         time.sleep(2)

    # t1 = Thread(target=thread1,args=(update,context))
    # t1.start()


@restricted
async def subdomain(update: Update, context: CallbackContext) -> None:
    domain = " ".join(context.args)
    if domain == "":
        context.bot.send_message(chat_id=update.effective_chat.id, text="invalid format entry")
        return
    name = update.effective_user.first_name
    chat_id = update.message.chat_id
    mess_id = update.message.message_id
    logger.info(f"User {name}:{chat_id} started the Subdoamin Enumeration with Argument '{domain}'")
    file_name = f"{name}_{chat_id}_{mess_id}"
    cmd = f"bash /Autorecon/modules/Subdomain_Enum.sh {domain} {file_name}"
    await update.message.reply_text(f"subdomain enumeration started on {domain}")
    subprocess.run(cmd , shell=True , stdout=subprocess.DEVNULL , stderr=subprocess.STDOUT)
    sleep(2)
    file_uri = f"/Autorecon/modules/results/{file_name}-output.txt"
    ofile = open(file_uri, 'rb')
    filename = f"{domain}_subdomains.txt"
    await context.bot.send_document(chat_id ,ofile , filename=filename)
    ofile.close()

    
    # update.message.reply_text(f"Github Scanning started on {domain}")
    # cmd_2 = f"bash /Autorecon/modules/github_leaks.sh {domain} {file_name}"
    # subprocess.run(cmd_2 , shell=True , stdout=subprocess.DEVNULL , stderr=subprocess.STDOUT)
    # file_uri = f"/Autorecon/modules/results/{file_name}-gitleaks.txt"
    # ofile = open(file_uri, 'rb')
    # filename = f"{domain}_github_leaks.txt"
    # context.bot.send_document(chat_id ,ofile , filename=filename) #no error

    await update.message.reply_text(f"SubDomain TakeOver started on {domain}")
    cmd_2 = f"bash /Autorecon/modules/subtake.sh {domain} {file_name}"
    subprocess.run(cmd_2 , shell=True , stdout=subprocess.DEVNULL , stderr=subprocess.STDOUT)
    file_uri = f"/Autorecon/modules/results/{file_name}-takeoverSubzy.txt"
    ofile = open(file_uri, 'rb')
    filename = f"{domain}_TakeOver_Via_Subzy.txt"
    await context.bot.send_document(chat_id ,ofile , filename=filename) #error Coming

    # await update.message.reply_text(f"URL enumeration started on {domain}")
    # cmd_2 = f"bash /Autorecon/modules/URLenum.sh {domain} {file_name}"
    # subprocess.run(cmd_2 , shell=True , stdout=subprocess.DEVNULL , stderr=subprocess.STDOUT)
    # file_uri = f"/Autorecon/modules/results/{file_name}-urls.txt"
    # ofile = open(file_uri, 'rb')
    # filename = f"{domain}_Urls.txt"
    # await context.bot.send_document(chat_id ,ofile , filename=filename)

@restricted
async def get_log(update: Update, context: CallbackContext) -> None:
    file_uri = f"/Autorecon/bot.log"
    ofile = open(file_uri, 'rb')
    filename = "telecon.log"
    chat_id = update.message.chat_id
    await context.bot.send_document(chat_id, ofile , filename=filename)





 
@restricted
async def help_command(update: Update, context: CallbackContext) -> None:
    """Send a message when the command /help is issued."""
    await update.message.reply_text('Help!')

@restricted
async def echo(update: Update, context: CallbackContext) -> None:
    """Echo the user message."""
    await update.message.reply_text(update.message.text)




def main() -> None:
    """Start the bot."""
    
    application = (
            Application.builder().token(os.environ['TOKEN']).concurrent_updates(True).build()
        )
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, echo))
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(CommandHandler('subdomain',subdomain))
    application.add_handler(CommandHandler('getlog',get_log))


        # On messages that include passport data call msg
    # application.add_handler(MessageHandler(filters.PASSPORT_DATA, msg))

        # Run the bot until the user presses Ctrl-C
    application.run_polling()





    # Create the Updater and pass it your bot's token.
    # updater = Updater(os.environ['TOKEN'] , use_context=True)
    # # updater = Updater()


    # # Get the dispatcher to register handlers
    # dispatcher = updater.dispatcher

    # # JobQueue for Log Updates
    # # job_queue = JobQueue()
    # # job_queue.set_dispatcher(dispatcher)
    # # job_queue.run_daily(callback=send_log , time=time(hour=12, minute=00, tzinfo=pytz.timezone('Asia/Kolkata')) , days=(0, 1, 2, 3, 4, 5, 6))   
    # # on different commands - answer in Telegram
    # dispatcher.add_handler(CommandHandler("start", start))
    # dispatcher.add_handler(CommandHandler("help", help_command))
    # dispatcher.add_handler(CommandHandler('subdomain',subdomain))

    # # on non command i.e message - echo the message on Telegram
    # dispatcher.add_handler(MessageHandler(Filters.text & ~Filters.command, echo ,))
    # # Start the Bot
    # updater.start_polling()

    # # Run the bot until you press Ctrl-C or the process receives SIGINT,
    # # SIGTERM or SIGABRT. This should be used most of the time, since
    # # start_polling() is non-blocking and will stop the bot gracefully.
    # updater.idle()


if __name__ == '__main__':
    main()