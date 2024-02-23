//substring(1) because it has a trailing space
if(action[2].substring(1) === username){ //if it is a message we send ourself we ignore it
	if(/<a href="([^"]+)">/.test(action[4])){//except they contain the battle link
		getBattleById(action[4].match(/<a href="([^"]+)">/)[1].substring(1)).priv_challenge = true;
	}
	return;
}