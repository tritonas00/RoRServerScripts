
// This is a list of words that should be filtered.
// Notes:
//     - do not use capitals (the actual search will be case insensitive)
//     - put longer derivations in front (e.g.: motherfucker before fuck,
//       otherwise fuck will be replaced first and the result will be
//       mother****er instead of ************)
//     - Don't put a list of 1000 words here, that would probably lag your chat.
const array<string>  profanityFilter_words = 
{
	"motherfucker", "mother fuck", "what the fuck", "fuck off", "fuck you",
	"fucker", "fucking", "fucked", "fuck", "f*ck", "f**k", "fu**", "f***",
	"fck", "wtf","cock", "fuking", "fukking", "cunt", "cocksucker",
	"cock sucking", "cock sucker", "cock suck", "cock", "noob", "n00b",
	"nOob", "no0b", "asshole", "ass-hole", "assh0le", "you're gay",
	"gay server", "phucking", "phuck", "sucker", "suck me off", "suck my nuts",
	"suck my", "suck me", "server sucks", "fool", "dick", "fuk off", "fack you",
	"nigga", "niggor", "nigger", "n*gger", "nigg*r", "n*gg*r", "penis", "gtfo",
	"porn", "p0rn", "sex", "twat", "bitch", "dumbass", "wth", "douchebag", "douche", "shit", "queer",
	"w t f"
};

// The following words should only be replaced when found as full words
// (best for short words)
// Notes:
//     - do not use spaces in words here
//     - These words are searched for case sensitive
const array<string> profanityFilter_fullWords = { "tit", "tits", "ass", "fuk" };

// the character by which the words need to be replaced
const uint8 profanityFilter_replacementChar = ord('*');

bool filterProfanity(const string &in text, string &out newText)
{
	bool censored = false;
	newText = text;
	const string itext = stringToLowerCase(text);
	int index = -1;
	for(uint i=0; i<profanityFilter_words.length(); ++i)
	{
		index = itext.findFirst(profanityFilter_words[i], 0);
		while(index>=0)
		{
			for(int k=index; k<index+profanityFilter_words[i].length(); ++k)
			{
				newText[k] = profanityFilter_replacementChar;
			}
			censored = true;
			index = itext.findFirst(profanityFilter_words[i], index+profanityFilter_words[i].length());
		}
	}
	
	// note: this isn't case insensitive!
	bool censored2 = false;
	array<string> @emsg = @newText.split(" ");
	index = -1;
	for(uint i = 0 ; i<profanityFilter_fullWords.length(); i++)
	{
		index = emsg.find(profanityFilter_fullWords[i]);
		while(index>=0)
		{
			emsg[index] = "***";
			for(uint k=2; k<profanityFilter_fullWords[i].length(); ++k)
			{
				emsg[index] += "*";
			}
			censored2 = true;
			index = emsg.find(index+1, profanityFilter_fullWords[i]);
		}
	}
	
	if(censored2)
		newText = join(emsg, " ");

	return (censored || censored2);
}

bool containsProfanity(const string &in text)
{
	const string itext = stringToLowerCase(text);
	int index = -1;

	for(uint i=0; i<profanityFilter_words.length(); ++i)
	{
		index = itext.findFirst(profanityFilter_words[i], 0);
		if(index>=0)
			return true;
	}
	
	// note: this isn't case insensitive!
	array<string> @emsg = @itext.split(" ");
	index = -1;
	for(uint i = 0 ; i<profanityFilter_fullWords.length(); i++)
	{
		index = emsg.find(profanityFilter_fullWords[i]);
		if(index>=0)
			return true;
	}

	return false;
}
