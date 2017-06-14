class kickNotificationWrapper
{
	kickNotificationWrapper()
	{
		server.setCallback("playerChat", "playerChat", @this);
	}
	
	int playerChat(int uid, const string &in msg)
	{
		if(msg.substr(0,5)=="/kick")
			return BROADCAST_AUTHED;
		else
			return BROADCAST_AUTO;
	}
}

kickNotificationWrapper knw();