function BotMess(Bot, message)
%> @file  Botmess.m
%> @author Cristian Ferrari
%> @date 4 April 2026
%> @brief Send a message to a TelegramBot
%>
%==========================================================================
%> @section classMainLaplacian Class description
%==========================================================================
%> @brief            Send a message to a TelegramBot
%
%> @param Data       Struct with TelegramBot's data
%> @param Setup      message of the message
%>
%==========================================================================
    webwrite(url, 'chat_id', Bot.chatID, 'text', message);


end