#include "chatManager.as"
#include "terrainEditor.as"
#include "gameScriptWrapper.as"
#include "welcome.as"
#include "streamValidation.as"
#include "botAPI.as"
#include "kickNotificationWrapper.as"

// Create a chatManager object instance
chatManager chatSystem();



// Create a gameScriptManager object instance.
gameScriptManager gsm();



// Add the autoModerator plugin.
// This plugin allows the following commands:
//     - !suspendchat   Suspend all chat traffic for a certain time
//     - !schat         Short for !suspendchat
//     - !chatban       Blocks all chat messages from a certain user for a
//                      certain time
//     - !cban          Short for !chatban
//     - !temporaryban  Not yet implemented
//     - !tempban       Short for !temporaryban
//     - !tban       Short for !temporaryban
// Furthermore, it adds the profanity filter and flood filter to the chat.
chatPlugin_autoModerator autoModerator(@chatSystem);

// This small plugin transform messages like:
//      Anonymous: OMG LOOK ATZ ME
// to:
//      Anonymous: Omg look atz me
chatPlugin_disallowAllUpperCase disallowAllUpperCase(@chatSystem);

// This plugin adds the following commands:
//     - !afk           Prints "<username> is now away from keyboard."
//     - !back          Prints "<username> is now back."
//     - !gtg           Prints "<username> has got to go."
//     - !brb           Prints "<username> will be right back."
chatPlugin_miscellaneousCommands miscellaneousCommands(@chatSystem);

// This command adds the !move command, which will move your avatar in the
// specified direction.
chatPlugin_moveCommand moveCommand(@chatSystem);

// This commands adds the !goto, !setgoto (!sgoto) and !delelegoto (!dgoto)
// command. It allows you to store the position of your avatar (!setgoto <name>)
// and later teleport to that position (!goto <name>).
// Note: The !setgoto command works only with RoR 0.39! (not with 0.38)
chatPlugin_gotoCommand gotoCommand(@chatSystem, @gsm);

// This keeps track of what terrains are being used on the server and gives a
// list when the !terrainlist (!tlist) command is used.
// Note: All clients with RoR 0.38 will be shown as 'unknown terrain'.
chatPlugin_terrainList terrainList(@chatSystem, @gsm);

// This checks the latency of all RoR 0.39 players every 20 seconds and responds
// to !ping commands.
chatPlugin_ping ping(@chatSystem, @gsm);

// Another example, to show how to add commands.
// This adds a command !boost that gives a temporary boost to the truck of
// the user.
customCommand boostCommand(@chatSystem, "boost", customCommand_boost);
void customCommand_boost(chatMessage@ cmsg)
{
	cmsg.privateGameCommand.boostCurrentTruck(5);
}
// Extra boost commands
customCommand boost2Command(@chatSystem, "boost2", customCommand_boost2);
void customCommand_boost2(chatMessage@ cmsg)
{
	cmsg.privateGameCommand.boostCurrentTruck(10);
}
customCommand boost3Command(@chatSystem, "boost3", customCommand_boost3);
void customCommand_boost3(chatMessage@ cmsg)
{
	cmsg.privateGameCommand.boostCurrentTruck(100);
}
customCommand boost4Command(@chatSystem, "boost4", customCommand_boost4);
void customCommand_boost4(chatMessage@ cmsg)
{
	cmsg.privateGameCommand.boostCurrentTruck(500);
}


// Add the terrain editor (RoR 0.39 only!)
// Commented out, doesn't work correctly yet.
//terrainEditor ternnditor(@chatSystem, @gsm);



// Load the terrain edits
terrainFileLoader terrain(@gsm, server.getServerTerrain());



// Add some commands that allow you to reload the terrain file, without having to restart the server.
customCommand reloadTerrainCommand(@chatSystem, "reloadterrain", customCommand_reloadTerrain, null, true, AUTH_ADMIN);
void customCommand_reloadTerrain(chatMessage@) { terrain.reload(); }

customCommand unloadTerrainCommand(@chatSystem, "unloadterrain", customCommand_unloadTerrain, null, true, AUTH_ADMIN);
void customCommand_unloadTerrain(chatMessage@) { terrain.unload(); }

customCommand loadTerrainCommand(@chatSystem, "loadterrain", customCommand_loadTerrain, null, true, AUTH_ADMIN);
void customCommand_loadTerrain(chatMessage@)   { terrain.load();   }

