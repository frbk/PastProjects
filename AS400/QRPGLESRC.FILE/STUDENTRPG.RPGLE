000100140311     FSTUDENTDF CF   E             WORKSTN
000101140318     FSTUDENTS  IF   E             DISK
000102140311      /FREE
000103140311       READ STUDENTS;
000104140318       *IN60 = *ON;
000105140311       DOW NOT(*IN03) AND %EOF='0';
000106140318         *IN60 = *OFF;
000107140318         *IN61 = *OFF;
000108140318          IF FINESOWED > 0;
000109140318            *IN60 = *ON;
000110140318          ENDIF;
000111140318          IF FEESOWED > 0;
000112140318            *IN61= *ON;
000113140318          ENDIF;
000114140311          FullName = %TrimR(FirstName) + ' ' + LastName;
000115140311          EXFMT RECORD1;
000116140311          TOTSTUD = TOTSTUD + 1;
000117140311          FINESTOTAL = FINESTOTAL + FINESOWED;
000118140311          FEESTOTAL = FEESTOTAL + FEESOWED;
000119140311          READ STUDENTS;
000120140311       ENDDO;
000121140311       TOTAL = FEESTOTAL + FINESTOTAL;
000122140311       EXFMT RECORD2;
000123140311       *INLR = *ON;
000124140311       RETURN;
