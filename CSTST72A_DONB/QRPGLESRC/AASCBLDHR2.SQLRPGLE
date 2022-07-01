000400000000      **********************************************************************
000500000000      *  Program:     AASCBLDHR2
000600000000      *
000700000000      *  Description: - This program takes the place of ADTSENDR on Remarket.
000800000000      *               - Reads the same logicals as ADTSENDR and builds
000801000000      *                 TASCTRMH2(transmit history).
000901000000      *
001000000000      *  Programer :  Greg Adkins
001101000000      *
001200000000      *  Date:        02/09/10
002400000000      *
002500000000      **********************************************************************
002600000000      * Variables and Constants, data structures and data areas
002700000000      **********************************************************************
002800000000     d boxName         s             10a
002801000000     d remoteBox       s             10a
003200000000     d sqlpwd          s             10a
003300000000     d sqlusr          s             10a
003301000000     d TstUsr          s             10a
003400000000     d morerecs1       s              1a
003401000000     d morerecs2       s              1a
003402000000     d emailType       s              1a
003500000000     d okToSend        s              1a
003501000000     d packageError    s              1a
003502000000     d curTs           S               z   inz(z'0001-01-01-00.00.00.000000')
003503000000     d nullTs          S               z   inz(z'0001-01-01-00.00.00.000000')
003504000000     d nullDate        S               d   inz(d'0001-01-01')
003505000000     d pickDt          S               d
003506000000     d dropDt          S               d
003507000000     d xxNotDt         S               d
003508000000     d p_flag          s              1a
003601000000      *
003602000000     d xCnt            s              9s 0
003603000000     d uCnt            s              9s 0
003604000000     d rCnt            s              9s 0
003605000000     d dsCnt           s              9s 0
003606000000     d noteCnt         s              9s 0
003607000000     d xHoreq          s              9s 0
003608000000     d xxAucod         s              3a
003609000000     d xxHoctl         s              9s 0
003610000000     d xxHoreq         s              9s 0
003611000000     d xxNote          s             40a
003612000000     d xxVinno         s             17a
003613000000     d xSqncnb         s              8s 0
003614000000     d xNote           s             40a
003615000000     d sqKey           s              9s 0
003616000000      *
003617000000     d xpgmname        s             20a
003618000000     d xlibrary        s             10a
003619000000     d xRmtSystem      s             10a
003620000000     d xrmtusr         s             10a
003621000000     d xrmtpwd         s             10a
003622000000     d xerrflg         s              1a
003623000000     d xerrnbr         s              3s 0
003624000000     d nHoreq          s              9s 0
003625000000     d nNote           s             40a
003626000000     d sHoreq          s              9s 0
003627000000     d horeqA          s              9a
003628000000      *
003629000000     d wwHoctl         s              9s 0
003630000000     d wwAucod         s              3a
003631000000     d wwContp         s              3a
003632000000     d wwTxcod         s              4a
003633000000     d wwCltin         s              1a
003634000000     d wwCltnr         s              5s 0
003635000000     d wwAnglo         s             10a
003636000000     d wwVinno         s             17a
003637000000     d wwVehyr         s              4s 0
003638000000     d wwVmake         s             10a
003639000000     d wwModel         s             20a
003640000000     d wwColor         s              7a
003641000000     d wwDrvfl         s              1a
003642000000     d wwCatci         s              3a
003643000000     d wwTrnDtIso      s               d
003644000000     d wwUnitn         s             20a
003645000000     d wwCCNam         s             40a
003646000000     d wwPName         s             40a
003647000000     d wwLocin         s              1a
003648000000     d wwLName         s             40a
003649000000     d wwLAdr1         s             24a
003650000000     d wwLAdr2         s             24a
003651000000     d wwCityD         s             24a
003652000000     d wwLStat         s              2a
003653000000     d wwLZipC         s             10a
003654000000     d wwLPhon         s             12a
003655000000     d wwLCntc         s             40a
003658000000      *
003659000000     dEMailDS          DS
003660000000     d dsc                           44
003661000000     d msg                          256
003662000000     d lmsg                        5000
003663000000     d recv1                        128
003664000000     d recv2                        128
003665000000     d recv3                        128
003666000000     d recv4                        128
003667000000     d recv5                        128
003668000000     d recv6                        128
003702000000      * mult occur ds (look in ADTSENDR to define this data structure)
003703000000     D sData           DS                  QUALIFIED DIM(32767)
003705000000     D  sHoctl                        9s 0
003706000000     D  sAucod                        3a
003707000000     D  sContp                        3a
003708000000     D  sTxcod                        4a
003709000000     D  sCltin                        1a
003710000000     D  sCltnr                        5s 0
003711000000     D  sAnglo                       10a
003712000000     D  sVinno                       17a
003713000000     D  sVehyr                        4s 0
003714000000     D  sVmake                       10a
003715000000     D  sModel                       20a
003716000000     D  sColor                        7a
003717000000     D  sDrvfl                        1a
003718000000     D  sCatci                        3a
003719000000     D  sTrnDtIso                      d
003720000000     D  sUnitn                       20a
003721000000     D  sCCNam                       40a
003722000000     D  sPName                       40a
003723000000     D  sLocin                        1a
003724000000     D  sLName                       40a
003725000000     D  sLAdr1                       24a
003726000000     D  sLAdr2                       24a
003727000000     D  sCityD                       24a
003728000000     D  sLStat                        2a
003729000000     D  sLZipC                       10a
003730000000     D  sLPhon                       12a
003731000000     D  sLCntc                       40a
003733000000      * mult occur ds (look in ADTSENDR to define this data structure)
003734000000     D nData           DS                  QUALIFIED DIM(32767)
003735000000     D  nHoctl                        9s 0
003736000000     D  nAucod                        3a
003738000000     D  nVnote                       40a
003739000000     D  nVinno                       17a
003740000000     D  nNotDt                         d
003744000000      * sgntedj01 data
003745000000     D sgntedj01Data   DS
003746000000     D  sjHoctl                       9s 0
003747000000     D  sjAucod                       3a
003748000000     D  sjNotKy                      11p 0
003749000000      * sgnted data
003750000000     D sgntedData      DS
003751000000     D  sgVinno                      17a
003752000000     D  sgVnote                      40a
003753000000     D  sgNotDt                        d
003754000000      * header record
003755000000     D hData           DS
003756000000     D  hHoctl                        9s 0
003757000000     D  hAucod                        3a
003758000000     D  hContp                        3a
003759000000     D  hTxcod                        4a
003760000000     D  hCltin                        1a
003761000000     D  hCltnr                        5s 0
003762000000     D  hAnglo                       10a
003763000000     D  hVinno                       17a
003764000000     D  hVehyr                        4s 0
003765000000     D  hVmake                       10a
003766000000     D  hModel                       20a
003767000000     D  hColor                        7a
003768000000     D  hDrvfl                        1a
003769000000     D  hCatci                        3a
003770000000      * detail record
003771000000     D  dTrnDtIso                      d
003772000000      * streqd record
003773000000     D rData           DS
003774000000     D  RTxCod                        4a
003775000000     D  RConTp                        3a
003776000000     D  RUnitN                       20a
003777000000     D  RPlate                       14a
003778000000     D  RPltMM                        2s 0
003779000000     D  RPltYR                        4s 0
003780000000     D  RPltST                        2a
003781000000     D  RMiles                        6s 0
003782000000     D  RCltIn                        1a
003783000000     D  RCltNr                        5s 0
003784000000     D  RCCNam                       40a
003785000000     D  RPName                       40a
003786000000     D  RLocIn                        1a
003787000000     D  RLocNr                        5s 0
003788000000     D  RLName                       40a
003789000000     D  RLAdr1                       24a
003790000000     D  RLAdr2                       24a
003791000000     D  RCityD                       24a
003792000000     D  RLStat                        2a
003793000000     D  RLZipC                       10a
003794000000     D  RLPhon                       12a
003795000000     D  RLCntc                       40a
003796000000     D  RTrChg                        7s 2
003797000000     D  RAcTim                         z
003798000000      * location record
003799000000     D lData           DS
003800000000     D  lConTp                        3a
003801000000     D  lTxCod                        4a
003802000000     D  lLocIn                        1a
003803000000     D  lLocNr                        5s 0
003804000000     D  lLName                       40a
003805000000     D  lLAdr1                       24a
003806000000     D  lLadr2                       24a
003807000000     D  lCityD                       24a
003808000000     D  lLStat                        2a
003809000000     D  lLZipC                       10a
003810000000     D  lLPhon                       12a
003811000000     D  lLCntc                       40a
003812000000     D  lCatCI                        3a
003813000000     D  lAcTim                         z
003814000000      **********************************************************************
003900000000      * PROTOTYPES
004000000000      **********************************************************************
004006000000     d getBoxName      PR                  EXTPGM('RTVSYSTEM')
004007000000     dpdBoxName                            like(BoxName)
004009000000
004010000000     d BuildPkg        PR                  EXTPGM('BLDSQLPKG')
004011000000     dpdxpgmname                           like(xpgmname)
004012000000     dpdxlibrary                           like(xlibrary)
004013000000     dpdxRmtSystem                         like(xRmtSystem)
004014000000     dpdxrmtusr                            like(xrmtusr)
004015000000     dpdxrmtpwd                            like(xrmtpwd)
004016000000     dpdxerrflg                            like(xerrflg)
004017000000     dpdxerrnbr                            like(xerrnbr)
004018000000
004301000000     d GENEMAILC       PR                  EXTPGM('GENEMAILC')
004302000000     dpdDsc                                like(dsc)
004303000000     dpdMsg                                like(msg)
004304000000     dpdLmsg                               like(lmsg)
004305000000     dpdRecv1                              like(recv1)
004306000000     dpdRecv2                              like(recv2)
004307000000     dpdRecv3                              like(recv3)
004308000000     dpdRecv4                              like(recv4)
004309000000     dpdRecv5                              like(recv5)
004310000000     dpdRecv6                              like(recv6)
004400000000      **********************************************************************
004401000000      *  MAINLINE
004402000000      **********************************************************************
004403000000     c     *entry        Plist
004404000000     c                   parm                    p_flag
004405000000
004600000000      /free
004700000000
004701000000        // get the local boxName
004702000000       callp getBoxName(boxname);
004704000000
004705000000        // set up box names
004707000000       if boxName = 'MARS';
004708000000           remoteBox = 'REMARKET';
004709000000       else;
004710000000           remoteBox = 'MARD';
004716000000       endif;
004717000000
004718000000        // get local signon
004719000000       Exec sql Select Rdat1, Rdat2 into :sqlusr, :sqlpwd
004720000000                  from Tsaamsc where rctyp  = 'SQLON';
004806000000
004807000000        // *  connect to remarket
004808000000       exsr checkSQLPkg;
004809000000       if   packageError = 'Y';
004810000000            exsr  createSQLPkg;
004811000000            exsr  checkSQLPkg;
004812000000            if    packageError = 'Y';
004813000000                eval  emailType = '1';
004814000000                exsr  sendEmailMsg;
004815000000                *inlr = *on;
004816000000                return;
004817000000            endif;
004818000000       endif;
004819000000
004821000000        // begin loop on Sinvhd01, look for new consignments
004822000000       Exec sql Declare CurH dynamic scroll cursor For
004823000000       Select hoctl, aucod, contp, txcod, cltin, cltnr,
004824000000              anglo, vinno, vehyr, vmake, model, color,
004825000000              drvfl, catci
004826000000         from Sinvhd01 For Update of Actim;
005300000000
005400000000       Exec sql Open CurH;
005500000000
005600000000       MoreRecs1 = 'Y';
005700000000       DoW MoreRecs1 = 'Y';
005701000000          clear okToSend;
005702000000          clear hData;
005800000000
005900000000          Exec Sql Fetch next from CurH into
005901000000                   :hHoctl, :hAucod, :hContp, :hTxcod, :hCltin,
005902000000                   :hCltnr, :hAnglo, :hVinno, :hVehyr, :hVmake,
005903000000                   :hModel, :hColor, :hDrvfl, :hCatci;
006015000000
006100000000          if sqlcod <> 0;
006200000000               eval MoreRecs1 = 'N';
006201000000               Iter;
006300000000          else;
006301000000               exsr subSinvdd;
006378000000               if okToSend = 'Y';
006379000000            //      Exec sql Update Sinvhd01 Set Actim = :curTs
006380000000            //                Where current of CurH;
006381000000               endif;
006382000000          endif;
006383000000
006384000000       endDo; // DoW MoreRecs1 = Y
006385000000       Exec sql Close CurH;
006386000000        // END loop on Sinvhd01, look for new consignments
006387000000
006388000000
006389000000        // BEGIN Loop on Sgnted, look for notes
006390000000       Exec sql Declare CurN1 dynamic scroll cursor For
006391000000       Select hoctl, aucod, notky
006392000000              From Sgntedj01 Order by hoctl, aucod, notky;
006394000000
006395000000       Exec sql Open CurN1;
006396000000
006397000000       clear noteCnt;
006398000000       curTs = %timestamp();
006399000000       MoreRecs2 = 'Y';
006400000000       DoW MoreRecs2 = 'Y';
006401000000          clear sgntedj01Data;
006404000000
006405000000          Exec Sql Fetch next from CurN1 into :sjHoctl, :sjAucod, :sjNotky;
006406000000
006407000000          if sqlcod <> 0;
006408000000               eval MoreRecs2 = 'N';
006409000000          else;
006410000000               clear sgntedData;
006412000000               Exec Sql Select vinno, vnote, notdtiso
006413000000                         into :sgVinno, :sgVnote, :sgNotDt
006414000000                          From Sgnted Where Hoctl = :sjHoctl and
006415000000                                            Aucod = :sjAucod and
006416000000                                            Notky = :sjNotky;
006417000000                    if sqlcod = 0;
006418000000                         noteCnt = noteCnt + 1;
006419000000                         nData(noteCnt).nhoctl = sjHoctl;
006420000000                         nData(noteCnt).nAucod = sjAucod;
006421000000                         nData(noteCnt).nVnote = sgVnote;
006422000000                         nData(noteCnt).nVinno = sgVinno;
006423000000                         nData(noteCnt).nNotDt = sgNotDt;
006424000000
006425000000                    //   Exec Sql Update Sgnted Set Actim = :curTs
006426000000                    //             Where Hoctl = :sjHoctl
006427000000                    //               and Aucod = :sjAucod
006428000000                    //               and Notky = :sjNotky;
006429000000                    endif;
006430000000          endif;
006431000000
006432000000       endDo; // DoW MoreRecs2 = Y
006433000000       Exec sql Close CurN1;
006434000000
006470000000        // *  connect back to local box
006471000000       Exec Sql Disconnect All;
006472000000       Exec Sql Connect Reset;
006473000000
009203000000        // *  if no records exit program
009204000000       if   dsCnt = 0;
009207000000            *inlr = *on;
009208000000            return;
009209000000       else;
009210000000            eval p_flag = 'Y';
009211000000       endif;
009212000000
009213000000       // * ---------------------------------------
009214000000       // * HAD RECORDS ON REMARKET SO PROCESS THEM
009215000000       // * ---------------------------------------
009216000000
009227000000        // *  loop thru vehicle DS insert into hist file
009228000000       clear rCnt;
009229000000       DoU rCnt = dsCnt;
009230000000           rCnt = rCnt + 1;
009231000000           wwHoctl  = sData(rCnt).sHoctl;
009232000000           wwAucod  = sData(rCnt).sAucod;
009233000000           wwContp  = sData(rCnt).sContp;
009234000000           wwTxcod  = sData(rCnt).sTxcod;
009235000000           wwCltin  = sData(rCnt).sCltin;
009236000000           wwCltnr  = sData(rCnt).sCltnr;
009237000000           wwAnglo  = sData(rCnt).sAnglo;
009238000000           wwVinno  = sData(rCnt).sVinno;
009239000000           wwVehyr  = sData(rCnt).sVehyr;
009240000000           wwVmake  = sData(rCnt).sVmake;
009241000000           wwModel  = sData(rCnt).sModel;
009242000000           wwColor  = sData(rCnt).sColor;
009243000000           wwDrvfl  = sData(rCnt).sDrvfl;
009244000000           wwCatci  = sData(rCnt).sCatci;
009245000000           wwTrnDtIso = sData(rCnt).sTrnDtIso;
009246000000           wwUnitn  = sData(rCnt).sUnitn;
009247000000           wwCCNam  = sData(rCnt).sCCNam;
009248000000           wwPName  = sData(rCnt).sPName;
009249000000           wwLocin  = sData(rCnt).sLocin;
009250000000           wwLName  = sData(rCnt).sLName;
009251000000           wwLAdr1  = sData(rCnt).sLAdr1;
009252000000           wwLAdr2  = sData(rCnt).sLAdr2;
009253000000           wwCityD  = sData(rCnt).sCityD;
009254000000           wwLStat  = sData(rCnt).sLStat;
009255000000           wwLZipC  = sData(rCnt).sLZipC;
009256000000           wwLPhon  = sData(rCnt).sLPhon;
009257000000           wwLCntc  = sData(rCnt).sLCntc;
009283000000
009285000000           Exec Sql Select Max(horsq) into :sqKey from Tasctrmh2
009286000000                           Where horeq = :xxHoctl;
009287000000           sqKey = sqKey + 1;
009288000000
009289000000           eval pickDt = nullDate;
009290000000           eval dropDt = nullDate;
009291000000           if wwContp = 'DRP';
009292000000                eval dropDt = wwTrnDtIso;
009294000000           else;
009295000000                eval pickDt = wwTrnDtIso;
009297000000           endif;
009298000000
009299000000           Exec Sql Insert into Tasctrmh2
009300000000                       (rectyp,   horeq,    horsq,   vinnb,    unitn,
009301000000                        anglo,    pckdt,    drpdt,   pname,    vehyr,
009302000000                        vmake,    model,    lname,   ladr1,    ladr2,
009303000000                        cityd,    lstat,    lzipc,   lcntc,    lphon,
009304000000                        drvfl,    aucod,    contp,   txcod,    cltin,
009305000000                        cltnr,    color,    catci,   ccnam,    locin,
009306000000                        notetx,   addts,    xmitts)
009307000000                    Values
009308000000                       ('A',     :wwHoctl,  :sqKey,  :wwVinno, :wwUnitn,
009309000000                        :wwAnglo,:pickDt,   :dropDt, :wwPName, :wwVehyr,
009310000000                        :wwVmake,:wwModel,  :wwLname,:wwLadr1, :wwLadr2,
009311000000                        :wwCityD,:wwLStat,  :wwLZipc,:wwLCntc, :wwLPhon,
009312000000                        :wwDrvfl,:wwAucod,  :wwContp,:wwTxcod, :wwCltin,
009313000000                        :wwCltnr,:wwColor,  :wwCatci,:wwCCNam, :wwLocin,
009314000000                        ' ',     current_timestamp, :nullTs);
009316000000
009330000000       enddo;   // endDo for dsCnt
009331000000
009332000000        // *  loop thru notes DS insert into hist file
009333000000       clear xCnt;
009334000000       DoU xCnt = noteCnt;
009335000000           xCnt = xCnt + 1;
009336000000           xxHoreq  = nData(xCnt).nHoctl;
009337000000           xxVinno  = nData(xCnt).nVinno;
009338000000           xxNote   = nData(xCnt).nVnote;
009339000000           xxAucod  = nData(xCnt).nAucod;
009340000000           xxNotDt  = nData(xCnt).nNotDt;
009341000000
009342000000           Exec Sql Select Max(horsq) into :sqKey from Tasctrmh2
009343000000                           Where horeq = :xxHoreq;
009344000000           sqKey = sqKey + 1;
009345000000
009346000000           Exec Sql Insert into Tasctrmh2
009347000000                       (rectyp, horeq,     horsq,   vinnb,
009348000000                        notetx, notedt,    addts)
009349000000                    Values
009350000000                       ('N',    :xxHoreq,  :sqKey,  :xxVinno,
009351000000                        :xxnote,:xxNotDt,  current_timestamp) ;
009352000000
009353000000       enddo;   // endDo for noteCnt
009354000000
009355000000       // end get out
009356000000       *inlr = *on;
009357000000       return;
009358000000
009359000000       // -----------------------------------------------------------
009360000000       //  subSinvdd;
009361000000       // -----------------------------------------------------------
009362000000       begsr subSinvdd;
009363000000
009364000000          clear dTrnDtIso;
009365000000          Exec sql Declare CurD dynamic scroll cursor For
009366000000               Select trndtiso from Sinvdd01
009367000000                Where hoctl = :hHoctl For Update of Actim;
009368000000
009369000000          Exec sql Open CurD;
009370000000          Exec Sql Fetch next from CurD into :dTrnDtIso;
009371000000
009372000000               if sqlcod = 0;      // found sinvdd record
009373000000                    exsr subStreqd;
009374000000                    if okToSend = 'Y';
009375000000                //       Exec sql Update Sinvdd01 Set Actim = :curTs
009376000000                //                 Where current of CurD;
009377000000                    endif;
009378000000               endif;  // if sqlcod <> 0 for CurD
009379000000
009380000000          Exec sql Close CurD;
009381000000
009382000000       endsr;
009383000000       // -----------------------------------------------------------
009384000000       //  subStreqd;
009385000000       // -----------------------------------------------------------
009386000000       begsr subStreqd;
009387000000
009388000000          clear rData;
009389000000          Exec sql Declare CurR dynamic scroll cursor For
009390000000               Select Txcod, Contp, UnitN, Plate,
009391000000                      PltMM, PltYR, PltST, Miles,
009392000000                      CltIn, CltNr, CCNam, PName,
009393000000                      LocIn, LocNr, LName, LAdr1,
009394000000                      LAdr2, CityD, LStat, LZipC,
009395000000                      LPhon, LCntc, TrChg, AcTim
009396000000               From Streqd Where hoctl = :hHoctl
009397000000                      For Update of Actim;
009398000000
009399000000          Exec sql Open CurR;
009400000000          Exec Sql Fetch next from CurR into
009401000000                          :rTxcod, :rContp, :rUnitN, :rPlate,
009402000000                          :rPltMM, :rPltYR, :rPltST, :rMiles,
009403000000                          :rCltIn, :rCltNr, :rCCNam, :rPName,
009404000000                          :rLocIn, :rLocNr, :rLName, :rLAdr1,
009405000000                          :rLAdr2, :rCityD, :rLStat, :rLZipC,
009406000000                          :rLPhon, :rLCntc, :rTrChg, :rAcTim;
009407000000
009408000000          if sqlcod = 0;    // if found in streqd
009409000000
009410000000               clear xnote;
009411000000               Exec sql Select Vnote into :xNote
009412000000                             from Sgnted01 where hoctl = :hHoctl;
009413000000
009414000000               //  must have a note begin code
009415000000               if sqlcod <> 0 and sqlcod <> -811;
009416000000                    eval emailType = '2';
009417000000                    horeqA = %trim(%EDITC(hHoctl : '4'));
009418000000                    exsr sendEmailMsg;
009419000000               else;
009420000000                    // move all fields to DS here
009421000000                    dsCnt = dsCnt + 1;
009422000000                    sData(dsCnt).shoctl = hHoctl;
009423000000                    sData(dsCnt).sAucod = hAucod;
009424000000                    sData(dsCnt).sContp = hContp;
009425000000                    sData(dsCnt).sTxcod = hTxcod;
009426000000                    sData(dsCnt).sCltin = hCltin;
009427000000                    sData(dsCnt).sCltnr = hCltnr;
009428000000                    sData(dsCnt).sAnglo = hAnglo;
009429000000                    sData(dsCnt).sVinno = hVinno;
009430000000                    sData(dsCnt).sVehyr = hVehyr;
009431000000                    sData(dsCnt).sVmake = hVmake;
009432000000                    sData(dsCnt).sModel = hModel;
009433000000                    sData(dsCnt).sColor = hColor;
009434000000                    sData(dsCnt).sDrvfl = hDrvfl;
009435000000                    sData(dsCnt).sCatci = hCatci;
009436000000                    sData(dsCnt).sTrnDtIso = dTrnDtIso;
009437000000                    sData(dsCnt).sUnitn  = RUnitn;
009438000000                    sData(dsCnt).sCCNam  = RCCNam;
009439000000                    sData(dsCnt).sPName  = RPName;
009440000000                    sData(dsCnt).sLocin  = RLocin;
009441000000                    sData(dsCnt).sLName  = RLName;
009442000000                    sData(dsCnt).sLAdr1  = RLAdr1;
009443000000                    sData(dsCnt).sLAdr2  = RLAdr2;
009444000000                    sData(dsCnt).sCityD  = RCityD;
009445000000                    sData(dsCnt).sLStat  = RLStat;
009446000000                    sData(dsCnt).sLZipC  = RLZipC;
009447000000                    sData(dsCnt).sLPhon  = RLPhon;
009448000000                    sData(dsCnt).sLCntc  = RLCntc;
009449000000
009450000000                    eval okToSend = 'Y';               // okToSend = Y *****
009451000000                    curTs = %timestamp();
009452000000               endif;
009453000000               //  must have a note end code
009454000000
009455000000               if okToSend = 'Y';
009456000000                       Exec sql Update Streqd Set Actim = :curTs
009457000000                                Where current of CurR;
009458000000               endif;
009459000000          endif;            // endif found in streqd
009460000000
009461000000          Exec sql Close CurR;
009462000000       endsr;
009463000000       // -----------------------------------------------------------
009464000000       //  sendEmailMsg
009465000000       // -----------------------------------------------------------
010400000000       begsr sendEmailMsg;
010402000000
010403000000          clear emailds;
010404000000          clear msg;
010405000000          clear lmsg;
010406000000          dsc   = 'AASC Send, Socket Replacement';
010407000000          recv1 = 'adkinsgr@us.ibm.com';
010408000000
010409000000          if emailType = '1';
010410000000               msg   = 'AASC Send Cannot SQL Connect';
010414000000               lmsg  = '' +
010415000000                       ':/N:/N' +
010416000000                       'Program Name: AASCBLDHR2 on ' + boxname +
010417000000                       ':/N:/N' +
010418000000                       'Could not connect to ' + remoteBox ;
010419000000          endif;
010420000000
010421000000          if emailType = '2';
010422000000               msg   = 'AASC Send';
010424000000               lmsg  = '' +
010425000000                       ':/N:/N' +
010426000000                       'Program Name: AASCBLDHR2 on ' + boxname +
010427000000                       ':/N:/N' +
010429000000                       'Can not send Consignment # ' + %trim(horeqA) +
010430000000                       ' There are no notes to go with this consignment.';
010431000000          endif;
010432000000
010433000000          Callp GENEMAILC(dsc:msg:lmsg:recv1:recv2:recv3:recv4:recv5:recv6);
010434000000
010435000000
010436000000       endsr;
010437000000
010438000000       // -----------------------------------------------------------
010439000000       //  checkSqlPkg
010440000000       // -----------------------------------------------------------
010441000000       begsr checkSqlPkg;
010442000000
010443000000            clear packageError;
010444000000            exsr  conect;
010445000000
010446000000            Exec Sql Select distinct user into :tstusr from Sinvhm;
010447000000
010448000000            if sqlcod = -818 Or sqlcod = -805;
010449000000                 packageError = 'Y';
010450000000            endif;
010451000000
010452000000       endsr;
010453000000
010454000000       // -----------------------------------------------------------
010455000000       //  createSqlPkg
010456000000       // -----------------------------------------------------------
010457000000       begsr createSqlPkg;
010458000000
010459000000       if    boxName <> 'MARD';
010460000000             if   boxName = 'MARS';
010461000000                   xRmtSystem = 'REMARKET';
010462000000                   xLibrary   = 'MARS';
010463000000             else;
010464000000               if   boxName = 'MARQ';
010465000000                     xRmtSystem = 'MARD';
010466000000                     xLibrary   = 'MARSQ';
010467000000               endif;
010468000000             endif;
010469000000
010470000000             xpgmname = 'AASCBLDHR2';
010471000000             xrmtusr  = 'SQLUSR';
010472000000             xrmtpwd  = 'SQLUSR';
010473000000             xerrflg  = ' ';
010474000000             xerrnbr  = 0;
010475000000
010476000000             Callp BuildPkg(xpgmname:xlibrary:xRmtSystem:xrmtusr
010477000000                            :xrmtpwd:xerrflg:xerrnbr);
010478000000
010479000000       endif; // boxName <> MARD
010480000000
010481000000       endsr;
010482000000
010701000000       // -----------------------------------------------------------
010702000000       //  conect
010703000000       // -----------------------------------------------------------
010704000000       begsr conect;
010705000000
010706000000       if   boxName = 'MARS';
010707000000            Exec Sql Connect to Remarket User :sqlUsr Using :sqlPwd;
010708000000       else;
010709000000            if  boxName = 'MARQ';
010710000000                Exec Sql Connect to Mard User :sqlUsr Using :sqlPwd;
010711000000            endif;
010712000000       endif;
010713000000
010714000000       endsr;
010715000000
010800000000      /end-free
010900000000
012200000000
