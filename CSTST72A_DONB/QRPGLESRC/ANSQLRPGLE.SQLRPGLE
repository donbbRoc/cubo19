000100090827     ?****************************************************************
000200090827     ?*                                                              *
000300090827     ?*   Program       :  MDSPLR                                    *
000400090827     ?*                                                              *
000500090827     ?*   Synopsis      :  List Spool Files                          *
000600090827     ?*   ~~~~~~~~         ~~~~~~~~~~~~~~~~                          *
000700090827     ?*                                                              *
000800090827     ?*   Date written  :  July 2004                                 *
000900090827     ?*                                                              *
001000090827     ?*                                                              *
001100090827     ?*--------------------------------------------------------------*
001200090827     ?*                                                              *
001300090827     ?*   M o d i f i c a t i o n s                                  *
001400090827     ?*   ~~~~~~~~~~~~~~~~~~~~~~~~~                                  *
001500090827     ?*                                                              *
001600090827     ?*   Date modified :                                            *
001700090827     ?*                                                              *
001800090827     ?*   Programmer    :                                            *
001900090827     ?*                                                              *
002000090827     ?****************************************************************
002100090827     ?* Compiler Directives
002200090827     HDebug Option(*SrcStmt : *NoDebugIO)
002300090827     HActGrp(*New)
002400090827     HDftActGrp(*No)
002500090827
002600090827     ?*--------------------------------------------------------------------*
002700090827
002800090827     F***ADNAMESP  IF   E           K Disk
002900090827
003000090827     ?*--------------------------------------------------------------------*
003100090827
003200090827     FMDSPLD    CF   E             Workstn
003300090827     F                                     SFILE(MDSPLAS:RRN)
003400090827     F                                     INFDS(WDSUBF)
003500090827
003600090827     ?*--------------------------------------------------------------------*
003700090827
003800090827     D SpacePtr        S               *
003900090827     ?*
004000090827     ?* Header record for the User Space
004100090827     D Userspace       DS                  BASED(Spaceptr)
004200090827     D  Data                          1    DIM(32767)
004300090827     D  OffsetHdr            117    120I 0
004400090827     D  OffsetDBR            125    128I 0
004500090827     D  NumLstEnt            133    136I 0
004600090827     D  EntrySize            137    140I 0
004700090827     ?*
004800090827     ?* Spool Data List in the User Space
004900090827     D List            DS
005000090827     D  DataSpl                       1    DIM(32767)
005100090827     D  JobName                1     10
005200090827     D  UserNameO             11     20
005300090827     D  JobNumber             21     26
005400090827     D  SplFName              27     36
005500090827     D  SplFNumber            37     40I 0
005600090827     D  SplFStatus            41     44I 0
005700090827     D  OpenDate              45     51
005800090827     D  OpenTime              52     57
005900090827     D  Schedule              58     58
006000090827     D  SysNam                59     68
006100090827     D  UserDataO             69     78
006200090827     D  FormType              79     88
006300090827     D  OutQName              89     98
006400090827     D  OutQLib               99    108
006500090827     D  ASP                  109    112I 0
006600090827     D  Size                 113    116I 0
006700090827     D  SizeMult             117    120I 0
006800090827     D  TotPage              121    124I 0
006900090827     D  CopiesLeft           125    128I 0
007000090827     D  Priority             129    129
007100090827     D  Reserve              130    132
007200090827     ?*
007300090827     ?* Command Key and Sub-File page
007400090827     D WDSUBF          DS
007500090827     D  W@KEY                369    369
007600090827     D  SFLPG#               378    379I 0
007700090827     D  ScrPos               370    371I 0
007800090827     D  WdwPos               382    383I 0
007900090827     ?*
008000090827     ?* Program Status Data Queue
008100090827     D PSDS           SDS
008200090827     D   PGMQ            *PROC
008300090827     D   PGM                 334    343
008400090827     ?*
008500090827     ?* Command Keys
008600090827     D @f1             C                   CONST(X'31')
008700090827     D @f2             C                   CONST(X'32')
008800090827     D @f3             C                   CONST(X'33')
008900090827     D @f4             C                   CONST(X'34')
009000090827     D @f5             C                   CONST(X'35')
009100090827     D @f6             C                   CONST(X'36')
009200090827     D @f7             C                   CONST(X'37')
009300090827     D @f8             C                   CONST(X'38')
009400090827     D @f9             C                   CONST(X'39')
009500090827     D @f10            C                   CONST(X'3A')
009600090827     D @f11            C                   CONST(X'3B')
009700090827     D @f12            C                   CONST(X'3C')
009800090827     D @f13            C                   CONST(X'B1')
009900090827     D @f14            C                   CONST(X'B2')
010000090827     D @f15            C                   CONST(X'B3')
010100090827     D @f16            C                   CONST(X'B4')
010200090827     D @f17            C                   CONST(X'B5')
010300090827     D @f18            C                   CONST(X'B6')
010400090827     D @f19            C                   CONST(X'B7')
010500090827     D @f20            C                   CONST(X'B8')
010600090827     D @f21            C                   CONST(X'B9')
010700090827     D @f22            C                   CONST(X'BA')
010800090827     D @f23            C                   CONST(X'BB')
010900090827     D @f24            C                   CONST(X'BC')
011000090827     ?*
011100090827     D LstSpcName      C                   CONST('SPL001US  QTEMP     ')
011200090827     D KeySize         C                   CONST(99)
011300090827     ?*
011400090827     D Up              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
011500090827     D Low             C                   'abcdefghijklmnopqrstuvwxyz'
011600090827     ?*
011700090827     D SpaceName       S             20
011800090827     D SpaceAtr        S             10
011900090827     D SpaceSiz        S             10I 0 INZ(32767)
012000090827     D SpaceStart      S             10I 0
012100090827     D DataSize        S             10I 0 INZ(512)
012200090827     D SpaceInv        S              1
012300090827     D SpaceAut        S             10    INZ('*ALL')
012400090827     D SpaceDes        S             50    INZ('User Space For SPLF')
012500090827     D FmtName         S              8    INZ('SPLF0300')
012600090827     ?*
012700090827     D Keys            S             10    DIM(KeySize)
012800090827     D Pos             S              2    DIM(KeySize)
012900090827     D Seq             S              1    DIM(KeySize)
013000090827     ?*
013100090827     D WPOutQName      S             20    Inz('*ALL                ')
013200090827     D WPError         S             10I 0
013300090827     ?*
013400090827     D QCmdCmd         S            256
013500090827     D QCmdLength      S             15  5 INZ(256)
013600090827     D RRN             S              5I 0
013700090827     D DateDMY         S               D   DATFMT(*DMY)
013800090827     D TimeHMS         S               T   TIMFMT(*HMS)
013900090827     D ProgramName     S             10
014000090827     D ProgramUser     S             10    Inz(*USER)
014100090827     D PrinterQ        S             10
014200090827     D ErrorFlag       S              1
014300090827     D UDF             S             10
014400090827     D UDFL            S              5I 0
014500090827     D IX              S              5I 0
014600090827     D RRNBottom       S              5I 0
014700090827     D WProcess        S              1
014800090827     D SavedValues     S              1
014900090827     D ConfirmDelete   S              1
015000090827     D PF3             S              1
015100090827     D PF12            S              1
015200090827     D WFilter         S              1
015300090827     D Y               S              5I 0
015400090827     D CheckVal        S              4
015500090827     D WPass           S              1
015600090827     D Blah            S             50
015700090827     ?*
015800090827     ?*--------------------------------------------------------------------*
015900090827     ?*
016000090827     ?* Main Program Loop
016100090827B01  C                   DoU       (*InLR = *On)
016200090827     ?*
016300090827     ?* Initialise SFL
016400090827     C                   ExSR      @Init
016500090827     ?*
016600090827     ?* Display SFL
016700090827     C                   ExSR      @Display
016800090827     ?*
016900090827E01  C                   EndDO
017000090827     ?*
017100090827     ?****************************************************************
017200090827     ?* Display the Subfile                                          *
017300090827     ?****************************************************************
017400090827     ?*
017500090827BSR  C     @DISPLAY      BegSR
017600090827     ?*
017700090827B01  C                   DoU       *InLR = *On
017800090827     ?*
017900090827     ?* If there are no Sub-File records, condition the SFLDSP
018000090827B02  C                   If        RRN = 0
018100090827     C                   Eval      *In50 = *On
018200090827     C                   Eval      WROW = 8
018300090827     C                   Eval      WCOL = 7
018400090827X02  C                   else
018500090827     C                   Eval      *In50 = *Off
018600090827     ?*
018700090827     ?* Stay on the last page
018800090827B03  C                   If        SFLPOS <> 0
018900090827     C                   Eval      RRN = SFLPOS
019000090827X03  C                   else
019100090827     C                   Eval      SFLPOS = 1
019200090827E03  C                   EndIF
019300090827     ?*
019400090827E02  C                   EndIF
019500090827     ?*
019600090827     ?* Write the Clear Panel if there are no records
019700090827     C   50              WRITE     Clear
019800090827     C                   WRITE     MDSPLAT
019900090827     C                   EXFMT     MDSPLAC
020000090827     C                   Eval      WSMSG = ' '
020100090827     C                   Eval      SFLPOS = SFLPG#
020200090827     ?*
020300090827     ?* Determine the current cursor position
020400090827     ?*   if not a window, offset from screen position
020500090827     ?*   otherwise, offset from window position
020600090827B02  C                   If        WdwPos = 0
020700090827     C     ScrPos        Div       256           WROW
020800090827     C                   Mvr                     WCOL
020900090827X02  C                   Else
021000090827     C     WdwPos        Div       256           WROW
021100090827     C                   Mvr                     WCOL
021200090827E02  C                   EndIF
021300090827     ?* _______
021400090827     ?* F3-Exit
021500090827     ?* ~~~~~~~
021600090827B02  C                   If        (W@KEY = @F3)
021700090827     C                   Eval      *INLR = *ON
021800090827L01  C                   Leave
021900090827E02  C                   EndIF
022000090827     ?* __________
022100090827     ?* F5-Refresh
022200090827     ?* ~~~~~~~~~~
022300090827B02  C                   If        (W@KEY = @F5)
022400090827     C/exec sql
022500090827     C+ SELECT nasurn INTO :blah FROM ADNAMESP WHERE nasurn = :blah
022600090827     C/end-exec
022700090827     ?**                 Clear                   #File
022800090827     ?**                 Clear                   #User
022900090827     ?**                 Clear                   #Data
023000090827     ?**                 Clear                   #Date
023100090827     ?**                 Clear                   #OutQ
023200090827     C                   ExSR      @INIT
023300090827I01  C                   Iter
023400090827E02  C                   EndIF
023500090827     ?* ______
023600090827     ?* F7-Top
023700090827     ?* ~~~~~~
023800090827B02  C                   If        (W@KEY = @F7)
023900090827     C                   Eval      SFLPOS = 1
024000090827I01  C                   Iter
024100090827E02  C                   EndIF
024200090827     ?* _________
024300090827     ?* F8-Bottom
024400090827     ?* ~~~~~~~~~
024500090827B02  C                   If        (W@KEY = @F8)
024600090827B03  C                   If        RRN > 0
024700090827     C                   Eval      SFLPOS = RRNBottom
024800090827E03  C                   EndIF
024900090827I01  C                   Iter
025000090827E02  C                   EndIF
025100090827     ?* ________________
025200090827     ?* F10 - Delete All
025300090827     ?* ~~~~~~~~~~~~~~~~
025400090827B02  C                   If        (W@KEY = @F10)
025500090827     ?*
025600090827     C                   Eval      YESNO = 'N'
025700090827     C                   Exfmt     FYESNO
025800090827B03  C                   If        YESNO = 'Y'
025900090827     ?*
026000090827     C                   Eval      QCmdCmd =
026100090827     C                             'DLTSPLF *SELECT'
026200090827     C                   Call      'QCMDEXC'                            99
026300090827     C                   Parm                    QCmdCmd
026400090827     C                   Parm                    QCmdLength
026500090827     ?*
026600090827B04  C                   If        *In99 = *On
026700090827     C                   Eval      wsmsg = 'There is a problem deleting +
026800090827     C                             these spool files.'
026900090827E04  C                   EndIF
027000090827     ?*
027100090827     C                   ExSR      @INIT
027200090827I01  C                   Iter
027300090827     ?*
027400090827E03  C                   EndIF
027500090827E02  C                   EndIF
027600090827     ?* ________________________
027700090827     ?* F22 - Work with Printers
027800090827     ?* ~~~~~~~~~~~~~~~~~~~~~~~~
027900090827B02  C                   If        (W@KEY = @F22)
028000090827     ?*
028100090827     C                   Eval      QCmdCmd =
028200090827     C                             'WRKWTR'
028300090827     C                   Call      'QCMDEXC'                            99
028400090827     C                   Parm                    QCmdCmd
028500090827     C                   Parm                    QCmdLength
028600090827     ?*
028700090827B03  C                   If        *In99 = *On
028800090827     C                   Eval      wsmsg = 'There is a problem displaying +
028900090827     C                             the writers.'
029000090827E03  C                   EndIF
029100090827     ?*
029200090827     C                   Call      'RTVEXITKEY'
029300090827     C                   Parm      '0'           PF3
029400090827     C                   Parm      '0'           PF12
029500090827     ?*
029600090827B03  C                   If        PF3 <> '0'
029700090827     C                   Eval      W@Key = @F3
029800090827     C                   Eval      *INLR = *ON
029900090827L01  C                   Leave
030000090827E03  C                   EndIF
030100090827     ?*
030200090827     C                   Write     MDSPLAC
030300090827     ?*
030400090827E02  C                   EndIF
030500090827     ?*
030600090827     ?* Clear the Subfile Processing Flags
030700090827     C                   Eval      WProcess = ' '
030800090827     C                   Eval      SavedValues = ' '
030900090827     C                   Eval      ConfirmDelete = ' '
031000090827     ?*
031100090827     ?*
031200090827     ?*---------------------------------------------------------------------
031300090827     ?*
031400090827     ?* Process the entries
031500090827B02  C                   DoU       (*In95 = *on)
031600090827     C                   ReadC     MDSPLAS                                95
031700090827B03  C                   If        (*in95 = *off)
031800090827     ?*
031900090827     ?*---------------------------------------------------------------------
032000090827     ?* Send
032100090827B04  C                   If        (ACT = '1')
032200090827     ?*
032300090827B05  C                   If        SavedValues = ' '
032400090827     ?*
032500090827     C                   Clear                   TOUSR
032600090827     C                   Clear                   TODST
032700090827     ?*
032800090827     C                   Exfmt     MDSPLB
032900090827     ?* _________
033000090827     ?* F3 - Exit
033100090827     ?* ~~~~~~~~~
033200090827B06  C                   If        (W@KEY = @F3)
033300090827     ?* Set the MDT
033400090827     C                   Eval      *In41 = *On
033500090827     C                   Update    MDSPLAS
033600090827     C                   Eval      *In41 = *Off
033700090827     ?* Act like there's been no processing before
033800090827     C                   Eval      WProcess = ' '
033900090827     ?* Leave the READC loop
034000090827L02  C                   Leave
034100090827E06  C                   EndIF
034200090827     ?* _____________
034300090827     ?* F10 - Set All
034400090827     ?* ~~~~~~~~~~~~~
034500090827B06  C                   If        (W@KEY = @F10)
034600090827     C                   Eval      SavedValues = 'Y'
034700090827E06  C                   EndIF
034800090827     ?* __________
034900090827     ?* F12-Cancel
035000090827     ?* ~~~~~~~~~~
035100090827B06  C                   If        (W@KEY = @F12)
035200090827     C                   Clear                   Act
035300090827     C                   Update    MDSPLAS
035400090827I02  C                   Iter
035500090827E06  C                   EndIF
035600090827     ?*
035700090827E05  C                   EndIF
035800090827     ?*
035900090827     C                   Eval      QCmdCmd = (%trim('SNDNETSPLF FILE(')) +
036000090827     C                             (%trim(DFIL +
036100090827     C                             ') TOUSRID((' +
036200090827     C                             TOUSR + TODST + ')) ' +
036300090827     C                             'JOB(')) +
036400090827     C                             (%trim(J3)) +
036500090827     C                             (%trim('/' + J2)) +
036600090827     C                             (%trim('/' + J1 + ')') + ' ' +
036700090827     C                             'SPLNBR(' + SPL# + ')')
036800090827     C                   Call      'QCMDEXC'                            99
036900090827     C                   Parm                    QCmdCmd
037000090827     C                   Parm                    QCmdLength
037100090827     ?*
037200090827B05  C                   If        *In99 = *On
037300090827     C                   Eval      wsmsg = 'There is a problem sending +
037400090827     C                             this spool file.'
037500090827     C                   Exsr      @ERRSFL
037600090827I02  C                   Iter
037700090827E05  C                   EndIF
037800090827     ?*
037900090827     C                   Eval      WProcess = 'Y'
038000090827     ?*
038100090827     C                   Clear                   Act
038200090827     C                   Update    MDSPLAS
038300090827I02  C                   Iter
038400090827     ?*
038500090827E04  C                   EndIF
038600090827     ?*
038700090827     ?*---------------------------------------------------------------------
038800090827     ?* Delete
038900090827B04  C                   If        (ACT = '4')
039000090827     ?*
039100090827B05  C                   If        ConfirmDelete <> 'Y'
039200090827     C                   Eval      YESNO = 'Y'
039300090827     C                   Exfmt     FYESNO
039400090827B06  C                   If        YESNO = 'N'
039500090827     ?* Set the MDT
039600090827     C                   Eval      *In41 = *On
039700090827     C                   Update    MDSPLAS
039800090827     C                   Eval      *In41 = *Off
039900090827     ?* Act like there's been no processing before
040000090827     C                   Eval      WProcess = ' '
040100090827     ?* Leave the READC loop
040200090827L02  C                   Leave
040300090827X06  C                   Else
040400090827     C                   Eval      ConfirmDelete = YESNO
040500090827E06  C                   EndIF
040600090827E05  C                   EndIF
040700090827     ?*
040800090827     C                   Eval      QCmdCmd = (%trim('DLTSPLF FILE(')) +
040900090827     C                             (%trim(DFIL + ') JOB(')) +
041000090827     C                             (%trim(J3)) +
041100090827     C                             (%trim('/' + J2)) +
041200090827     C                             (%trim('/' + J1 + ')') + ' ' +
041300090827     C                             'SPLNBR(' + SPL# + ')')
041400090827     C                   Call      'QCMDEXC'                            99
041500090827     C                   Parm                    QCmdCmd
041600090827     C                   Parm                    QCmdLength
041700090827     ?*
041800090827B05  C                   If        *In99 = *On
041900090827     C                   Eval      wsmsg = 'There is a problem deleting +
042000090827     C                             this spool file.'
042100090827     C                   ExSR      @ERRSFL
042200090827I02  C                   Iter
042300090827E05  C                   EndIF
042400090827     ?*
042500090827     C                   Eval      WProcess = 'Y'
042600090827     ?*
042700090827     C                   Clear                   Act
042800090827     C                   Update    MDSPLAS
042900090827I02  C                   Iter
043000090827     ?*
043100090827E04  C                   EndIF
043200090827     ?*
043300090827     ?*---------------------------------------------------------------------
043400090827     ?* Display
043500090827B04  C                   If        (ACT = '5')
043600090827     ?*
043700090827     C                   Eval      QCmdCmd = (%trim('DSPSPLF FILE(')) +
043800090827     C                             (%trim(DFIL + ') JOB(')) +
043900090827     C                             (%trim(J3)) +
044000090827     C                             (%trim('/' + J2)) +
044100090827     C                             (%trim('/' + J1 + ')') + ' ' +
044200090827     C                             'SPLNBR(' + SPL# + ')')
044300090827     C                   Call      'QCMDEXC'                            99
044400090827     C                   Parm                    QCmdCmd
044500090827     C                   Parm                    QCmdLength
044600090827     ?*
044700090827B05  C                   If        *In99 = *On
044800090827     C                   Eval      wsmsg = 'There is a problem displaying +
044900090827     C                             this spool file.'
045000090827     C                   ExSR      @ERRSFL
045100090827I02  C                   Iter
045200090827E05  C                   EndIF
045300090827     ?*
045400090827     C                   Call      'RTVEXITKEY'
045500090827     C                   Parm      '0'           PF3
045600090827     C                   Parm      '0'           PF12
045700090827     ?*
045800090827B05  C                   If        PF3 <> '0'
045900090827     C                   Eval      W@Key = @F3
046000090827     C                   Eval      *INLR = *ON
046100090827L02  C                   Leave
046200090827E05  C                   EndIF
046300090827     ?*
046400090827     C                   Clear                   ACT
046500090827     C                   Update    MDSPLAS
046600090827I02  C                   Iter
046700090827     ?*
046800090827E04  C                   EndIF
046900090827     ?*
047000090827     ?*---------------------------------------------------------------------
047100090827     ?* Print
047200090827B04  C                   If        (ACT = '6')
047300090827     C                   Eval      QCmdCmd = (%trim('CHGSPLFA FILE(')) +
047400090827     C                             (%trim(DFIL + ') JOB(')) +
047500090827     C                             (%trim(J3)) +
047600090827     C                             (%trim('/' + J2)) +
047700090827     C                             (%trim('/' + J1 + ')')) + ' ' +
047800090827     C                             'SPLNBR(' + SPL# + ')' +
047900090827     C                             ' DEV(*OUTQ)' +
048000090827     C                             ' OUTQ(EP2)'
048100090827     C                   Call      'QCMDEXC'                            99
048200090827     C                   Parm                    QCmdCmd
048300090827     C                   Parm                    QCmdLength
048400090827     ?*
048500090827B05  C                   If        *In99 = *On
048600090827     C                   Eval      wsmsg = 'There is a problem printing +
048700090827     C                             this spool file.'
048800090827     C                   ExSR      @ERRSFL
048900090827I02  C                   Iter
049000090827E05  C                   EndIF
049100090827     ?*
049200090827     C                   Clear                   ACT
049300090827     C                   Update    MDSPLAS
049400090827I02  C                   Iter
049500090827     ?*
049600090827E04  C                   EndIF
049700090827     ?*
049800090827     ?*---------------------------------------------------------------------
049900090827     ?* Display Attributes
050000090827B04  C                   If        (ACT = '8')
050100090827     ?*
050200090827     C                   Eval      QCmdCmd = (%trim('WRKSPLFA FILE(')) +
050300090827     C                             (%trim(DFIL + ') JOB(')) +
050400090827     C                             (%trim(J3)) +
050500090827     C                             (%trim('/' + J2)) +
050600090827     C                             (%trim('/' + J1 + ')')) + ' ' +
050700090827     C                             'SPLNBR(' + SPL# + ')'
050800090827     C                   Call      'QCMDEXC'                            99
050900090827     C                   Parm                    QCmdCmd
051000090827     C                   Parm                    QCmdLength
051100090827     ?*
051200090827B05  C                   If        *In99 = *On
051300090827     C                   Eval      wsmsg = 'There is a problem displaying +
051400090827     C                             the attributes.'
051500090827     C                   ExSR      @ERRSFL
051600090827I02  C                   Iter
051700090827E05  C                   EndIF
051800090827     ?*
051900090827     C                   Call      'RTVEXITKEY'
052000090827     C                   Parm      '0'           PF3
052100090827     C                   Parm      '0'           PF12
052200090827     ?*
052300090827B05  C                   If        PF3 <> '0'
052400090827     C                   Eval      W@Key = @F3
052500090827     C                   Eval      *INLR = *ON
052600090827L02  C                   Leave
052700090827E05  C                   EndIF
052800090827     ?*
052900090827     C                   Clear                   ACT
053000090827     C                   Update    MDSPLAS
053100090827I02  C                   Iter
053200090827     ?*
053300090827E04  C                   EndIF
053400090827     ?*
053500090827     ?*---------------------------------------------------------------------
053600090827     ?* Copy to HTML
053700090827B04  C                   If        (ACT = 'H')
053800090827     C                   Eval      QCmdCmd = (%trim('CVTSPLSTMF FROMFILE(')) +
053900090827     C                             (%trim(DFIL)) + ') JOB(' +
054000090827     C                             (%trim(J3)) +
054100090827     C                             (%trim('/' + J2)) +
054200090827     C                             (%trim('/' + J1)) + ') ' +
054300090827     C                             'SPLNBR(' + SPL# + ') ' +
054400090827     C                             'TOSTMF(' + %trim(%trim(DFIL) + SPL#) +
054500090827     C                             '.html) ' +
054600090827     C                             'TODIR(' + ProgramUser + ') ' +
054700090827     C                             'TOFMT(*HTML) ' +
054800090827     C                             'STMFOPT(*REPLACE)'
054900090827     C                   Call      'QCMDEXC'                            99
055000090827     C                   Parm                    QCmdCmd
055100090827     C                   Parm                    QCmdLength
055200090827     ?*
055300090827B05  C                   If        *In99 = *On
055400090827     C                   Eval      wsmsg = 'There is a problem converting +
055500090827     C                             this spool file.'
055600090827     C                   ExSR      @ERRSFL
055700090827I02  C                   Iter
055800090827E05  C                   EndIF
055900090827     ?*
056000090827     C                   Clear                   ACT
056100090827     C                   Update    MDSPLAS
056200090827I02  C                   Iter
056300090827     ?*
056400090827E04  C                   EndIF
056500090827     ?*
056600090827     ?*---------------------------------------------------------------------
056700090827     ?* Copy to PDF
056800090827B04  C                   If        (ACT = 'P')
056900090827     C                   Eval      QCmdCmd = (%trim('CVTSPLSTMF FROMFILE(')) +
057000090827     C                             (%trim(DFIL)) + ') JOB(' +
057100090827     C                             (%trim(J3)) +
057200090827     C                             (%trim('/' + J2)) +
057300090827     C                             (%trim('/' + J1)) + ') ' +
057400090827     C                             'SPLNBR(' + SPL# + ') ' +
057500090827     C                             'TOSTMF(' + %trim(%trim(DFIL) + SPL#) +
057600090827     C                             '.pdf) ' +
057700090827     C                             'TODIR(' + ProgramUser + ') ' +
057800090827     C                             'TOFMT(*PDF) ' +
057900090827     C                             'STMFOPT(*REPLACE)'
058000090827     C                   Call      'QCMDEXC'                            99
058100090827     C                   Parm                    QCmdCmd
058200090827     C                   Parm                    QCmdLength
058300090827     ?*
058400090827B05  C                   If        *In99 = *On
058500090827     C                   Eval      wsmsg = 'There is a problem converting +
058600090827     C                             this spool file.'
058700090827     C                   Exsr      @ERRSFL
058800090827I02  C                   Iter
058900090827E05  C                   EndIF
059000090827     ?*
059100090827     C                   Clear                   ACT
059200090827     C                   Update    MDSPLAS
059300090827I02  C                   Iter
059400090827     ?*
059500090827E04  C                   EndIF
059600090827     ?*
059700090827E03  C                   EndIF
059800090827     ?* End of Subfile READC Loop
059900090827E02  C                   EndDO
060000090827     ?*
060100090827     ?* If there's been a change, or any processing has occurred
060200090827B02  C                   If        *In70 = *On or
060300090827     C                             WProcess = 'Y'
060400090827     C                   ExSR      @INIT
060500090827I01  C                   Iter
060600090827E02  C                   EndIF
060700090827     ?*
060800090827     ?* End of Display until LR Loop
060900090827E01  C                   EndDO
061000090827     ?*
061100090827ESR  C                   EndSR
061200090827     ?*
061300090827     ?****************************************************************
061400090827     ?* Initialize The Subfiles                                      *
061500090827     ?****************************************************************
061600090827     ?*
061700090827BSR  C     @INIT         BegSR
061800090827     ?*
061900090827     C                   Clear                   RRN
062000090827     C                   Clear                   SFLPOS
062100090827     C                   Clear                   ACT
062200090827     ?*
062300090827     ?* Initialise Subfile
062400090827     C                   Eval      *In27 = *On
062500090827     C                   WRITE     MDSPLAC
062600090827     C                   Eval      *In27 = *Off
062700090827     ?*
062800090827     ?* Clear Subfile
062900090827     C                   Eval      *in26 = *On
063000090827     C                   WRITE     MDSPLAC
063100090827     C                   Eval      *In26 = *Off
063200090827     ?*
063300090827     ?* Initialise the Cursor Position
063400090827     C                   Eval      WROW = 9
063500090827     C                   Eval      WCOL = 2
063600090827     ?*
063700090827     ?* Check Filter Values
063800090827B01  C                   If        #STS = *Blank
063900090827     C                   Eval      %subst(CheckVal:1:1) = '0'
064000090827X01  C                   Else
064100090827     C                   Eval      %subst(CheckVal:1:1) = '1'
064200090827E01  C                   EndIF
064300090827     ?*
064400090827B01  C                   If        #File = *Blank
064500090827     C                   Eval      %subst(CheckVal:2:1) = '0'
064600090827X01  C                   Else
064700090827     C                   Eval      %subst(CheckVal:2:1) = '1'
064800090827E01  C                   EndIF
064900090827     ?*
065000090827B01  C                   If        #Data = *Blank
065100090827     C                   Eval      %subst(CheckVal:3:1) = '0'
065200090827X01  C                   Else
065300090827     C                   Eval      %subst(CheckVal:3:1) = '1'
065400090827E01  C                   EndIF
065500090827     ?*
065600090827B01  C                   If        #Date = *Zero
065700090827     C                   Eval      %subst(CheckVal:4:1) = '0'
065800090827X01  C                   Else
065900090827     C                   Eval      %subst(CheckVal:4:1) = '1'
066000090827E01  C                   EndIF
066100090827     ?*
066200090827     ?* User Space Magic/Subfile load
066300090827     C                   ExSR      @CRTUSAPI
066400090827     C                   ExSR      @LFLDAPI
066500090827     C  N99              ExSR      @PTRUSAPI
066600090827     C  N99              ExSR      @LOAD1
066700090827     C                   ExSR      @DLTUSAPI
066800090827     ?*
066900090827ESR  C                   EndSR
067000090827     ?*
067100090827     ?****************************************************************
067200090827     ?* Load the Subfile                                             *
067300090827     ?****************************************************************
067400090827     ?*
067500090827BSR  C     @LOAD1        BegSR
067600090827     ?*
067700090827     C                   Eval      SpaceStart = ( OffSetDBR + 1 )
067800090827     ?*
067900090827B01  C                   Do        NumLstEnt
068000090827     ?*
068100090827B02  C                   If        RRN = 9999
068200090827L01  C                   Leave
068300090827E02  C                   EndIF
068400090827     ?*
068500090827     C                   ExSR      @RTVUSAPI
068600090827     ?*
068700090827B02  C                   If        CheckVal = '0000'
068800090827     C                   Eval      WFilter = 'Y'
068900090827X02  C                   Else
069000090827     C                   ExSR      @Filter
069100090827E02  C                   EndIF
069200090827B02  C                   If        WFilter = 'Y'
069300090827     ?*
069400090827     C                   ExSR      EDIT
069500090827     ?*
069600090827     C                   Eval      RRN += 1
069700090827     ?*
069800090827B03  ?**                 If        RRN = 1
069900090827     ?**                 Eval      *In39 = *On
070000090827X03  ?**                 Else
070100090827     ?**                 Eval      *In39 = *Off
070200090827E03  ?**                 EndIF
070300090827     ?*
070400090827     C                   WRITE     MDSPLAS
070500090827     ?*
070600090827     C                   Eval      RRNBottom = RRN
070700090827     ?*
070800090827E02  C                   EndIF
070900090827     C                   Eval      SpaceStart += EntrySize
071000090827E01  C                   EndDO
071100090827     ?*
071200090827ESR  C                   EndSR
071300090827     ?*
071400090827     ?**************************************************************
071500090827     ?* Call List Fields API                                       *
071600090827     ?**************************************************************
071700090827     ?*
071800090827BSR  C     @LFLDAPI      BegSR
071900090827     ?*
072000090827B01  C                   If        #User = *Blank
072100090827     C                   Eval      #User = '*CURRENT'
072200090827E01  C                   EndIF
072300090827     C                   Eval      #User = %TrimL(#User)
072400090827     C                   Eval      UserName = #User
072500090827     ?*
072600090827B01  C                   If        #OutQ = *Blank or #OutQ = '*ALL'
072700090827     C                   Eval      #OutQ = '*ALL'
072800090827     C                   Eval      WPOutQName = #OutQ
072900090827X01  C                   Else
073000090827     C                   Eval      #OutQ = %TrimL(#OutQ)
073100090827     C                   Eval      WPOutQName = #OutQ
073200090827     C                   Eval      %Subst(WPOutQName:11:10) = '*LIBL'
073300090827E01  C                   EndIF
073400090827     ?*
073500090827     C                   CALL      'QUSLSPL'                            99
073600090827     C                   PARM                    SpaceName
073700090827     C                   PARM      'SPLF0300'    FmtName
073800090827     C                   PARM                    UserName         10
073900090827     C                   PARM                    WPOutQName
074000090827     C                   PARM      '*ALL'        FormType
074100090827     C                   PARM      '*ALL'        UserData         10
074200090827     ?*
074300090827B01  C                   If        (*in99 = *on)
074400090827     C                   eval      wsmsg = 'There has been a problem.'
074500090827E01  C                   EndIF
074600090827     ?*
074700090827ESR  C                   EndSR
074800090827     ?*
074900090827     ?**************************************************************
075000090827     ?* Create User Space                                          *
075100090827     ?**************************************************************
075200090827     ?*
075300090827BSR  C     @CRTUSAPI     BegSR
075400090827     ?*
075500090827     C                   CALL      'QUSCRTUS'                           99
075600090827     C                   PARM                    SpaceName
075700090827     C                   PARM                    SpaceAtr
075800090827     C                   PARM                    SpaceSiz
075900090827     C                   PARM                    SpaceInv
076000090827     C                   PARM                    SpaceAut
076100090827     C                   PARM                    SpaceDes
076200090827     ?*
076300090827ESR  C                   EndSR
076400090827     ?*
076500090827     ?**************************************************************
076600090827     ?* Retrieve Pointer To User Space                             *
076700090827     ?**************************************************************
076800090827     ?*
076900090827BSR  C     @PTRUSAPI     BegSR
077000090827     ?*
077100090827     C                   CALL      'QUSPTRUS'
077200090827     C                   PARM                    SpaceName
077300090827     C                   PARM                    SpacePtr
077400090827     ?*
077500090827ESR  C                   EndSR
077600090827     ?*
077700090827     ?**************************************************************
077800090827     ?* Retrieve User Space Data                                   *
077900090827     ?**************************************************************
078000090827     ?*
078100090827BSR  C     @RTVUSAPI     BegSR
078200090827     ?*
078300090827     C                   CALL      'QUSRTVUS'
078400090827     C                   PARM                    SpaceName
078500090827     C                   PARM                    SpaceStart
078600090827     C                   PARM                    EntrySize
078700090827     C                   PARM                    List
078800090827     ?*
078900090827ESR  C                   EndSR
079000090827     ?*
079100090827     ?**************************************************************
079200090827     ?* Delete User Space                                          *
079300090827     ?**************************************************************
079400090827     ?*
079500090827BSR  C     @DLTUSAPI     BegSR
079600090827     ?*
079700090827     C                   CALL      'QUSDLTUS'
079800090827     C                   PARM                    SpaceName
079900090827     C                   PARM                    WPError
080000090827     ?*
080100090827ESR  C                   EndSR
080200090827     ?***************************************************************
080300090827     ?* INITIALIZATION SUBROUTINE                                   *
080400090827     ?***************************************************************
080500090827BSR  C     *INZSR        BegSR
080600090827     ?*
080700090827     C                   Eval      SpaceName = LstSpcName
080800090827     ?*
080900090827ESR  C                   EndSR
081000090827     ?*
081100090827     ?***************************************************************
081200090827     ?* Edit SUBROUTINE                                             *
081300090827     ?***************************************************************
081400090827BSR  C     EDIT          BegSR
081500090827     ?*
081600090827     C                   Eval      DFIL = SplFName
081700090827     C                   Eval      DUSR = UserNameO
081800090827     C                   Eval      DDTA = UserDataO
081900090827B01  C                   If        TotPage > 9999
082000090827     C                   Eval      DPAG = 9999
082100090827X01  C                   Else
082200090827     C                   Eval      DPAG = TotPage
082300090827E01  C                   EndIF
082400090827     C                   Eval      DCPY = CopiesLeft
082500090827     ?*
082600090827     C                   ExSR      Status
082700090827     ?*
082800090827     C                   Movel     OpenDate      Date7             7 0
082900090827     C     *CYMD         Test(DE)                Date7
083000090827B01  C                   If        %Error
083100090827     C                   Eval      DDAT = *Blank
083200090827X01  C                   Else
083300090827     C     *CYMD         Movel     Date7         DateDMY
083400090827     C     *DMY          Movel     DateDMY       DDAT
083500090827E01  C                   EndIF
083600090827     C                   Movel     OpenTime      Time6             6 0
083700090827     C     *HMS          Test(TE)                Time6
083800090827B01  C                   If        %Error
083900090827     C                   Eval      DTIM = *Blank
084000090827X01  C                   Else
084100090827     C     *HMS          Movel     Time6         TimeHMS
084200090827     C     *HMS          Movel     TimeHMS       DTIM
084300090827E01  C                   EndIF
084400090827     ?*
084500090827     C                   Eval      J1 = JobName
084600090827     C                   Eval      J2 = UserNameO
084700090827     C                   Eval      J3 = JobNumber
084800090827     C                   Move      SplFNumber    SPL#
084900090827     C                   Eval      QNAM = OutQName
085000090827     ?*
085100090827ESR  C                   EndSR
085200090827     ?*
085300090827     ?***************************************************************
085400090827     ?* Filter Subroutine                                           *
085500090827     ?***************************************************************
085600090827BSR  C     @FILTER       BegSR
085700090827     ?*
085800090827     C                   Clear                   WFilter
085900090827     ?*
086000090827B01  C                   Select
086100090827     ?*
086200090827X01  C                   When      CheckVal = '0001'
086300090827     ?*
086400090827     C                   Eval      WPass = 'Y'
086500090827     C                   ExSR      @Date
086600090827B02  C                   If        WPass = 'Y'
086700090827     C                   Eval      WFilter = 'Y'
086800090827E02  C                   EndIF
086900090827     ?*
087000090827X01  C                   When      CheckVal = '0010'
087100090827     ?*
087200090827     C                   Eval      WPass = 'Y'
087300090827     C                   ExSR      @Data
087400090827B02  C                   If        WPass = 'Y'
087500090827     C                   Eval      WFilter = 'Y'
087600090827E02  C                   EndIF
087700090827     ?*
087800090827X01  C                   When      CheckVal = '0011'
087900090827     ?*
088000090827     C                   Eval      WPass = 'Y'
088100090827     C                   ExSR      @Data
088200090827     C                   ExSR      @Date
088300090827B02  C                   If        WPass = 'Y'
088400090827     C                   Eval      WFilter = 'Y'
088500090827E02  C                   EndIF
088600090827     ?*
088700090827X01  C                   When      CheckVal = '0100'
088800090827     ?*
088900090827     C                   Eval      WPass = 'Y'
089000090827     C                   ExSR      @File
089100090827B02  C                   If        WPass = 'Y'
089200090827     C                   Eval      WFilter = 'Y'
089300090827E02  C                   EndIF
089400090827     ?*
089500090827X01  C                   When      CheckVal = '0101'
089600090827     ?*
089700090827     C                   Eval      WPass = 'Y'
089800090827     C                   ExSR      @File
089900090827     C                   ExSR      @Date
090000090827B02  C                   If        WPass = 'Y'
090100090827     C                   Eval      WFilter = 'Y'
090200090827E02  C                   EndIF
090300090827     ?*
090400090827X01  C                   When      CheckVal = '0110'
090500090827     ?*
090600090827     C                   Eval      WPass = 'Y'
090700090827     C                   ExSR      @File
090800090827     C                   ExSR      @Data
090900090827B02  C                   If        WPass = 'Y'
091000090827     C                   Eval      WFilter = 'Y'
091100090827E02  C                   EndIF
091200090827     ?*
091300090827X01  C                   When      CheckVal = '0111'
091400090827     ?*
091500090827     C                   Eval      WPass = 'Y'
091600090827     C                   ExSR      @File
091700090827     C                   ExSR      @Data
091800090827     C                   ExSR      @Date
091900090827B02  C                   If        WPass = 'Y'
092000090827     C                   Eval      WFilter = 'Y'
092100090827E02  C                   EndIF
092200090827     ?*
092300090827X01  C                   When      CheckVal = '1000'
092400090827     ?*
092500090827     C                   Eval      WPass = 'Y'
092600090827     C                   ExSR      @Sts
092700090827B02  C                   If        WPass = 'Y'
092800090827     C                   Eval      WFilter = 'Y'
092900090827E02  C                   EndIF
093000090827     ?*
093100090827X01  C                   When      CheckVal = '1001'
093200090827     ?*
093300090827     C                   Eval      WPass = 'Y'
093400090827     C                   ExSR      @Sts
093500090827     C                   ExSR      @Date
093600090827B02  C                   If        WPass = 'Y'
093700090827     C                   Eval      WFilter = 'Y'
093800090827E02  C                   EndIF
093900090827     ?*
094000090827X01  C                   When      CheckVal = '1010'
094100090827     ?*
094200090827     C                   Eval      WPass = 'Y'
094300090827     C                   ExSR      @Sts
094400090827     C                   ExSR      @Data
094500090827B02  C                   If        WPass = 'Y'
094600090827     C                   Eval      WFilter = 'Y'
094700090827E02  C                   EndIF
094800090827     ?*
094900090827X01  C                   When      CheckVal = '1011'
095000090827     ?*
095100090827     C                   Eval      WPass = 'Y'
095200090827     C                   ExSR      @Sts
095300090827     C                   ExSR      @Data
095400090827     C                   ExSR      @Date
095500090827B02  C                   If        WPass = 'Y'
095600090827     C                   Eval      WFilter = 'Y'
095700090827E02  C                   EndIF
095800090827     ?*
095900090827X01  C                   When      CheckVal = '1100'
096000090827     ?*
096100090827     C                   Eval      WPass = 'Y'
096200090827     C                   ExSR      @Sts
096300090827     C                   ExSR      @File
096400090827B02  C                   If        WPass = 'Y'
096500090827     C                   Eval      WFilter = 'Y'
096600090827E02  C                   EndIF
096700090827     ?*
096800090827X01  C                   When      CheckVal = '1101'
096900090827     ?*
097000090827     C                   Eval      WPass = 'Y'
097100090827     C                   ExSR      @Sts
097200090827     C                   ExSR      @File
097300090827     C                   ExSR      @Date
097400090827B02  C                   If        WPass = 'Y'
097500090827     C                   Eval      WFilter = 'Y'
097600090827E02  C                   EndIF
097700090827     ?*
097800090827X01  C                   When      CheckVal = '1110'
097900090827     ?*
098000090827     C                   Eval      WPass = 'Y'
098100090827     C                   ExSR      @Sts
098200090827     C                   ExSR      @File
098300090827     C                   ExSR      @Data
098400090827B02  C                   If        WPass = 'Y'
098500090827     C                   Eval      WFilter = 'Y'
098600090827E02  C                   EndIF
098700090827     ?*
098800090827X01  C                   When      CheckVal = '1111'
098900090827     ?*
099000090827     C                   Eval      WPass = 'Y'
099100090827     C                   ExSR      @Sts
099200090827     C                   ExSR      @File
099300090827     C                   ExSR      @Data
099400090827     C                   ExSR      @Date
099500090827B02  C                   If        WPass = 'Y'
099600090827     C                   Eval      WFilter = 'Y'
099700090827E02  C                   EndIF
099800090827     ?*
099900090827E01  C                   EndSL
100000090827     ?*
100100090827ESR  C                   EndSR
100200090827     ?*
100300090827     ?***************************************************************
100400090827     ?* Sub-File Error Subroutine                                   *
100500090827     ?***************************************************************
100600090827BSR  C     @ERRSFL       BegSR
100700090827     ?*
100800090827     C                   Eval      *In40 = *On
100900090827     C                   Update    MDSPLAS
101000090827     C                   Eval      *In40 = *Off
101100090827     ?*
101200090827ESR  C                   EndSR
101300090827     ?*
101400090827     ?***************************************************************
101500090827     ?* @File                                                       *
101600090827     ?***************************************************************
101700090827BSR  C     @File         BegSR
101800090827     ?*
101900090827B01  C                   If        WPass = 'Y'
102000090827     ?*
102100090827     C                   Clear                   WPass
102200090827     ?*
102300090827     C                   Clear                   *IN60
102400090827     C                   Clear                   Y
102500090827     C                   Eval      #File = %TrimL(#File)
102600090827     C     ' '           CHECKR    #File         Y
102700090827     C     #File:Y       SCAN      SplFName      SR                2 0    60
102800090827B02  C                   If        *In60
102900090827     C                   Eval      WPass = 'Y'
103000090827E02  C                   EndIF
103100090827     ?*
103200090827E01  C                   EndIF
103300090827     ?*
103400090827ESR  C                   EndSR
103500090827     ?*
103600090827     ?***************************************************************
103700090827     ?* @Data                                                       *
103800090827     ?***************************************************************
103900090827BSR  C     @Data         BegSR
104000090827     ?*
104100090827B01  C                   If        WPass = 'Y'
104200090827     ?*
104300090827     C                   Clear                   WPass
104400090827     ?*
104500090827     C                   Clear                   *IN60
104600090827     C                   Clear                   Y
104700090827     C                   Eval      #Data = %TrimL(#Data)
104800090827     C     ' '           CHECKR    #Data         Y
104900090827     C     #Data:Y       SCAN      UserDataO     SR                2 0    60
105000090827B02  C                   If        *In60
105100090827     C                   Eval      WPass = 'Y'
105200090827E02  C                   EndIF
105300090827     ?*
105400090827E01  C                   EndIF
105500090827     ?*
105600090827ESR  C                   EndSR
105700090827     ?*
105800090827     ?***************************************************************
105900090827     ?* @Date                                                       *
106000090827     ?***************************************************************
106100090827BSR  C     @Date         BegSR
106200090827     ?*
106300090827B01  C                   If        WPass = 'Y'
106400090827     ?*
106500090827     C                   Clear                   WPass
106600090827     ?*
106700090827     C                   Movel     OpenDate      Date7             7 0
106800090827     C     *CYMD         Test(DE)                Date7
106900090827B02  C                   If        not %Error
107000090827     C     *CYMD         Movel     Date7         DateDMY
107100090827     C     *DMY          Movel     DateDMY       DateTest          6 0
107200090827B03  C                   If        DateTest = #Date
107300090827     C                   Eval      WPass = 'Y'
107400090827E03  C                   EndIF
107500090827E02  C                   EndIF
107600090827     ?*
107700090827E01  C                   EndIF
107800090827     ?*
107900090827ESR  C                   EndSR
108000090827     ?*
108100090827     ?***************************************************************
108200090827     ?* @Sts                                                        *
108300090827     ?***************************************************************
108400090827BSR  C     @Sts          BegSR
108500090827     ?*
108600090827B01  C                   If        WPass = 'Y'
108700090827     ?*
108800090827     C                   Clear                   WPass
108900090827     ?*
109000090827     C                   ExSR      Status
109100090827     ?*
109200090827     C                   Clear                   *IN60
109300090827     C                   Clear                   Y
109400090827     C                   Eval      #Sts = %TrimL(#Sts)
109500090827     C     ' '           CHECKR    #Sts          Y
109600090827     C     #Sts:Y        SCAN      DSTS          SR                2 0    60
109700090827B02  C                   If        *In60
109800090827     C                   Eval      WPass = 'Y'
109900090827E02  C                   EndIF
110000090827     ?*
110100090827E01  C                   EndIF
110200090827     ?*
110300090827ESR  C                   EndSR
110400090827     ?*
110500090827     ?***************************************************************
110600090827     ?* Status                                                      *
110700090827     ?***************************************************************
110800090827BSR  C     Status        BegSR
110900090827     ?*
111000090827B01  C                   Select
111100090827X01  C                   When      SplFStatus = 1
111200090827     C                   Eval      DSTS = 'RDY'
111300090827X01  C                   When      SplFStatus = 2
111400090827     C                   Eval      DSTS = 'OPN'
111500090827X01  C                   When      SplFStatus = 3
111600090827     C                   Eval      DSTS = 'CLO'
111700090827X01  C                   When      SplFStatus = 4
111800090827     C                   Eval      DSTS = 'SAV'
111900090827X01  C                   When      SplFStatus = 5
112000090827     C                   Eval      DSTS = 'WTR'
112100090827X01  C                   When      SplFStatus = 6
112200090827     C                   Eval      DSTS = 'HLD'
112300090827X01  C                   When      SplFStatus = 7
112400090827     C                   Eval      DSTS = 'MSGW'
112500090827X01  C                   When      SplFStatus = 8
112600090827     C                   Eval      DSTS = 'PND'
112700090827X01  C                   When      SplFStatus = 9
112800090827     C                   Eval      DSTS = 'PRT'
112900090827X01  C                   When      SplFStatus = 10
113000090827     C                   Eval      DSTS = 'FIN'
113100090827X01  C                   When      SplFStatus = 11
113200090827     C                   Eval      DSTS = 'SND'
113300090827X01  C                   When      SplFStatus = 12
113400090827     C                   Eval      DSTS = 'DFR'
113500090827E01  C                   EndSL
113600090827     ?*
113700090827ESR  C                   EndSR
113800090827     ?*
