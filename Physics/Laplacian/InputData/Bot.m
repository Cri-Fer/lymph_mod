classdef Bot
    %BOT class to send messages to telgram for notification 
    %   % A config.json file should be created with this structure:
    % {
    % 	"telegram_token": "", -> telegram token
    % 	"chat_ID": ""
    % }
    % if in a cluster .json file should be in the login01 

    properties (Access = private)
        token
        chat_ID
    end

    methods
        function obj = Bot()
            % Cerca il file config.json ovunque sia nel path di MATLAB
            % o usa un percorso relativo alla posizione della classe
            folder = fileparts(mfilename('fullpath'));
            fname = fullfile(folder, 'config.json');
            
            if ~isfile(fname)
                error('Bot:ConfigNotFound', 'File config.json not found in: %s', fname);
            end
            
            try
                raw = fileread(fname);
                val = jsondecode(raw);
                obj.token = val.telegram_token;
                obj.chat_ID = val.chat_ID; 
            catch ME
                error('Bot:ParseError', 'Errore nel leggere config.json: %s', ME.message);
            end
        end
        
        function send_message(obj, message)
            % Add a timestamp to distinguish messages
            full_msg = sprintf('[%s] %s', datestr(now, 'HH:MM'), message);
            
            url = ['https://api.telegram.org/bot', obj.token, '/sendMessage'];
            try
                webwrite(url, 'chat_id', obj.chat_ID, 'text', full_msg);
            catch
                warning("It wasn't possible to send Telegram message.");
            end
        end
    end
end