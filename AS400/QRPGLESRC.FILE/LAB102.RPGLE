000100120403     fshiftratesif   e             disk    rename(shiftrates:shiftrater)
000200120403     fallshift  if   e           k disk    rename(allshift:allshiftr)
000300120403     flab10     cf   e             workstn
000400120403     fpayrpt    o    e             printer oflind(*in01)
000500120403     d  hoursover      s              3  0
000600120403
000700120403      /Free
000800120403            READ shiftrates;
000900120403            WRITE title;
001000120403            WRITE colhdg;
001100120403            READ allshift;
001200120403            DOW not %eof;
001300120403                EXSR paysr;
001400120403                IF *in01;
001500120403	               WRITE title;
001600120403	               WRITE colhdg;
001700120403                    *in01 = *off;
001800120403                    ENDIF;
001900120403                WRITE empdetail;
001901120403                overpay = 0;
002000120403                READ allshift;
002100120403                ENDDO;
002200120403            totemppay = totregpay + totovtpay;
002300120403            WRITE totals;
002301120403            EXFMT record1;
002500120403            *inlr = *on;
002600120403            RETURN;
002700120403
002800120403            BEGSR paysr;
002900120403            SELECT;
003000120403                WHEN workshift = 'D';
003100120403                    rate = dayrate;
003200120403                WHEN workshift = 'N';
003300120403                    rate = nightrate;
003400120403                WHEN workshift = 'A';
003500120403                    rate = aftnrate;
003600120403                ENDSL;
003601120403            SELECT;
003602120403                WHEN paygrade = '1';
003603120403                    EVAL(H) rate = rate * 1.085;
003604120403                WHEN paygrade = '2';
003605120403                    EVAL(H) rate = rate * 1.045;
003606120403                WHEN paygrade = '3';
003607120403                    EVAL(H) rate = rate * 0.95;
003608120403            ENDSL;
003609120403            hoursover = hrsworked - 40;
003700120403            EVAL(H) regpay = hrsworked * rate;
003701120403            IF hoursover > 0;
003702120403                 EVAL(H) overpay = hoursover * (1.5 * rate);
003703120403                 totalpay = overpay + regpay;
003704120403            ELSE;
003706120403                 totalpay = regpay;
003707120403                 ENDIF;
003708120403            totregpay = totregpay + regpay;
003709120403            totovtpay = totovtpay + overpay;
003710120403            ENDSR;
