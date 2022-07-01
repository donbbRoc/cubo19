000100000000      *----------------------------------------------------------------
000200000000      * IFNUMB4R - RPG4 Source Structure Numbering - Update source code
000300000000      *
000400000000      * By   Matthew Downes,  09/02/04  Version 1.0
000500000000      *----------------------------------------------------------------
000600000000      * AMDENDMENTS
000700000000      * By   Matthew Downes,  24/08/04  Version 1.1
000701000000      *      Didn't allow for the For EndFor loop, so have
000900000000      *      adjusted the program accordingly.
001000000000      *
001100000000      *----------------------------------------------------------------
001200000000      * Program Summary:
001300000000      *
001400000000      * This program is used to put DO & IF numbers to the right of the
001500000000      * source code similar to the count put to left of the source
001600000000      * code put by the compiler.
001700000000      * A *PSSR subroutine will execute if the source has too many ENDS
001800000000      *
001900000000      * Comment lines are changed to look like those in this pgm.
002000000000      * END statements are updated to match type of structure.
002100000000      * *OFF and *ON are used for indicators in place of 0 or 1.
002200000000      * SETON for single indicators are converted to MOVE *ON
002300000000      * Z-ADD0, MOVE *BLANKS, SETOF, etc are converted to CLEAR if fld
002400000000      * is not being defined at this statement.
002500000000      *----------------------------------------------------------------
002600000000      *
002700000000     HDebug Option(*SrcStmt : *NoDebugIO)
002800000000      *
002900000000      *----------------------------------------------------------------
003000000000      *
003100000000     FJDELESRC  UF   F  112        Disk
003200000000      *
003300000000      *----------------------------------------------------------------
003400000000      *
003500000000     D hex22           C                   const(x'22')
003600000000     D hex28           C                   const(x'28')
003700000000     D hex30           C                   const(x'30')
003800000000     D Up              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
003900000000     D Lo              C                   'abcdefghijklmnopqrstuvwxyz'
004000000000      *
004100000000     D ado             S              2  0 Dim(100)
004200000000     D op              S              2    Dim(100)
004300000000      *
004400000000     D $d              S              3I 0
004500000000     D $ind            S              2
004600000000     D $l              S              2  0
004700000000     D $save           S              2  0
004800000000     D code            S              1
004900000000     D fact2           S             14
005000000000     D fact3           S             14
005100000000     D returnx         S              6
005200000000      *
005300000000     D                SDS
005400000000     D  Err              *Status
005500000000      *
005600000000     D FData           DS
005700000000     D  $seqno                 1      7
005800000000     D  $sryuk                19     20
005900000000     D  doifwh                38     39
006000000000     D  casend                38     40
006100000000     D  else                  38     41
006200000000     D  opcode                38     47
006300000000     D  $2fact                48     52
006400000000     D  ind1                  24     26
006500000000     D  stat                  48     50
006600000000     D  ind2                  62     64
006700000000     D  $3fact                62     75
006800000000     D  Data                  38     75
006900000000     D  $leng                 76     80
007000000000     D  $hi                   83     84
007100000000     D  $lo                   85     86
007200000000     D  $eq                   87     88
007300000000      *
007400000000      *
007500000000     IJDELESRC  NS  LR   13 C*   14 C*   15 C
007600000000      *                              STOP 1ST ARRAY ENCOUNTERED.
007700000000     I          NS  01   18 CC   19NC*
007800000000     I                                  1   88  FData
007900000000      *
008000000000     I          NS  04   18 Cc   19NC*
008100000000     I                                  1   88  FData
008200000000      *
008300000000     I          NS  99   18 cd   19nc*
008400000000      *
008500000000     I          NS  02   19 C*
008600000000      *
008700000000     I          NS  03
008800000000      *
008900000000      *----------------------------------------------------------------
009000000000      * Perform primer read.  Set indicators for input parm values.
009100000000      *----------------------------------------------------------------
009200000000     C     *Entry        Plist
009300000000     C                   Parm                    $stncm            4
009400000000     C                   Parm                    $endlb            4
009500000000     C                   Parm                    $st2mv            4
009600000000     C     *In50         Parm                    $highl            1
009700000000      *
009800000000B01  C                   If        $endlb = '*YES'
009900000000     C                   Eval      *in11 = *on
010000000000E01  C                   EndIf
010100000000      *
010200000000     C                   Read      JDELESRC                               LR
010300000000B01  C                   DoW       not *InLR
010400000000      *
010500000000     C                   Clear                   *In20
010600000000      *****              Clear                   *In30
010700000000      *****              Clear                   *In40
010800000000     C                   Clear                   *In60
010900000000      *
011000000000B02  C                   If        *In04
011100000000     C                   Eval      *In60 = *On
011200000000     C                   Eval      *In01 = *On
011300000000     C                   Eval      *In04 = *Off
011400000000E02  C                   EndIf
011500000000      *
011600000000B02  C                   Select
011700000000X02  C                   When      *in03
011800000000     C                   Except    $clear
011900000000      *
012000000000X02  C                   When      *in01
012100000000      *
012200000000     C     Lo:Up         XLate     Data          Data
012300000000      *
012400000000      *****              Eval      *in40 = *on
012500000000B03   *****              If        $sryuk = 'SR'
012600000000      *****              Eval      *in30 = *on
012700000000E03   *****              EndIF
012800000000      *
012900000000      *----------------------------------------------------------------
013000000000      * Process  the IF  & SELEC CALC codes.  See subroutine.
013100000000      *----------------------------------------------------------------
013200000000B03  C                   Select
013300000000X03  C                   When      doifwh = 'IF'  or
013400000000     C                             opcode = 'SELECT' or
013500000000     C                             opcode = 'FOR'
013600000000     C                   ExSR      $insub
013700000000     C                   ExSR      $load
013800000000      *
013900000000      *----------------------------------------------------------------
014000000000      * Save the most recent 'DO' number for use as the indent count
014100000000      * on ITER and LEAVE operations. The number is saved into an array
014200000000      * whose element position is how many DOs and the value in the
014300000000      * element represents the number of that DO.
014400000000      *----------------------------------------------------------------
014500000000X03  C                   When      doifwh = 'DO'
014600000000     C                   ExSR      $insub
014700000000     C                   ExSR      $load
014800000000     C                   Add       1             $d
014900000000     C                   Eval      ado($d) = $l
015000000000      *
015100000000      *----------------------------------------------------------------
015200000000      * Process the CAS opcode.  The trick is there could be several
015300000000      * CAS opcodes in a row and only the first one in each group is
015400000000      * used to trigger record update.
015500000000      * *IN10 is setof when an END is found.
015600000000      *----------------------------------------------------------------
015700000000X03  C                   When      casend = 'CAS'  and
015800000000     C                             not *In10
015900000000     C                   Eval      *In10 = *On
016000000000     C                   ExSR      $insub
016100000000     C                   ExSR      $load
016200000000      *
016300000000      *----------------------------------------------------------------
016400000000      * Process the ELSE, WH, & OTHER op codes.  The record is updated
016500000000      * and count remains the same.
016600000000      *----------------------------------------------------------------
016700000000X03  C                   When      else = 'ELSE'  or
016800000000     C                             doifwh = 'WH'  or
016900000000     C                             opcode = 'OTHER'
017000000000     C                   Eval      code = 'X'
017100000000     C                   Except    $ifnum
017200000000      *
017300000000      *----------------------------------------------------------------
017400000000      * Flag evil GOTOs
017500000000      *----------------------------------------------------------------
017600000000X03  C                   When      opcode = 'GOTO '
017700000000     C                   Except    $goto
017800000000      *
017900000000      *
018000000000      *----------------------------------------------------------------
018100000000      * Process BEGSR and ENDSR
018200000000      *----------------------------------------------------------------
018300000000X03  C                   When      opcode = 'BEGSR'
018400000000     C                   Except    $bsr
018500000000      *
018600000000X03  C                   When      opcode = 'ENDSR'
018700000000     C                   Except    $esr
018800000000      *
018900000000      *----------------------------------------------------------------
019000000000      * Process the ITER opcode.  I is moved into the code and the
019100000000      * record is updated using the INNERMOST DO count from the DO
019200000000      * depth save array.
019300000000      *----------------------------------------------------------------
019400000000X03  C                   When      opcode = 'ITER '
019500000000     C                   Eval      $save = $l
019600000000     C                   Eval      $l = ado($d)
019700000000     C                   Eval      code = 'I'
019800000000     C                   Except    $ifnum
019900000000     C                   Eval      $l = $save
020000000000      *
020100000000      *----------------------------------------------------------------
020200000000      * Process the LEAVE opcode.  LI is moved into the code and the
020300000000      * record is updated using the INNERMOST DO count from the DO
020400000000      * depth save array.
020500000000      *----------------------------------------------------------------
020600000000X03  C                   When      opcode = 'LEAVE'
020700000000     C                   Eval      $save = $l
020800000000     C                   Eval      $l = ado($d)
020900000000     C                   Eval      code = 'L'
021000000000     C                   Except    $ifnum
021100000000     C                   Eval      $l = $save
021200000000      *
021300000000      *----------------------------------------------------------------
021400000000      * Process the ENDxx opcode.  E is moved into the code and the
021500000000      * record is updated. Depth has 1 subtracted after the update.
021600000000      *----------------------------------------------------------------
021700000000X03  C                   When      casend = 'END'  and
021800000000     C                             opcode <> 'ENDSR'
021900000000     C                   Clear                   *In10
022000000000     C                   Eval      code = 'E'
022100000000      *
022200000000      *----------------------------------------------------------------
022300000000      * Match the proper ENDxx to the opcode that started the
022400000000      * structure.  ie. IF/ENDIF , DO/ENDDO
022500000000      *----------------------------------------------------------------
022600000000B04  C                   If        $endlb = '*YES'
022700000000B05  C                   Select
022800000000X05  C                   When      op($l) = 'CA'
022900000000     C                   Eval      opcode = 'End' + 'CS'
023000000000X05  C                   When      op($l) = 'SE'
023100000000     C                   Eval      opcode = 'End' + 'SL'
023200000000X05  C                   When      op($l) = 'FO'
023300000000     C                   Eval      opcode = 'End' + 'For'
023301000000X05  C                   When      op($l) = 'DO'
023302000000     C                   Eval      opcode = 'End' + 'Do'
023303000000X05  C                   When      op($l) = 'IF'
023304000000     C                   Eval      opcode = 'End' + 'If'
023400000000X05  C                   Other
023500000000     C                   Eval      opcode = %trimr('End') + op($l)
023600000000E05  C                   EndSL
023700000000E04  C                   EndIf
023800000000      *
023900000000     C                   Except    $endxx
024000000000     C                   Eval      $save = $l
024100000000     C                   Eval      $l = $l - 1
024200000000      *
024300000000      *----------------------------------------------------------------
024400000000      * If the END is for the innermost DO, then clear that element
024500000000      * of the DO number array.
024600000000      *----------------------------------------------------------------
024700000000B04  C                   If        $d > 0  and
024800000000     C                             ado($d) = $save
024900000000     C                   Clear                   ado($d)
025000000000     C                   Eval      $d = $d - 1
025100000000E04  C                   EndIf
025200000000      *
025300000000      *----------------------------------------------------------------
025400000000      * Convert the SETON and SETOF opcodes to MOVE *ON or MOVE *OFF.
025500000000      * This will only be done if a single indicator is being used.
025600000000      *----------------------------------------------------------------
025700000000X03  C                   When      opcode = 'SETON'  or
025800000000     C                             opcode = 'SETOFF'
025900000000     C                   ExSR      $set
026000000000      *
026100000000      *----------------------------------------------------------------
026200000000      * Convert various clear operations to CLEAR opcode.
026300000000      *----------------------------------------------------------------
026400000000X03  C                   When      opcode = 'MOVE'   or
026500000000     C                             opcode = 'Z-ADD'  or
026600000000     C                             opcode = 'MOVEL'  or
026700000000     C                             opcode = 'MOVEA'
026800000000     C                   ExSR      $insub
026900000000     C                   ExSR      $clrop
027000000000      *
027100000000      *----------------------------------------------------------------
027200000000      * If none of the above conditions are met, the excpt is used
027300000000      * to clear the record from whatever may have been there before.
027400000000      *----------------------------------------------------------------
027500000000X03  C                   Other
027600000000     C                   ExSR      $insub
027700000000     C                   Except    $clear
027800000000E03  C                   EndSL
027900000000      *
028000000000X02  C                   When      *In02
028100000000B03  C                   If        $stncm = '*YES'
028200000000     C                   Except    $newcm
028300000000X03  C                   Else
028400000000     C                   Except    $clear
028500000000E03  C                   EndIf
028600000000      *
028700000000X02  C                   When      *In99
028800000000     C                   Except    $UpCas
028900000000      *
029000000000E02  C                   EndSL
029100000000     C                   MoveA     '0000'        *In(01)
029200000000      *
029300000000     C                   Read      JDELESRC                               LR
029400000000E01  C                   EndDo
029500000000      *
029600000000      *----------------------------------------------------------------
029700000000      * Load the indent count into the return parm if there are not
029800000000      * enough ENDxx statements for the code.
029900000000      *----------------------------------------------------------------
030000000000B01  C                   If        $l > 0
030100000000     C                   Eval      $stncm = '2M'
030200000000     C                   Move      $l            $stncm
030300000000E01  C                   EndIf
030400000000     C                   RETURN
030500000000      *
030600000000      *----------------------------------------------------------------
030700000000      * Upgrade '0' or '1' to *OFF or *ON for indicators used as fields
030800000000      *----------------------------------------------------------------
030900000000BSR  C     $insub        BegSR
031000000000B01  C                   If        ind1 = '*IN'  or
031100000000     C                             ind2 = '*IN'
031200000000      *
031300000000B02  C                   If        stat = '''0'''
031400000000     C                   Eval      fact2 = '*Off'
031500000000     C                   Eval      *In20 = *On
031600000000E02  C                   EndIf
031700000000      *
031800000000B02  C                   If        stat = '''1'''
031900000000     C                   Eval      fact2 = '*On'
032000000000     C                   Eval      *In20 = *On
032100000000E02  C                   EndIf
032200000000      *
032300000000E01  C                   EndIf
032400000000ESR  C                   EndSR
032500000000      *
032600000000      *----------------------------------------------------------------
032700000000      * Load the number of the BEGIN and the opcode name for use when
032800000000      * flagging ENDs.
032900000000      *----------------------------------------------------------------
033000000000BSR  C     $load         BegSR
033100000000     C                   Add       1             $l
033200000000     C                   Eval      code = 'B'
033300000000     C                   Except    $ifnum
033400000000      *
033500000000     C                   Eval      op($l) = doifwh
033600000000ESR  C                   EndSR
033700000000      *
033800000000      *----------------------------------------------------------------
033900000000      * Convert the SETON and SETOF opcodes to move *ON or move *OFF
034000000000      * for single indicator operations only.
034100000000      *----------------------------------------------------------------
034200000000BSR  C     $set          BegSR
034300000000     C                   Clear                   $ind
034400000000      *
034500000000B01  C                   Select
034600000000X01  C                   When      $hi > *blanks  and
034700000000     C                             $lo = *blanks  and
034800000000     C                             $eq = *blanks
034900000000     C                   Eval      $ind = $hi
035000000000      *
035100000000X01  C                   When      $hi = *blanks  and
035200000000     C                             $lo > *blanks  and
035300000000     C                             $eq = *blanks
035400000000     C                   Eval      $ind = $lo
035500000000      *
035600000000X01  C                   When      $hi = *blanks  and
035700000000     C                             $lo = *blanks  and
035800000000     C                             $eq > *blanks
035900000000     C                   Eval      $ind = $eq
036000000000E01  C                   EndSL
036100000000      *
036200000000      *----------------------------------------------------------------
036300000000      * Match proper constant to the type operation being performed.
036400000000      *----------------------------------------------------------------
036500000000B01  C                   If        $ind > *blanks
036600000000B02  C                   If        opcode = 'SETOFF'
036700000000     C                   Eval      opcode = 'Move '
036800000000     C                   Eval      fact2 = '*Off'
036900000000     C                   Eval      fact3 = %trimr('*In') + $ind
037000000000X02  C                   Else
037100000000     C                   Eval      opcode = 'Move '
037200000000     C                   Eval      fact2 = '*On'
037300000000     C                   Eval      fact3 = %trimr('*In') + $ind
037400000000E02  C                   EndIf
037500000000      *
037600000000     C                   Except    $setin
037700000000X01  C                   Else
037800000000     C                   Except    $clear
037900000000E01  C                   EndIf
038000000000ESR  C                   EndSR
038100000000      *
038200000000      *----------------------------------------------------------------
038300000000      * Convert various clearing operations to CLEAR opcode.
038400000000      * Several exceptions exist.
038500000000      * MOVEA is changed to CLEAR only if non-indexed - move blanks
038600000000      * MOVE is only done if = *OFF or *BLANKS
038700000000      *----------------------------------------------------------------
038800000000BSR  C     $clrop        BegSR
038900000000     C                   Eval      *In81 = *On
039000000000      *
039100000000B01  C                   Select
039200000000X01  C                   When      $leng <> *blanks
039300000000      *
039400000000X01  C                   When      opcode = 'MOVEA'
039500000000     C     ','           Scan      $3fact                                 81
039600000000B02  C                   If        not *In81  and
039700000000     C                             $2fact = '*BLAN'
039800000000     C                   Clear                   *In81
039900000000X02  C                   Else
040000000000     C                   Eval      *In81 = *On
040100000000E02  C                   EndIf
040200000000      *
040300000000      *
040400000000X01  C                   When      opcode = 'MOVE '  or
040500000000     C                             opcode = 'MOVEL'
040600000000B02  C                   If        $2fact = '*BLAN'
040700000000      ***                          ind2 = '*IN'  and
040800000000      ***                          stat = '''0'''  or
040900000000      ***                          ind2 = '*IN'  and
041000000000      ***                          $2fact = '*OFF '
041100000000     C                   Clear                   *In81
041200000000E02  C                   EndIf
041300000000      *
041400000000      *
041500000000X01  C                   When      opcode = 'Z-ADD'
041600000000B02  C                   If        $2fact = '0    '  or
041700000000     C                             $2fact = '*ZERO'  or
041800000000     C                             $2fact = '00   '  or
041900000000     C                             $2fact = '000  '  or
042000000000     C                             $2fact = '0000 '
042100000000     C                   Clear                   *In81
042200000000E02  C                   EndIf
042300000000E01  C                   EndSL
042400000000      *
042500000000B01  C                   If        not *In81
042600000000     C                   Eval      opcode = 'Clear'
042700000000      *****              eval      fact2 = $3fact
042800000000      *****              clear                   fact3
042900000000     C                   Clear                   fact2
043000000000     C                   Eval      fact3 = $3fact
043100000000     C                   Except    $setin
043200000000X01  C                   Else
043300000000     C                   Except    $clear
043400000000E01  C                   EndIf
043500000000      *
043600000000ESR  C                   EndSR
043700000000      *----------------------------------------------------------------
043800000000      * Monitor for an array index error occurring as commonly does
043900000000      * when the source has too many ENDXX. The statement number of the
044000000000      * line in error is loaded into one of the input parms and the
044100000000      * program cancels gracefully.
044200000000      *----------------------------------------------------------------
044300000000BSR  C     *pssr         BegSR
044400000000B01  C                   If        err = 121
044500000000     C                   Except    $Error
044600000000     C                   Eval      *InLR = *On
044700000000     C                   Eval      returnx = '*CANCL'
044800000000E01  C                   EndIf
044900000000ESR  C                   EndSR     returnx
045000000000      *
045100000000     OJDELESRC  e            $clear
045200000000      *****          40                          15 '   '
045300000000     O                  60                       18 'C'
045400000000      *****          30                          20 '  '
045500000000     O               20      fact2               61
045600000000      *---------------------------------------------
045700000000     O          e            $goto
045800000000      *                                          17 'Goto '
045801000000     O                                          107 '               '
045900000000     O                       Hex28              108
046000000000     O                                          112 'Goto'
046100000000     O                  60                       18 'C'
046200000000      *---------------------------------------------
046300000000     O          e            $bsr
046400000000      *                                          15 'BSR'
046401000000     O                                          108 '                '
046500000000     O                       Hex30              109
046600000000     O                                          112 'BSR'
046700000000     O                  60                       18 'C'
046800000000      *---------------------------------------------
046900000000     O          e            $esr
047000000000      *                                          15 'ESR'
047001000000     O                                          108 '                '
047100000000     O                       Hex30              109
047200000000     O                                          112 'ESR'
047300000000     O                  60                       18 'C'
047400000000      *---------------------------------------------
047500000000     O          e            $ifnum
047600000000      *                                          15 '   '
047700000000      *                      code                13
047800000000      *                      $l                  15
047900000000     O                                          112 '    '
047901000000     O                                          108 '                '
048000000000     O                       Hex30              109
048100000000     O                       code               110
048200000000     O                       $l                 112
048300000000     O                  60                       18 'C'
048400000000      *****          30                          20 '  '
048500000000     O               20      fact2               61
048600000000      *---------------------------------------------
048700000000     O          e            $endxx
048800000000      *                                          15 '   '
048900000000      *                      code                13
049000000000      *                      $l                  15
049100000000     O                                          112 '    '
049101000000     O                                          108 '                '
049200000000     O                       Hex30              109
049300000000     O                       code               110
049400000000     O                       $l                 112
049500000000     O                  60                       18 'C'
049600000000      *****          30                          20 '  '
049700000000     O               11      opcode              47
049800000000      *---------------------------------------------
049900000000     O          e            $newcm
050000000000      *****          40                          15 '   '
050100000000     O                  60                       18 'C'
050200000000     O                                           19 ' *'
050300000000     O               50      hex22               18
050400000000      *---------------------------------------------
050500000000     O          e            $setin
050600000000      *****                                      15 '   '
050700000000     O                  60                       18 'C'
050800000000      *****          30                          20 '  '
050900000000     O                       opcode              47
051000000000     O                       fact2               61
051100000000     O                       fact3               75
051200000000     O                                           88 '        '
051300000000      *---------------------------------------------
051400000000     O          e            $Error
051500000000      *                                          15 '???'
051600000000     O                       Hex22              109
051700000000     O                                          112 '???'
051800000000     O                  60                       18 'C'
051900000000      *---------------------------------------------
052000000000     O          e            $UpCas
052100000000     O                                           18 'D'
052200000000      *---------------------------------------------
