000100960408/***************************************************************/
000200960410/*  Aldon Computer Group makes no warranty, express or         */
000300960410/*  implied, with regard to this material, including fitness   */
000400960410/*  for use.  Additionally, Aldon is not responsible for       */
000500960410/*  maintaining compatibility of this information with future  */
000600960410/*  releases.  Aldon provides this as an example only.         */
000700960410/*  Customers using this information do so at their own risk.  */
000800960410/***************************************************************/
000900960410/*                                                             */
001000960408/*  This example can be used as a shell for a "before all"     */
001100960408/*  or "after all" user exit.  Use this example if no other    */
001200030228/*  files (except ACMSEXITF2) are necessary for processing.    */
001300960408/*                                                             */
001400960408/*  Data is passed to this program by reading the file         */
001500030228/*  ACMSEXITF2.                                                */
001600030228/*                                                             */
001700030228/*  This program has been changed for Release 7.2 to allow     */
001800030228/*  for 128 character names.  Exit programs that were written  */
001900030228/*  for prior releases with 10 character name support can only */
002000030228/*  be used if 'Allow long object names' global option is      */
002100030228/*  set to 'N'.                                                */
002200960408/***************************************************************/
002300000000
002400960403             PGM        PARM(&ACTCODE &TIMCODE &FILEREC &FILENAM +
002500960403                          &LIBNAM &CMPLCDE)
002600000000
002700960403/*  Define parameters passed to this program.                  */
002800960403
002900960403             DCL        VAR(&ACTCODE) TYPE(*CHAR) LEN(3)
003000960403             DCL        VAR(&TIMCODE) TYPE(*CHAR) LEN(2)
003100050915             DCL        VAR(&FILEREC) TYPE(*CHAR) LEN(288)
003200960403             DCL        VAR(&FILENAM) TYPE(*CHAR) LEN(10)
003300960403             DCL        VAR(&LIBNAM) TYPE(*CHAR) LEN(10)
003400960403             DCL        VAR(&CMPLCDE) TYPE(*CHAR) LEN(1)
003500960403
003600960403/*  Define file record parameters.                             */
003700960403
003800960405             DCL        VAR(&GRP) TYPE(*CHAR) LEN(10)
003900960405             DCL        VAR(&PRD) TYPE(*CHAR) LEN(10)
004000020304             DCL        VAR(&OBJNAME) TYPE(*CHAR) LEN(128)
004100960403             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(8)
004200960403             DCL        VAR(&OBJATTR) TYPE(*CHAR) LEN(10)
004300020304             DCL        VAR(&OBJEXTA) TYPE(*CHAR) LEN(3)
004400960403             DCL        VAR(&FRMREL) TYPE(*CHAR) LEN(10)
004500960403             DCL        VAR(&FRMENV) TYPE(*CHAR) LEN(3)
004600960405             DCL        VAR(&FRMSUBENV) TYPE(*CHAR) LEN(10)
004700960405             DCL        VAR(&FRMOBJLIB) TYPE(*CHAR) LEN(10)
004800960405             DCL        VAR(&FRMSRCLIB) TYPE(*CHAR) LEN(10)
004900960403             DCL        VAR(&TOREL) TYPE(*CHAR) LEN(10)
005000960403             DCL        VAR(&TOENV) TYPE(*CHAR) LEN(3)
005100960405             DCL        VAR(&TOSUBENV) TYPE(*CHAR) LEN(10)
005200960405             DCL        VAR(&TOOBJLIB) TYPE(*CHAR) LEN(10)
005300960405             DCL        VAR(&TOSRCLIB) TYPE(*CHAR) LEN(10)
005400960405             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(10)
005500960405             DCL        VAR(&SRCM) TYPE(*CHAR) LEN(10)
005600960403             DCL        VAR(&PROJECT) TYPE(*CHAR) LEN(10)
005700960405             DCL        VAR(&EXITSTS) TYPE(*CHAR) LEN(2)
005800050915             DCL        VAR(&RETIRED) TYPE(*CHAR) LEN(1)
005900000000
006000100511      /*     DCLF       FILE(ACMSLIB/ACMSEXITF2)    */
006100030228             OVRDBF     FILE(ACMSEXITF2) TOFILE(&LIBNAM/&FILENAM)
006200000000
006300960408/*  Read a record and check for end of file.                   */
006400960408
006500100511/* NXTREC:     RCVF                                                 */
006600100511/*             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))  */
006700960403
006800100511/* Perform exit processing only if the Aldon/CMS function     */
006900960408/* completed normally.                                        */
007000960408
007100970725/* Before exits test for EXITSTS = '47'                       */
007200100511 /*          IF         COND(&EXITSTS *NE '47') THEN(GOTO +   */
007300100511 /*                       CMDLBL(ENDPGM))                     */
007400970725
007500970725/* After exits test for EXITSTS = '00'                        */
007600100511  /*         IF         COND(&EXITSTS *NE '00') THEN(GOTO +   */
007700100511  /*                      CMDLBL(ENDPGM))                     */
007800960405
007900960408
008000960403/*  INSERT THE MAINLINE OF YOUR EXIT HERE                      */
008100000000
008200100511             CPYF       FROMFILE(&LIBNAM/&FILENAM) +
008300100511                          TOFILE(MD75DEV/MDEXITF2) MBROPT(*ADD) +
008400100511                          CRTFILE(*YES)
008500100511             MONMSG     MSGID(CPF0000)
008600960405
008700100511 /*          GOTO       CMDLBL(NXTREC)        */
008800960403
008900960408 ENDPGM:
009000960408
009100970912/* The completion code parameter is your way of communicating */
009200970912/* the success or failure of the exit back to Aldon/CMS.  A   */
009300970912/* non-zero value signifies an abnormal completion; Aldon/CMS */
009400970912/* will stop or continue the function based on the "Stop on   */
009500970912/* Exit Error" flag.                                          */
009600970912
009700970912             CHGVAR     VAR(&CMPLCDE) VALUE('0')
009800970912
009900960408/*  For testing purposes it is often valuable to view the      */
010000960408/*  contents of the parameters being passed.  Use the          */
010100960408/*  DMPCLPGM command to see if you are getting the values      */
010200960408/*  you expect.                                                */
010300960408
010400100511   /*        DMPCLPGM      */
010500960408
010600960408             ENDPGM
