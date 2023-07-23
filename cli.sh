# Matrix Core / Workers
systemctl $1 matrix_main.service
systemctl $1 matrix_generic_worker@client.service
systemctl $1 matrix_generic_worker@federation_reader.service
systemctl $1 matrix_generic_worker@synchrotron.service
systemctl $1 matrix_generic_worker@events.service
systemctl $1 matrix_generic_worker@user_dir.service
systemctl $1 matrix_generic_worker@appservice.service
systemctl $1 matrix_generic_worker@background.service
systemctl $1 matrix_generic_worker@frontend_proxy.service
systemctl $1 matrix_generic_worker@pusher.service
systemctl $1 matrix_generic_worker@federation_sender.service
systemctl $1 matrix_media.service
systemctl $1 matrix_sygnal.service
#systemctl $1 matrix_waterfall.service
systemctl $1 matrix_livekit.service
systemctl $1 matrix_livekit_auth.service
#systemctl $1 matrix_syncv3.service

# Appservices
systemctl $1 matrix_facebook.service
#systemctl $1 matrix_steam.service
systemctl $1 matrix_instagram.service
systemctl $1 matrix_signal.service
systemctl $1 matrix_irc.service
systemctl $1 matrix_webhooks.service
systemctl $1 matrix_whatsapp.service
systemctl $1 matrix_discord.service
systemctl $1 matrix_telegram.service
#systemctl $1 matrix_skype.service
#systemctl $1 matrix_linkedin.service

# Bots
systemctl $1 matrix_bot.service
systemctl $1 matrix_chatgpt.service
systemctl $1 matrix_sip.service

# NGINX
systemctl restart nginx.service