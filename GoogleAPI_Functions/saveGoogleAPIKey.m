function saveGoogleAPIKey(gkey)
%SAVEGOOGLEAPIKEY Saves personal Google API key in directory for use.
%   Use this funtion to save your personal Google API Key for use by the
%   Energy Consumption Planner or any other personal features. The function
%   stores the key in a .mat file named "GoogleAPIKey" to be accessed by
%   functions. 
%   P.S. Do not store .mat file on open source online repositories.
%   Unauthorized usage could be an issue.
gkey = string(gkey);
save GoogleAPIKey gkey
end