// This is a list of stream names that will not be broadcasted 
array<string>  streamFilterList =  
{ 
    "daytona.truck", "ae86_compom.truck", "lexusis300.truck", "2004HummerH2.truck", "su05.truck", "su05-2.truck", "f430_scu.truck", "camry.truck", "camry97.truck", "m3e92.truck", "m3e93_gold.truck", "mazda3.truck", "2010_Chevy_Camaro_SS.truck", "x5.truck", "chevysilveradonascar.truck", "chevysilveradonascarsuper.truck", "nissan240sx3.truck", "nissan240sx3_dragster.truck", "nissan240sx3_drifter.truck", "nissan240sx3_drifter_fps.truck", "nissan240sx3_fps.truck", "svtraptor.truck", "RenoClio.truck", "silvias13.truck", "rx7.truck", "Ferarri_458_Spider.truck", "bmw750i1.truck", "bmw750i2.truck", "bmw750i3.truck", "chevysilverado2.truck", "chevysilverado2mud.truck", "chevysilverado2500.truck", "chevysilverado2500lifted.truck", "chevysilverado3500.truck", "gavrilmv4police.truck", "gavrilmv4PoliceInterceptor.truck", "gavrilmv4rpolice.truck", "gavrilmv4RUSSIANPOLICE.truck", "gavrilmv4sunmarkedpolice.truck", "supra.truck", "BoxDodgeRamEXT222.truck", "svtraptoroffroadv1.truck", "svtraptoroffroadv2.truck", "gavril_monster_energy.truck", "gavril_monster_energy1.truck", "spacewagon_lhd.truck", "forester.truck", "foc07.truck", "2009 Dodge Challenger SRT8 (fps).truck", "2009 Dodge Challenger SRT8.truck", "su05.truck", "nissanr34.truck", "camry97.truck", "cvev.truck", "12Mazda_RX8.truck", "vwtour.truck", "2115.truck", "vaz2.truck", "vol.truck", "hondansxgt.truck", "ferrari_458_spider.truck", "chevelle.truck", "MMCP-C.truck", "honda97.truck", "reven.truck", "moskvich.truck", "merc.truck", "lincoln.truck", "koenigsegg.truck", "m3e92_gold.truck", "m3e92.truck", "funnytex.truck", "funnytex2.truck", "hummerh.truck", "2010Shelbygt500.truck", "Supra.truck", "impala.truck", "focus.truck", "dcds.truck", "1990_BMW_M5_E34.truck", "Supra 92.truck", "Beasty G2.truck", "Mafioso.truck", "DatSwaqqer Sticker Bomber.truck", "Trigger Finger.truck", "2001su.truck", "Toyota Soarer.truck", "Ford fiesta.truck", "Nissan_GTR-R35.truck", "nissanR34.truck", "bcgtpm.truck", "gavrilmv4Di1.truck", "gavrilmv4Di12.truck", "gavrilmv4_ret.truck", "gavrilluxury.truck", "gavrilmv4_n24.truck", "gavrilmv4_nur.truck", "gavrilmv4_xd1.truck", "gavrilmv4r_POLICe.truck", "pri.truck", "2107.truck", "Peugeot 406.truck", "1997 Honda Civic Type-R.truck", "21099.truck", "1983 Audi Sport quattro.truck", "daytonahazzard.truck", "ATV.truck", "suzuki.truck", "gazel.truck", "2114u.truck", "tt.truck", "gavrilgv3_DRAG.truck", "Ferrari 1989 F40 Competizione.truck", "Race_Touareg.truck", "20.truck", "daytonahazzard.truck", "ATV.truck", "1983 Audi Sport quattro.truck", "1990_BMW_M5_E34.truck", "supra.truck", "tt.truck", "suzuki.truck", "2008su.truck", "2012 Mercedes-Benz S 65 AMG [W221].truck", "Niva.truck", "2114u.truck", "buffalo.truck", "buffaloP.truck", "Chevrolet ss.truck", "20.truck", "tax.truck", "sultan.truck", "gavrilmv4_jdm.truck",  "chevy10blazer.truck", "ICCE300Meshed_Beta2L.truck", "ICCE300Meshed_Beta3AGV_1.truck", "private1.truck", "private2.truck", "private3.truck",  "GCPS-2016BluebirdVision.truck", "GCPS-2016BluebirdVision_white.truck", "GCPS-2016BluebirdVision_y.truck", "GCPS-2016BluebirdVision_wy.truck", "GCPS-2016BluebirdVision_s.truck", "GCPS-2016BluebirdVision_white_S.truck", "GCPS-2016BluebirdVision_wy_s.truck", "GCPS-2016BluebirdVision_y_s.truck", "JH-AmtranB800.truck", "JH-Amtran3800.truck", "JH-Amtran3800SED.truck", "JH-AmtranB800SED.truck", "1999ThomasMVPER.truck", "2007ThomasC2FPS.truck", "2007ThomasC2.truck", "2009BBA3FE.truck", "2009BBA3RE.truck", "2010ICCE.truck", "2010ICCEFPS.truck", "2013BBT3FE.truck", "2013ThomasEFX.truck", "2013ThomasEFXFPS.truck", "2013BBV.truck", "2011BBA3.truck", "1997BBGMC.truck", "2000BBFS65.truck", "2001BB3800.truck", "2006BBICCE.truck", "2013BBV.truck", "Buggati.truck",  "2002A3CCS3502JH.truck", "moskvich412.truck", "2008BluebirdVision530.truck", "2020BluebirdVision733.truck", "2015BluebirdVision638.truck", "2009BluebirdVision537.truck", "2018BluebirdVision731.truck", "2015BluebirdVision632.truck", "02CrownVicPolice Unmarked.truck", "06chargerunmarked.truck", "12policecharger.truck", "2011FordTarusSlicktop.truck",  "2011FordTaruPolice.truck", "06policeimpala.truck", "2011FordTaruPolice.truck", "2019BluebirdVision736.truck", "2009BluebirdVision538.truck", "2016BluebirdVision732.truck", "2018BluebirdVision738.truck", "C2 (40).truck", "8552008BBVPBCRET.truck", "1999thomasmvper.truck", "1999thomasmvperfps.truck", "dcds.truck", "impala.truck", "daytona.truck", "AMC_Javelin2.truck", "amcpacer.truck", "ae86_compom.truck", "silvias13.truck", "silvias13DriftTune.truck", "honda97.truck", "r33.truck", "subaru22.truck", "2001su.truck", "rx7.truck", "nissanR34.truck", "2010Shelbygt500.truck", "lexusis300.truck", "hondansxgt.truck", "su05.truck", "su05-2.truck", "chevyimpala.truck", "chevyimpalanowheels.truck", "f430_scu.truck", "2008su.truck", "m3e92.truck", "m3e92_gold.truck", "2009 Dodge Challenger SRT8 (fps).truck", "2009 Dodge Challenger SRT8.truck", "jeep_.truck", "mazda3.truck", "2010 Chevy Camaro SS.truck", "x5.truck", "vwtour.truck", "11' porsche 911gt3.truck", "Buggati.truck", "suzuki.truck", "12Mazda_RX8.truck", "Dodge_ch_392.truck", "moskvich.truck", "2107.truck", "300ZX.truck", "350Z.truck", "2104.truck", "115.truck", "passat.truck", "bcgtpm2.truck", "continental.truck", "m3.truck", "e38.truck", "cater500.truck", "Chevrolet ss.truck", "dmc12.truck", "vip.truck", "vip2.truck", "vip3.truck", "fer.truck", "Toyota Soarer.truck", "Ford fiesta.truck", "gavrilmv2r.truck", "gavrilgv5_RA1PID.truck", "delsol.truck", "kalina_hatch.truck", "ccx.truck", "land200.truck", "Maibatsu_Sport.truck", "Maibatsu_LT.truck", "Maibatsu.truck", "rx7drift!.truck", "mazda-rx-7-mad-mike.truck", "3dc2eUID-MM-MagmaEdition-400-ls.truck", "evoix.truck", "evox2.truck", "evox.truck", "nissan240sx3.truck", "nissan240sx3_dragster.truck", "nissan240sx3_drifter.truck", "nissan240sx3_fps.truck", "nissan240sx3_drifter_fps.truck", "Primera.truck", "Nissan_GTR-R35.truck", "nislaubos.truck", "cuda.truck", "R32.truck", "rx7drifttune.truck", "brzs.truck", "brzs_blue.truck", "supra.truck", "supradrifttune.truck", "Supra.truck", "Supra2.truck", "soarer.truck", "21099.truck", "Volvo242.truck", "Volvo242drag.truck", "Volvo242Street.truck", "Volvo242WRC.truck", "Race_Touareg .truck", "2011H-519.truck", "2015H-578.truck", "2017H-603.truck", "2014-565.truck", "2016-590.truck", "2009-1.truck", "2009-2.truck", "2010-1.truck", "2010-2.truck", "2011-1.truck", "2011-2.truck", "2012-1.truck", "2012-2.truck", "2013-1.truck", "2014-1.truck", "2015-1.truck", "2016-1.truck", "2017-1.truck", "2018-1.truck", "2008-1.truck", "2007-1.truck", "2006-1.truck", "2005-1.truck", "2005-2.truck", "2006-2.truck", "2007-2.truck", "2008-2.truck", "2013-2.truck", "2013-3.truck", "2013-4.truck", "2014-2.truck", "2015-2.truck", "2016-2.truck", "2017-2.truck", "2018-2.truck", "2019-1.truck", "2019-2.truck", "2003-432.truck", "NSCbus1.truck", "NSCbus34.truck", "NSCbus42.truck", "NSCbus9.truck", "NSCbus93.truck", "NSCbus94.truck", "NSCbus36.truck", "NSCbus32.truck", "NSCbus59.truck", "ICCE300Meshed_Beta2K.truck", "2007-IC-CE-GCSNC-Bus-24.truck", "2010ICCE-N.truck", "2006ICCE-A.truck", "SMFCS33.truck", "2017ThomasC2-SEMINOLE-61615.truck", "JPS2018-181.truck", "LABS9580.truck", "2014ICFE300.truck", "2020ThomasC2.truck", "2008BluebirdVision530.truck", "2008BluebirdVision534.truck", "2009BluebirdVision537.truck", "2009BluebirdVision538.truck", "2015BluebirdVision632.truck", "2015BluebirdVision637.truck", "2015BluebirdVision638.truck", "2016BluebirdVision732.truck", "2017BluebirdVision739.truck", "2018BluebirdVision731.truck", "2018BluebirdVision738.truck", "2019BluebirdVision736.truck", "2019BluebirdVision737.truck", "2020BluebirdVision733.truck", "1992BBB700-0392.truck", "lacheti.truck", "2019BBV24.truck", "2018-TRRS-281.truck", "2017BBV25.truck", "2012BBV7.truck", "1992BBC60-0292.truck", "2018QISD1817.truck", "2005QISD0523.truck", "2003QISD0318.truck", "2004-IC-CE-GCSNC-Bus-1.truck", "2005ICCE200-HOLCOMB-137.truck", "af25UID-aaadodgeviper.truck", "CSMVPER.truck", "CSMVPR2.truck", "2018BluebirdVision738.truck", "1996GCPS9624.truck", "1996GCPS9625.truck", "1996GCPS9622.truck", "NBBC500-PUBLICR-5_WIM-I.truck", "NBBC400-PUBLICR-3_WIM.truck", "1998ThomasVista[I].truck", "NBBC400-Baldi2021.truck", "1997GCPS9711.truck", "14-21.truck", "CBM-BB3800-2.truck", "1997GCPSTC2000.truck", "2001ThomasMVPER.truck", "1995ThomasMVPER.truck", "2017ThomasHDX-SEMINOLE-61711.truck", "AmTranRE.truck", "2000AmTranREBusHeritage66(HI).truck", "2008ICCE300-179-SH-Lucini.truck", "1997Crown9707.truck", "GSX1.0.truck", "2008C2J.truck", "2010C2J.truck", "2010C2A.truck", "2014C2D.truck", "2016C2N.truck", "2006-IC-CE-GCSNC-Bus-22.truck", "55-2015BBIntWorkstar.truck", "Design-X.truck", "2011ICCE300-3506.truck", "2017ICCE300-3892.truck", "1997BBFS651.truck", "1998BBFS652.truck", "2011CE300.truck", "2018CE300.truck", "2006FS65-24.truck", "gavril_r_gold_legend.truck", "2004A3CCS5804.truck", "2009-Thomas-C2-NC.truck", "2001-Thomas-FS65.truck", "2014ThomasEFX.truck", "1998BBFS651.truck", "2019ThomasC2WY.truck", "1999Crown9901.truck", "1997BBFS65.truck", "2014ICCE300Handicap.truck", "UPT1997BB3800.truck", "1999Thomas3800.truck", "HLS1998B21.truck", "2004ICCE-Lucini-183.truck", "HLS2003B38.truck", "HLS2008B2.truck", "HLS2002B31.truck", "bus31.truck"
}; 
streamValidation bannedCars(@streamFilterList, BLACKLIST);


// Our main function (never remove this, even when it does nothing useful!)
void main()
{
	server.Log("The script file is working :D");
	autoModerator.disableFloodFilter();
	server.setCallback("playerAdded", "authWarning_playerAdded", null);
}

// Add this somewhere else, for example at the very bottom of ExampleScript.as
void authWarning_playerAdded(int uid)
{
	if((server.getUserAuthRaw(uid)&(AUTH_ADMIN|AUTH_MOD))>0)
		server.say(server.getUserName(uid)+" is a server "+server.getUserAuth(uid), TO_ALL, FROM_HOST);
}