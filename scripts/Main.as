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
	"2004HummerH2.truck","camry.truck","m3e93_gold.truck","2010_Chevy_Camaro_SS.truck","chevysilveradonascar.truck","chevysilveradonascarsuper.truck","svtraptor.truck","RenoClio.truck","Ferarri_458_Spider.truck","bmw750i1.truck","bmw750i2.truck","bmw750i3.truck","chevysilverado2.truck","chevysilverado2mud.truck","chevysilverado2500.truck","chevysilverado2500lifted.truck","chevysilverado3500.truck","gavrilmv4police.truck","gavrilmv4PoliceInterceptor.truck","gavrilmv4rpolice.truck","gavrilmv4RUSSIANPOLICE.truck","gavrilmv4sunmarkedpolice.truck","BoxDodgeRamEXT222.truck","svtraptoroffroadv1.truck","svtraptoroffroadv2.truck","gavril_monster_energy.truck","gavril_monster_energy1.truck","spacewagon_lhd.truck","forester.truck","foc07.truck","nissanr34.truck","camry97.truck","cvev.truck","2115.truck","vaz2.truck","vol.truck","ferrari_458_spider.truck","chevelle.truck","MMCP-C.truck","reven.truck","merc.truck","lincoln.truck","koenigsegg.truck","funnytex.truck","funnytex2.truck","hummerh.truck","focus.truck","Supra92.truck","BeastyG2.truck","Mafioso.truck","DatSwaqqerStickerBomber.truck","TriggerFinger.truck","bcgtpm.truck","gavrilmv4Di1.truck","gavrilmv4Di12.truck","gavrilmv4_ret.truck","gavrilluxury.truck","gavrilmv4_n24.truck","gavrilmv4_nur.truck","gavrilmv4_xd1.truck","gavrilmv4r_POLICe.truck","pri.truck","Peugeot406.truck","1997HondaCivicType-R.truck","gazel.truck","gavrilgv3_DRAG.truck","Ferrari1989F40Competizione.truck","daytonahazzard.truck","ATV.truck","1983AudiSportquattro.truck","1990_BMW_M5_E34.truck","tt.truck","2012Mercedes-BenzS65AMG[W221].truck","Niva.truck","2114u.truck","buffalo.truck","buffaloP.truck","20.truck","tax.truck","sultan.truck","gavrilmv4_jdm.truck","chevy10blazer.truck","ICCE300Meshed_Beta2L.truck","ICCE300Meshed_Beta3AGV_1.truck","private1.truck","private2.truck","private3.truck","GCPS-2016BluebirdVision.truck","GCPS-2016BluebirdVision_white.truck","GCPS-2016BluebirdVision_y.truck","GCPS-2016BluebirdVision_wy.truck","GCPS-2016BluebirdVision_s.truck","GCPS-2016BluebirdVision_white_S.truck","GCPS-2016BluebirdVision_wy_s.truck","GCPS-2016BluebirdVision_y_s.truck","JH-AmtranB800.truck","JH-Amtran3800.truck","JH-Amtran3800SED.truck","JH-AmtranB800SED.truck","1999ThomasMVPERFPS.truck","2007ThomasC2FPS.truck","2007ThomasC2.truck","2009BBA3RE.truck","2010ICCE.truck","2010ICCEFPS.truck","2013BBT3FE.truck","2013ThomasEFX.truck","2013ThomasEFXFPS.truck","2011BBA3.truck","2000BBFS65.truck","2001BB3800.truck","2006BBICCE.truck","2013BBV.truck","2002A3CCS3502JH.truck","moskvich412.truck","02CrownVicPoliceUnmarked.truck","06chargerunmarked.truck","12policecharger.truck","2011FordTarusSlicktop.truck","06policeimpala.truck","2011FordTaruPolice.truck","C2(40).truck","8552008BBVPBCRET.truck","dcds.truck","impala.truck","daytona.truck","AMC_Javelin2.truck","amcpacer.truck","ae86_compom.truck","silvias13.truck","silvias13DriftTune.truck","honda97.truck","r33.truck","subaru22.truck","2001su.truck","rx7.truck","nissanR34.truck","2010Shelbygt500.truck","lexusis300.truck","hondansxgt.truck","su05.truck","su05-2.truck","chevyimpala.truck","chevyimpalanowheels.truck","f430_scu.truck","2008su.truck","m3e92.truck","m3e92_gold.truck","2009DodgeChallengerSRT8(fps).truck","2009DodgeChallengerSRT8.truck","jeep_.truck","mazda3.truck","2010ChevyCamaroSS.truck","x5.truck","vwtour.truck","11'porsche911gt3.truck","Buggati.truck","suzuki.truck","12Mazda_RX8.truck","Dodge_ch_392.truck","moskvich.truck","2107.truck","300ZX.truck","350Z.truck","2104.truck","115.truck","passat.truck","bcgtpm2.truck","continental.truck","m3.truck","e38.truck","cater500.truck","Chevroletss.truck","dmc12.truck","vip.truck","vip2.truck","vip3.truck","fer.truck","ToyotaSoarer.truck","Fordfiesta.truck","gavrilmv2r.truck","gavrilgv5_RA1PID.truck","delsol.truck","kalina_hatch.truck","ccx.truck","land200.truck","Maibatsu_Sport.truck","Maibatsu_LT.truck","Maibatsu.truck","rx7drift!.truck","mazda-rx-7-mad-mike.truck","3dc2eUID-MM-MagmaEdition-400-ls.truck","evoix.truck","evox2.truck","evox.truck","nissan240sx3.truck","nissan240sx3_dragster.truck","nissan240sx3_drifter.truck","nissan240sx3_fps.truck","nissan240sx3_drifter_fps.truck","Primera.truck","Nissan_GTR-R35.truck","nislaubos.truck","cuda.truck","R32.truck","rx7drifttune.truck","brzs.truck","brzs_blue.truck","supra.truck","supradrifttune.truck","Supra.truck","Supra2.truck","soarer.truck","21099.truck","Volvo242.truck","Volvo242drag.truck","Volvo242Street.truck","Volvo242WRC.truck","Race_Touareg.truck","2011H-519.truck","2015H-578.truck","2017H-603.truck","2014-565.truck","2016-590.truck","2009-1.truck","2009-2.truck","2010-1.truck","2010-2.truck","2011-1.truck","2011-2.truck","2012-1.truck","2012-2.truck","2013-1.truck","2014-1.truck","2015-1.truck","2016-1.truck","2017-1.truck","2018-1.truck","2008-1.truck","2007-1.truck","2006-1.truck","2005-1.truck","2005-2.truck","2006-2.truck","2007-2.truck","2008-2.truck","2013-2.truck","2013-3.truck","2013-4.truck","2014-2.truck","2015-2.truck","2016-2.truck","2017-2.truck","2018-2.truck","2019-1.truck","2019-2.truck","2003-432.truck","NSCbus1.truck","NSCbus34.truck","NSCbus42.truck","NSCbus9.truck","NSCbus93.truck","NSCbus94.truck","NSCbus36.truck","NSCbus32.truck","NSCbus59.truck","ICCE300Meshed_Beta2K.truck","ICCE300Meshed_Beta2K.TRUCK","2007-IC-CE-GCSNC-Bus-24.truck","2010ICCE-N.truck","2006ICCE-A.truck","2017ThomasC2-SEMINOLE-61615.truck","JPS2018-181.truck","LABS9580.truck","2014ICFE300.truck","2008BluebirdVision530.truck","2008BluebirdVision534.truck","2009BluebirdVision537.truck","2009BluebirdVision538.truck","2015BluebirdVision632.truck","2015BluebirdVision637.truck","2015BluebirdVision638.truck","2016BluebirdVision732.truck","2017BluebirdVision739.truck","2018BluebirdVision731.truck","2019BluebirdVision736.truck","2019BluebirdVision737.truck","2020BluebirdVision733.truck","1992BBB700-0392.truck","lacheti.truck","2019BBV24.truck","2018-TRRS-281.truck","2017BBV25.truck","2012BBV7.truck","1992BBC60-0292.truck","2018QISD1817.truck","2005QISD0523.truck","2003QISD0318.truck","2004-IC-CE-GCSNC-Bus-1.truck","2005ICCE200-HOLCOMB-137.truck","af25UID-aaadodgeviper.truck","CSMVPER.truck","CSMVPR2.truck","2018BluebirdVision738.truck","NBBC500-PUBLICR-5_WIM-I.truck","1998ThomasVista[I].truck","14-21.truck","1997GCPSTC2000.truck","1995ThomasMVPER.truck","2017ThomasHDX-SEMINOLE-61711.truck","2008ICCE300-179-SH-Lucini.truck","1997Crown9707.truck","GSX1.0.truck","2008C2J.truck","2010C2J.truck","2010C2A.truck","2014C2D.truck","2016C2N.truck","2006-IC-CE-GCSNC-Bus-22.truck","55-2015BBIntWorkstar.truck","Design-X.truck","2011ICCE300-3506.truck","2017ICCE300-3892.truck","1997BBFS651.truck","1998BBFS652.truck","2011CE300.truck","2018CE300.truck","2006FS65-24.truck","gavril_r_gold_legend.truck","2004A3CCS5804.truck","2009-Thomas-C2-NC.truck","2001-Thomas-FS65.truck","2014ThomasEFX.truck","2015ThomasEFX.truck","2016ThomasEFX.truck","2017ThomasEFX.truck","2018ThomasEFX.truck","1998BBFS651.truck","2019ThomasC2WY.truck","1999Crown9901.truck","2014ICCE300Handicap.truck","UPT1997BB3800.truck","1999Thomas3800.truck","HLS1998B21.truck","2004ICCE-Lucini-183.truck","HLS2003B38.truck","HLS2008B2.truck","HLS2002B31.truck","1969DodgeChargerRT.truck","79ChevyCamaroZ28.truck","54a9UID-2006Charger-Red.truck","54a9UID-2006ChargerADE.truck","54a9UID-2006ChargerDET.truck","54a9UID-2006ChargerLAPDST.truck","54a9UID-2006ChargerPPB.truck","54a9UID-2006Charger-Blue.truck","54a9UID-2006Charger-Black.truck","54a9UID-2006Charger-Silver.truck","2002ThomasFS65Cat7.truck","1949_Ford_Gasser.truck","2010Shelbygt500ERCAWD.truck","2010Shelbygt500ERCRWD.truck","C10lololol4.truck","evoix_saquet.truck","1979_Blazer_ERC.truck","bel.truck","ffrskb.truck","1999Crown9972.truck","2003BBChevy.truck","1997Crown9704.truck","2004BB3800-SERSD-250.truck","2004BB3800-SERSD-265.truck","2015BBV_SERSD-12.truck","AastonMartinVanquishf.truck","diablo.truck","2000ThomasMVPER.truck","2005-449.truck","C2(FS-5).truck","2004QISD0440.truck","2016-IC-CE-GCSNC-Bus-16.truck","2006-IC-CEGCSNC-Bus-19.truck","1999GCPSTC2000.truck","2007ICFE300505.truck","2012-IC-CE-Bus-20.truck","2006ICCE-Ds.truck","2006ICCE-Jn.truck","2007ICCE-D.truck","2008ICCE-JD.truck","2011ICCE-E.truck","2015ICCE-C.truck","2014ICCEACT.truck","1993-Ford-B700.truck","99-02.truck","2010ThomasC2NewYork.truck","2010ThomasC2NewYorkFPS.truck","2018-260.truck","2017QISD1739.truck","99-01.truck","2009ThomasC2ED706.truck","2016ThomasC2ED944.truck","1705.truck","2020ThomasC2CarolinaThomas.truck","2006C2141.truck","2006C2153.truck","2009C2299.truck","2006C2157.truck","2003QISD0321.truck","2019ICCE-ED41.truck","2013ICCE-ED26H.truck","2020ICCE-ED53.truck","2018BBV.truck","2010ICFE300.truck","audi90.truck","2004-IC-CE-GCSNC-Bus-7.truck","2010-IC-CE-GCSNC-Bus-9.truck","2006ICCEGCSNCBus17.truck","Bus25-04.truck","2015ICCE-1515ED.truck","Bus20-16.truck","2015ICCE300.truck","Bus19-10.truck","Bus7-12.truck","Bus50-08.truck","AstonMartin_v8_Vantage.truck","SheriffTaurus.truck","PoliceUndercoverTaurus.truck","PoliceTaurus.truck","WhiteTaurus.truck","OrangeTaurus.truck","NycCab.truck","Barwood.truck","GreyTaurus.truck","GreenTaurus.truck","CivTaurus.truck","BlueTaurus.truck","BlackTaurus.truck","crownviccop1.truck","Bus9-08.truck","Bus30-14.truck","Badass_Bandit.truck","Track_Bandit.truck","Street_Bandit.truck","1999BB3800991.truck","2005ICFE300.truck","pri_gold.truck","TCPSD60.truck","Lucini-CCS2919.truck","Lucini-MJ1772.truck","Lucini206.truck","DTC997.truck","1986-GMC-Diesel-6000.truck","1999-Freightliner-FS65.truck","2001ToyotaChaser.truck","08_C2_L.truck","2017DSS0321.truck","2017DSS1742.truck","2017DSS1743.truck","2003QISD0312.truck","2006ICFE300506.truck","2007ICFE300500.truck","2007ICFE300509.truck","2001A3CCS4901.truck","HECK-MEYERS2009ThomasC2191.truck","HECK-MEYERS2010ThomasC2165.truck","HECK-MEYERS2919.truck","HECK-MEYERS315.truck","Bus21.truck","UPT2017BBV.truck","2003ICCE-K867.truck","2018Handi-283.truck","1991MazdaRx7.truck","2010-Bluebird-All-American.truck","2010_BB_AA_RE_NC.truck","HECK-MEYERS947.truck","2015-572-P.truck","burnside_badass_convertible.truck","04BluebirdVISION.truck","Incandesent2005CE300MilfordSkin.truck","NoDistrict1.truck","NoDistrict2.truck","NoDistrict3.truck","NoDistrict4.truck","NoDistrict5.truck","NoDistrict6.truck","NoDIstrict7.truck","NoDistrict8.truck","NoDistrict9.truck","NoDistrict10.truck","2020BBVMrCRP.truck","NBBC400-PUBLICR-4BugFixes_WIM-I.truck","NBBC400-PUBLICR-4BugFixes_WM-I.truck","NBBC400-PUBLICR-4BugFix_WIM.truck","NBBC400-PUBLICR-4BugFix_WM.truck","NBBC400-Baldi2021.truck","ChrisBusModificationsAmTranFE-8.truck","AmTranRE.truck","Bald'sBus.truck","TONAWANDA2015CE300SPARE-47.truck","2016BBV.truck","BD642005CE200.truck","BD642006CE200.truck","BD642009CE300.truck","BD642010CE300.truck","BD642012CE300.truck","BD642013CE300.truck","bluebirdbus.truck","MEVS_2009_ICCE300_Bus43v4.truck","MEVS_2009_ICCE300_Bus43.truck","2000AmTranREBusHeritage66(HI).truck","2000AmTranREBusHeritage66(NWSA).truck","2000AmTranREBusHeritage66(WSA).truck","NBBC500-PUBLICR-6_WIM-I.truck","NBBC500-PUBLICR-6_WM-I.truck","NBBC500-PUBLICR-6_WIM.truck","NBBC500-PUBLICR-6_WM.truck","2000AmTranREBusHeritage66(HI)(NWSA).truck","ChrisBusModifications2020ThomasC2.truck","2020ThomasC2.truck","cbm-3800.truck","CBM2020CE300.truck","CE-300.truck","2006ICFE300-4.truck","2006ICFE300-2.truck","2006ICFE300-3.truck","2006ICRE300-1.truck","2006ICRE300-2.truck","CBM-BB3800-1.truck","2006ICRE300ND.truck","CBM-BB3800-2.truck","Ryzen_H7_FPS_Incandesent.truck","Howland1.truck","Howland84.truck","CBM2019ICRE-2.truck","NBBCINTERNATIONAL2485-PublicR-1.1BugFix.truck","1997GCPSCBM3800.truck","1996GCPS9627.truck","1996GCPS9622.truck","1996GCPS9623.truck","1996GCPS9624.truck","1996GCPS9625.truck","1997GCPS9711.truck","MEVS_2009_ICCE300_Bus43v2.truck","2004MEVS51-7.truck","2004MEVS64-7.truck","Bus33.truck","NBBC400-PUBLICR-3_WIM-I.truck","NBBC400-PUBLICR-3_WM-I.truck","NBBC400-PUBLICR-3_WIM.truck","NBBC400-PUBLICR-3_WM.truck","NBBC400-PUBLICR-5_WIM-I.truck","NBBC400-PUBLICR-5_WM-I.truck","NBBC500-PUBLICR-5_WIM.truck","NBBC500-PUBLICR-5_WM.truck","NBBCINTERNATIONAL2400-PublicR.truck","NBBC400-7.truck","NBBC400-PUBLICR.truck","2019NWBUSNBBC-6.truck","2019NWBUSNBBC-5.truck","NBBCtest.truck","2004NCPSSC6.truck","2004NCPSSC7.truck","2004NCPSSC8.truck","2004NCPSSC9.truck","2004NCPSSC10.truck","2004NCPSSC11.truck","2004NCPSSC12.truck","2004NCPSSC13.truck","2004NCPSSC14.truck","2004NCPSSC15.truck","2004NCPSSC16.truck","LABS0867.truck","LABS0952.truck","LABS1251.truck","LABS1368.truck","LABS1369.truck","LABS1370.truck","LABS1371.truck","LABS1658.truck","LABS1660.truck","NCPSSC1.truck","NCPSSC2.truck","NCPSSC3.truck","NCPSSC4.truck","NCPSSC5.truck","NCPSSC25.truck","NCPSSC26.truck","2005CE200.truck","2006CE200.truck","2009CE300.truck","2010CE300.truck","2012CE300.truck","2013CE300.truck","2006ICRE300ND-2.truck","Ryzen_X7000_NorthSchools50spare_Incandesent.truck","Ryzen_X7000_NorthSchools180-route_Incandesent.truck","SMFCS33.truck","RyzenFE.truck","Ryzen_X7000_FPS_Incandesent.truck","2019.truck","activity23.truck","activity24.truck","SEVS2003BBV.truck","SEVS2004BBV.truck","SEVS2005BBV.truck","SEVS2006BBV.truck","SEVS2007BBV.truck","SEVS2008BBV.truck","SEVS2009BBV.truck","SEVS2010BBV.truck","SEVS2011BBV.truck","SEVS2012BBV.truck","SEVS2013BBV.truck","SEVS2014BBV.truck","SEVS2015BBV.truck","SEVS2016BBV.truck","SEVS2017BBV.truck","SEVS2019BBV.truck","SEVS1996BBTC2000.truck","SEVS1997BBTC2000.truck","SEVS1997BBTC20009724.truck","SEVS1997BBTC20009725.truck","SEVS1998BBTC2000.truck","SEVS1999BBTC2000.truck","SEVS1999BBTC20009900.truck","SEVS1999BBTC20009940.truck","SEVS1999BB3800991.truck","BBV95.truck","BBV95S.truck","BBV95H.truck","BBV952SU.truck","BBV954HMU.truck","BBV954HU.truck","BBV952SMU.truck","BBV953MU.truck","BBV953U.truck","BBV954U.truck","BBV954MU.truck","BBV952S.truck","BBV952SM.truck","BBV952M.truck","BBV952H.truck","BBV952HM.truck","BBV953M.truck","BBV953.truck","BBV952.truck","BBV954.truck","BBV954M.truck","BBV951.truck","BBV951M.truck","BBV95M.truck","BBV95HM.truck","BBV95SM.truck","SEVS2005ICFE300.truck","SEVS2006ICFE300.truck","SEVS2007ICFE300.truck","SEVS2008ICFE300.truck","SEVS2009ICFE300.truck","SEVS2010ICFE300.truck","37.truck","SEVS2005CE200.truck","SEVS2006CE200.truck","SEVS2009CE300.truck","SEVS2010CE300.truck","SEVS2012CE300.truck","SEVS2013CE300.truck","SEVS2019CE300.truck","2001SEVS0138.truck","2002SEVS0215.truck","2004SEVS0311.truck","2004SEVS0312.truck","2004SEVS0314.truck","2004SEVS0316.truck","2004SEVS0318.truck","2004SEVS0319.truck","2004SEVS0327.truck","2004SEVS0334.truck","2004SEVS0346.truck","KEVINSEVS2017ICCE.truck","CHRISSEVS2017ICCE.truck","RYANSEVS2017ICCE.truck","bus6.truck","bus7.truck","bus26.truck","bus27.truck","bus28.truck","bus29.truck","bus30.truck","bus31.truck","bus32.truck","bus33.truck","2009BBA3FE.truck","NBBCFE400.truck","NBBCRE400.truck","2008BBV.truck","UPT2014ThomasHDX.truck","UPT2018ThomasHDX.truck","1997BBGMC.truck","1997BBFS65.truck","1999ThomasMVPER.truck","AISD2001ThomasMVPER.truck","AISD2000ThomasMVPER.truck","AISD1999ThomasMVPER.truck","AISD1997ThomasMVPER.truck","AISD1996ThomasMVPER.truck","AISD1995ThomasMVPER.truck","2001ThomasMVPER.truck","2003A3.truck","2006ICFE300.truck","2006ICRE300FPS.truck","2006ICRE300.truck"
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