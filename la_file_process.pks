CREATE OR REPLACE package     LA_FILE_PROCESS
AS
 /****************************************************
   1/29/2017  VERSION # 6.7
  ****************************************************/

TYPE  GenRefCursor is REF CURSOR;
TYPE rowidArray is table of rowid index by binary_integer;


/********************************************
  Associative Arrays
 ********************************************/

TYPE LA_RESOLUTION_PENDING IS RECORD (
      Client              DBMS_SQL.VARCHAR2_TABLE,
      Invoice_nbr         DBMS_SQL.VARCHAR2_TABLE,
      INVOICE_NBR_SHORT   DBMS_SQL.VARCHAR2_TABLE,
      Order_nbr           DBMS_SQL.VARCHAR2_TABLE,
      Vendor_Contact      DBMS_SQL.VARCHAR2_TABLE,
      Loan_nbr            DBMS_SQL.VARCHAR2_TABLE,
      Invoice_Date        DBMS_SQL.VARCHAR2_TABLE,
      Dept                DBMS_SQL.VARCHAR2_TABLE,
      State               DBMS_SQL.VARCHAR2_TABLE,
      Resolution_Type     DBMS_SQL.VARCHAR2_TABLE,
      Invoice_Amt         DBMS_SQL.VARCHAR2_TABLE,
      Vendor_Comment      DBMS_SQL.VARCHAR2_TABLE,
      Vendor_Date         DBMS_SQL.VARCHAR2_TABLE,
      Client_Comment      DBMS_SQL.VARCHAR2_TABLE,
      client_Date         DBMS_SQL.VARCHAR2_TABLE,
      Reason              DBMS_SQL.VARCHAR2_TABLE,
      Resolution_Deadline DBMS_SQL.VARCHAR2_TABLE,
      Curtail_Date        DBMS_SQL.VARCHAR2_TABLE,
      pid                 DBMS_SQL.NUMBER_TABLE,
      LOAD_ID             DBMS_SQL.NUMBER_TABLE
);

TYPE LA_OUTSTANDING_ADJUSTED IS RECORD (
      Client              DBMS_SQL.VARCHAR2_TABLE,
      Invoice_nbr         DBMS_SQL.VARCHAR2_TABLE,
      INVOICE_NBR_SHORT   DBMS_SQL.VARCHAR2_TABLE,
      Order_nbr           DBMS_SQL.VARCHAR2_TABLE,
      Vendor              DBMS_SQL.VARCHAR2_TABLE,
      Vendor_Contact      DBMS_SQL.VARCHAR2_TABLE,
      Loan_nbr            DBMS_SQL.VARCHAR2_TABLE,
      Invoice_Date        DBMS_SQL.VARCHAR2_TABLE,
      Dept                DBMS_SQL.VARCHAR2_TABLE,
      State               DBMS_SQL.VARCHAR2_TABLE,
      BORROWER            DBMS_SQL.VARCHAR2_TABLE,
      Invoice_amt         DBMS_SQL.VARCHAR2_TABLE,
      Dispute_amt         DBMS_SQL.VARCHAR2_TABLE,
      Adjusted_total      DBMS_SQL.VARCHAR2_TABLE,
      Earliest_Adj_Dt     DBMS_SQL.VARCHAR2_TABLE,
      Curtail_Date        DBMS_SQL.VARCHAR2_TABLE,
      pid                 DBMS_SQL.NUMBER_TABLE,
      LOAD_ID             DBMS_SQL.NUMBER_TABLE
);

TYPE LA_PENDING_APPROVAL IS RECORD (
Client                    DBMS_SQL.VARCHAR2_TABLE,
Servicer                  DBMS_SQL.VARCHAR2_TABLE,
Loan_nbr                  DBMS_SQL.VARCHAR2_TABLE,
Order_nbr                 DBMS_SQL.VARCHAR2_TABLE,
Invoice_Type              DBMS_SQL.VARCHAR2_TABLE,
Invoice_Date              DBMS_SQL.VARCHAR2_TABLE,
Invoice_nbr               DBMS_SQL.VARCHAR2_TABLE,
invoice_amt               DBMS_SQL.VARCHAR2_TABLE,
State                     DBMS_SQL.VARCHAR2_TABLE,
LI_Code                   DBMS_SQL.VARCHAR2_TABLE,
LI_Description            DBMS_SQL.VARCHAR2_TABLE,
LI_Amt                    DBMS_SQL.VARCHAR2_TABLE,
Adjusted_AMT              DBMS_SQL.VARCHAR2_TABLE,
Total_LI_Amount           DBMS_SQL.VARCHAR2_TABLE,
Reason                    DBMS_SQL.VARCHAR2_TABLE,
Comments_Date             DBMS_SQL.VARCHAR2_TABLE,
Expires_IN                DBMS_SQL.VARCHAR2_TABLE,
LOAD_ID                   DBMS_SQL.NUMBER_TABLE,
FILE_ID                   DBMS_SQL.NUMBER_TABLE
);


TYPE LA_PENDING_REJECTIONS IS RECORD (
Client                    DBMS_SQL.VARCHAR2_TABLE,
Servicer                  DBMS_SQL.VARCHAR2_TABLE,
Loan_nbr                  DBMS_SQL.VARCHAR2_TABLE,
Invoice_Type              DBMS_SQL.VARCHAR2_TABLE,
Invoice_Date              DBMS_SQL.VARCHAR2_TABLE,
Invoice_nbr               DBMS_SQL.VARCHAR2_TABLE,
Order_nbr                 DBMS_SQL.VARCHAR2_TABLE,
State                     DBMS_SQL.VARCHAR2_TABLE,
Servicer_comments         DBMS_SQL.VARCHAR2_TABLE,
Comments_Date             DBMS_SQL.VARCHAR2_TABLE,
Expires_IN                DBMS_SQL.VARCHAR2_TABLE,
invoice_amt               DBMS_SQL.VARCHAR2_TABLE,
LOAD_ID                   DBMS_SQL.NUMBER_TABLE,
FILE_ID                   DBMS_SQL.NUMBER_TABLE
);

TYPE LA_IR_ASSIGNMENT IS RECORD (
CLIENT_CODE                    DBMS_SQL.VARCHAR2_TABLE,
RECEIVED_DATE                  DBMS_SQL.VARCHAR2_TABLE,
LAST_UPDATED                   DBMS_SQL.VARCHAR2_TABLE,
CLIENT                         DBMS_SQL.VARCHAR2_TABLE,
COL_D                          DBMS_SQL.VARCHAR2_TABLE,
INVOICE_NBR                    DBMS_SQL.VARCHAR2_TABLE,
INVOICE_DATE                   DBMS_SQL.VARCHAR2_TABLE,
WORK_ORDER_NBR                 DBMS_SQL.VARCHAR2_TABLE,
LOAN_NBR                       DBMS_SQL.VARCHAR2_TABLE,
COL_I                          DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_AMT                    DBMS_SQL.VARCHAR2_TABLE,
COL_K                          DBMS_SQL.VARCHAR2_TABLE,
CLIENT_COMMENT                 DBMS_SQL.VARCHAR2_TABLE,
COL_M                          DBMS_SQL.VARCHAR2_TABLE,
LOSS_ANALYST                   DBMS_SQL.VARCHAR2_TABLE,
WRITE_OFF_AMOUNT               DBMS_SQL.VARCHAR2_TABLE,
WRITE_OFF                      DBMS_SQL.VARCHAR2_TABLE,
WRITE_OFF_REASON_CODE          DBMS_SQL.VARCHAR2_TABLE,
WRITE_OFF_REASON               DBMS_SQL.VARCHAR2_TABLE,
DONE_BILLING_CODE              DBMS_SQL.VARCHAR2_TABLE,
VENDOR_CODE                    DBMS_SQL.VARCHAR2_TABLE,
CHARGEBACK_AMOUNT              DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_TYPE                   DBMS_SQL.VARCHAR2_TABLE,
SOURCE_OF_DISPUTE              DBMS_SQL.VARCHAR2_TABLE,
COL_X                          DBMS_SQL.VARCHAR2_TABLE,
APPROVAL                       DBMS_SQL.VARCHAR2_TABLE,
PENDING_RESEARCH               DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_APPEAL_COMMENT         DBMS_SQL.VARCHAR2_TABLE,
IM_ICLEAR_INV                  DBMS_SQL.VARCHAR2_TABLE,
CLIENT_EMPLOYEE                DBMS_SQL.VARCHAR2_TABLE,
LOAD_ID                        DBMS_SQL.VARCHAR2_TABLE,
FILE_ID                        DBMS_SQL.VARCHAR2_TABLE
);

TYPE ASSIGNMENT_ADHOC_REC IS RECORD
(
INVOICE_NBR              DBMS_SQL.VARCHAR2_TABLE,
IM_ICLEAR_NBR            DBMS_SQL.VARCHAR2_TABLE,
WORKORDER_NBR            DBMS_SQL.VARCHAR2_TABLE,
LOAN_NBR                 DBMS_SQL.VARCHAR2_TABLE,
CLIENT_CODE              DBMS_SQL.VARCHAR2_TABLE,
CLIENT_COMMENTS          DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_AMT              DBMS_SQL.VARCHAR2_TABLE,
INVOICE_AMT              DBMS_SQL.VARCHAR2_TABLE,
WRITE_OFF                DBMS_SQL.VARCHAR2_TABLE,
VENDOR_CODE              DBMS_SQL.VARCHAR2_TABLE,
CHARGE_BACK_AMT_1        DBMS_SQL.VARCHAR2_TABLE,
APPROVAL                 DBMS_SQL.VARCHAR2_TABLE,
PENDING_RESEARCH         DBMS_SQL.VARCHAR2_TABLE,
APPEAL                   DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_APPEAL_COMMENT   DBMS_SQL.VARCHAR2_TABLE,
DEPARTMENT               DBMS_SQL.VARCHAR2_TABLE,
CLIENT_EMPL              DBMS_SQL.VARCHAR2_TABLE,
BUCKET                   DBMS_SQL.VARCHAR2_TABLE,
INVOICE_DATE             DBMS_SQL.DATE_TABLE,
X_DISPUTED               DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_TYPE             DBMS_SQL.VARCHAR2_TABLE,
SOURCE_OF_DISPUTE        DBMS_SQL.VARCHAR2_TABLE,
CURTAIL_DATE             DBMS_SQL.DATE_TABLE,
LAST_UPDATED             DBMS_SQL.DATE_TABLE,
COMMENTS                 DBMS_SQL.VARCHAR2_TABLE,
RECEIVED_DATE            DBMS_SQL.DATE_TABLE,
WORK_CODE                DBMS_SQL.VARCHAR2_TABLE,
ADJUSTED_TOTAL           DBMS_SQL.VARCHAR2_TABLE,
MONTH_DATE               DBMS_SQL.VARCHAR2_TABLE,
LOSS_ANALYST             DBMS_SQL.VARCHAR2_TABLE,
PROCESSOR_ID             DBMS_SQL.NUMBER_TABLE,
QUEUE_NAME               DBMS_SQL.VARCHAR2_TABLE,
QUEUE_ID                 DBMS_SQL.NUMBER_TABLE,
DISPUTE_ID               DBMS_SQL.NUMBER_TABLE,
LOAD_DATE                DBMS_SQL.DATE_TABLE,
REVIEW_QUEUE             DBMS_SQL.VARCHAR2_TABLE,
ADHOC_INDC               DBMS_SQL.VARCHAR2_TABLE,
REVIEWER_ID              DBMS_SQL.NUMBER_TABLE,
REVIEWER_EMAIL_ADDRESS   DBMS_SQL.VARCHAR2_TABLE,
FILE_ID                  DBMS_SQL.NUMBER_TABLE,
LOAD_ID                  DBMS_SQL.NUMBER_TABLE,
DISPUTE_NBR              DBMS_SQL.NUMBER_TABLE
);


TYPE LA_RP  IS RECORD (
LOAD_ID      DBMS_SQL.NUMBER_TABLE,
CLIENT       DBMS_SQL.VARCHAR2_TABLE,
Invoice_nbr  DBMS_SQL.VARCHAR2_TABLE
);

TYPE LA_ASSIGNMENT_STG IS RECORD (
DISPUTE_ID     DBMS_SQL.NUMBER_TABLE,
CURTAIL_DATE   DBMS_SQL.DATE_TABLE,
CLIENT_CODE    DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_AMT    DBMS_SQL.NUMBER_TABLE,
INVOICE_AMT    DBMS_SQL.NUMBER_TABLE,
ADJUSTED_TOTAL DBMS_SQL.NUMBER_TABLE,
ROWIDS         rowidArray
);

TYPE LA_ASSIGNMENT_WRK IS RECORD (
DISPUTE_ID     DBMS_SQL.NUMBER_TABLE,
CURTAIL_DATE   DBMS_SQL.DATE_TABLE,
CLIENT_CODE    DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_AMT    DBMS_SQL.NUMBER_TABLE,
INVOICE_AMT    DBMS_SQL.NUMBER_TABLE,
ADJUSTED_TOTAL DBMS_SQL.NUMBER_TABLE,
ROWIDS         rowidArray
);

TYPE LA_keys IS RECORD (
DISPUTE_ID     DBMS_SQL.NUMBER_TABLE,
CURTAIL_DATE   DBMS_SQL.DATE_TABLE,
ROWIDS         rowidArray
);


TYPE LA_FILE_CAT IS RECORD (
  CATEGORY_NAME  DBMS_SQL.VARCHAR2_TABLE,
  SOURCES        DBMS_SQL.VARCHAR2_TABLE
);


TYPE LA_SCORING IS RECORD (
     DISPUTE_ID          DBMS_SQL.NUMBER_TABLE,
     Invoice_Amt         DBMS_SQL.NUMBER_TABLE,
     QUEUE_NAME          DBMS_SQL.VARCHAR2_TABLE,
     ROWIDS              ROWIDARRAY

);


TYPE LA_CLIENT_CODE IS RECORD (
     CLIENT_CODE  DBMS_SQL.VARCHAR2_TABLE,
     SOURCES      DBMS_SQL.VARCHAR2_TABLE
);


TYPE DynTbl IS RECORD (
SetVal       dbms_sql.VARCHAR2_table,
plcVal       dbms_sql.VARCHAR2_table,
useChrVal    dbms_sql.VARCHAR2_table,
useOprVal    dbms_sql.VARCHAR2_table
);

TYPE RECORD_SET IS RECORD(
DISPUTE_ID     DBMS_SQL.NUMBER_TABLE
);

TYPE CDATE IS RECORD(
CURTAIL_DATE DBMS_SQL.DATE_TABLE
);


TYPE DB_DATA IS RECORD(
GRP1       DBMS_SQL.VARCHAR2_TABLE,
GRP2       DBMS_SQL.VARCHAR2_TABLE,
CNT        DBMS_SQL.NUMBER_TABLE
);


TYPE COLS IS RECORD(
GR1          DBMS_SQL.VARCHAR2_TABLE
);

TYPE RWS IS RECORD(
GR2          DBMS_SQL.VARCHAR2_TABLE
);


TYPE XL_LINE IS RECORD (
COL1        VARCHAR2(200 BYTE),
COL2        VARCHAR2(200 BYTE),
COL3        VARCHAR2(200 BYTE),
COL4        VARCHAR2(200 BYTE),
COL5        VARCHAR2(200 BYTE),
COL6        VARCHAR2(200 BYTE),
COL7        VARCHAR2(200 BYTE),
COL8        VARCHAR2(200 BYTE),
COL9        VARCHAR2(200 BYTE),
COL10       VARCHAR2(200 BYTE),
COL11       VARCHAR2(200 BYTE),
COL12       VARCHAR2(200 BYTE),
COL13       VARCHAR2(200 BYTE),
COL14       VARCHAR2(200 BYTE),
COL15       VARCHAR2(200 BYTE),
COL16       VARCHAR2(200 BYTE),
COL17       VARCHAR2(200 BYTE),
COL18       VARCHAR2(200 BYTE),
COL19       VARCHAR2(200 BYTE),
COL20       VARCHAR2(200 BYTE),
COL21       VARCHAR2(200 BYTE),
COL22       VARCHAR2(200 BYTE),
COL23       VARCHAR2(200 BYTE),
COL24       VARCHAR2(200 BYTE),
COL25       VARCHAR2(200 BYTE),
COL26       VARCHAR2(200 BYTE),
COL27       VARCHAR2(200 BYTE),
COL28       VARCHAR2(200 BYTE),
COL29       VARCHAR2(200 BYTE),
COL30       VARCHAR2(200 BYTE),
COL31       VARCHAR2(200 BYTE),
total       varchar2(200 byte),
ROW_Nbr     NUMBER
);

TYPE XL_LINES IS TABLE OF XL_LINE;
XLS  XL_LINES;

Codes  LA_FILE_PROCESS.LA_CLIENT_CODE;

PROCEDURE SET_VALUE (R NUMBER, C NUMBER, V VARCHAR2);

PROCEDURE SET_CNT (R NUMBER, V VARCHAR2, N VARCHAR2, L VARCHAR2);

FUNCTION PIVOT_TBL(P_GROUP_BY1 VARCHAR2, P_GROUP_BY2 VARCHAR2, P_DAYS NUMBER ) RETURN XL_LINES PIPELINED;

FUNCTION DATE_FMTS ( P_DATE VARCHAR2) RETURN date;

PROCEDURE CreateRecordSet
(
p_loss_Analyst       IN     VARCHAR2,
p_Client             IN     VARCHAR2,
p_Approval           in     varchar2,
p_Appeal             in     varchar2,
p_source             in     varchar2,
p_opr                in     varchar2,
p_dispute_amt        in     varchar2,
p_dispute_type       in     varchar2,
p_APP_USER           IN     VARCHAR2,
p_RecordsFound       OUT    NUMBER,
p_MESSAGE            OUT    VARCHAR2
);

PROCEDURE CreateList
(
pmode       IN          VARCHAR2 DEFAULT 'dml',
pname       IN          VARCHAR2 DEFAULT NULL,
pOpr        IN          VARCHAR2 DEFAULT '=',
pvalue      IN          VARCHAR2 DEFAULT NULL,
List_cnt    IN OUT      NUMBER,
ArrayList   IN OUT      DynTbl
);


PROCEDURE CreateList
(
pmode       IN          VARCHAR2 DEFAULT 'dml',
pname       IN          VARCHAR2 DEFAULT NULL,
pOpr        IN          VARCHAR2 DEFAULT '=',
pvalue      IN          NUMBER   DEFAULT NULL,
List_cnt    IN OUT      NUMBER,
ArrayList   IN OUT      DynTbl
);


PROCEDURE CreateList
(
pmode       IN          VARCHAR2 DEFAULT 'dml',
pname       IN          VARCHAR2 DEFAULT NULL,
pOpr        IN          VARCHAR2 DEFAULT '=',
pvalue      IN          date     DEFAULT null,
List_cnt    IN OUT      NUMBER,
ArrayList   IN OUT      DynTbl
);

PROCEDURE LOAD_LA_FILES;

PROCEDURE CONVERT_RESOLUTION_PENDING ( P_FILE_ID NUMBER);

PROCEDURE CONVERT_OUTSTANDING_ADJUSTED ( P_FILE_ID NUMBER);

PROCEDURE CONVERT_PENDING_APPROVAL (P_FILE_ID NUMBER);

PROCEDURE CONVERT_PENDING_REJECTIONS (P_FILE_ID NUMBER);

PROCEDURE CONVERT_IR_ASSIGNMENT (P_FILE_ID NUMBER);

PROCEDURE SAVE_HIGH_QUEUE ( P_HIGH_LIST VARCHAR2, P_PID NUMBER );

PROCEDURE SAVE_LOW_QUEUE ( P_LOW_LIST VARCHAR2, P_PID NUMBER );

PROCEDURE SAVE_REVIEW_QUEUE ( P_REVIEW_LIST VARCHAR2, P_PID NUMBER );

PROCEDURE SAVE_ADHOC_QUEUE ( P_ADHOC_LIST VARCHAR2, P_PID NUMBER );

PROCEDURE UPDATE_HIGH_QUEUES ( P_PID NUMBER);

PROCEDURE RESET_QUEUES;

PROCEDURE SAVE_ADHOC_INDC ( P_PID NUMBER );

PROCEDURE SPECIAL_ASSIGNMENT ( P_APP_ID NUMBER,  P_PAGE_ID NUMBER, P_APPL_USER VARCHAR2, P_ASSIGN_TO VARCHAR2, P_CURTAIL_DATE DATE, P_TABLE VARCHAR2, P_TAG VARCHAR2,  P_MESSAGE OUT VARCHAR2);

PROCEDURE ASSIGN_HIGH_LOW(P_INVOICE_AMT NUMBER);

PROCEDURE GATHER_NEW_REPORTS;

PROCEDURE ADJUST_CURTAIL_DATE;

PROCEDURE SET_HIGH_LOW;

PROCEDURE SET_QUEUES;

PROCEDURE LOAD_ASSIGNMENT;

PROCEDURE SETUP_ASSIGNMENT;

FUNCTION  DATE_REFORMAT ( P_DATE VARCHAR2 ) RETURN VARCHAR2;

PROCEDURE RE_NUMBER_DISPUTES;

function clean_invoice_nbr( LPSICLEAR VARCHAR2) RETURN VARCHAR2;

function clean_order_nbr( Order_nbr VARCHAR2) RETURN VARCHAR2;


END;

/

CREATE OR REPLACE PACKAGE BODY     LA_FILE_PROCESS
AS

 /********************************************************************************************
   02/29/2016 version # 1   RFC 15913
   05/19/2016 version # 4   RFC 15913
   05/31/2016 version # 5   Pending Approval
   1. Files are added to a stage table by way of IRecon  set LA_FILES_LOADED_LIST.LOADED = 0
   2. Files are loaded and recorded in the system        set LA_FILES_LOADED_LIST.LOADED = 1
   3. data from step 2 is cleaned and converted          set LA_FILES_LOADED_LIST.LOADED = 2
   4. The Data mart refresh process loads the data       set LA_FILES_LOADED_LIST.LOADED = 3
   5  load la assignment
   01/09/2017 Version # 6.6 Just load and export data
  ********************************************************************************************/

PROCEDURE SET_VALUE (R NUMBER, C NUMBER, V VARCHAR2)
IS

BEGIN

          IF  (C = 1  ) THEN XLS(R).COL1    := V;END IF;
          IF  (C = 2  ) THEN XLS(R).COL2    := V;END IF;
          IF  (C = 3  ) THEN XLS(R).COL3    := V;END IF;
          IF  (C = 4  ) THEN XLS(R).COL4    := V;END IF;
          IF  (C = 5  ) THEN XLS(R).COL5    := V;END IF;
          IF  (C = 6  ) THEN XLS(R).COL6    := V;END IF;
          IF  (C = 7  ) THEN XLS(R).COL7    := V;END IF;
          IF  (C = 8  ) THEN XLS(R).COL8    := V;END IF;
          IF  (C = 9  ) THEN XLS(R).COL9    := V;END IF;
          IF  (C = 10 ) THEN XLS(R).COL10   := V;END IF;
          IF  (C = 11 ) THEN XLS(R).COL11   := V;END IF;
          IF  (C = 12 ) THEN XLS(R).COL12   := V;END IF;
          IF  (C = 13 ) THEN XLS(R).COL13   := V;END IF;
          IF  (C = 14 ) THEN XLS(R).COL14   := V;END IF;
          IF  (C = 15 ) THEN XLS(R).COL15   := V;END IF;
          IF  (C = 16 ) THEN XLS(R).COL16   := V;END IF;
          IF  (C = 17 ) THEN XLS(R).COL17   := V;END IF;
          IF  (C = 18 ) THEN XLS(R).COL18   := V;END IF;
          IF  (C = 19 ) THEN XLS(R).COL19   := V;END IF;
          IF  (C = 20 ) THEN XLS(R).COL20   := V;END IF;
          IF  (C = 21 ) THEN XLS(R).COL21   := V;END IF;
          IF  (C = 22 ) THEN XLS(R).COL22   := V;END IF;
          IF  (C = 23 ) THEN XLS(R).COL23   := V;END IF;
          IF  (C = 24 ) THEN XLS(R).COL24   := V;END IF;
          IF  (C = 25 ) THEN XLS(R).COL25   := V;END IF;
          IF  (C = 26 ) THEN XLS(R).COL26   := V;END IF;
          IF  (C = 27 ) THEN XLS(R).COL27   := V;END IF;
          IF  (C = 28 ) THEN XLS(R).COL28   := V;END IF;
          IF  (C = 29 ) THEN XLS(R).COL29   := V;END IF;
          IF  (C = 30 ) THEN XLS(R).COL30   := V;END IF;
          IF  (C = 31 ) THEN XLS(R).COL31   := V;END IF;
          IF  (C = 33 ) THEN XLS(R).ROW_nbr := V;END IF;
END;

--- R = ROWS
--- V = CURTAIL DATE
--- N = NUMBER FOR REP
--- L = Loss Analyst

PROCEDURE SET_CNT (R NUMBER, V VARCHAR2, N VARCHAR2, L VARCHAR2)
IS

BEGIN

          IF  (XLS(2).COL2  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL2  := N;  END IF;
          IF  (XLS(2).COL3  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL3  := N;  END IF;
          IF  (XLS(2).COL4  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL4  := N;  END IF;
          IF  (XLS(2).COL5  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL5  := N;  END IF;
          IF  (XLS(2).COL6  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL6  := N;  END IF;
          IF  (XLS(2).COL7  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL7  := N;  END IF;
          IF  (XLS(2).COL8  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL8  := N;  END IF;
          IF  (XLS(2).COL9  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL9  := N;  END IF;
          IF  (XLS(2).COL10 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL10 := N;  END IF;
          IF  (XLS(2).COL11 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL11 := N;  END IF;
          IF  (XLS(2).COL12 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL12 := N;  END IF;
          IF  (XLS(2).COL13 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL13 := N;  END IF;
          IF  (XLS(2).COL14 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL14 := N;  END IF;
          IF  (XLS(2).COL15 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL15 := N;  END IF;
          IF  (XLS(2).COL16 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL16 := N;  END IF;
          IF  (XLS(2).COL17 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL17 := N;  END IF;
          IF  (XLS(2).COL18 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL18 := N;  END IF;
          IF  (XLS(2).COL19 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL19 := N;  END IF;
          IF  (XLS(2).COL20 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL20 := N;  END IF;
          IF  (XLS(2).COL21 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL21 := N;  END IF;
          IF  (XLS(2).COL22 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL22 := N;  END IF;
          IF  (XLS(2).COL23 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL23 := N;  END IF;
          IF  (XLS(2).COL24 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL24 := N;  END IF;
          IF  (XLS(2).COL25 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL25 := N;  END IF;
          IF  (XLS(2).COL26 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL26 := N;  END IF;
          IF  (XLS(2).COL27 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL27 := N;  END IF;
          IF  (XLS(2).COL28 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL28 := N;  END IF;
          IF  (XLS(2).COL29 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL29 := N;  END IF;
          IF  (XLS(2).COL30 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL30 := N;  END IF;
          IF  (XLS(2).COL31 = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL31 := N;  END IF;

END;


FUNCTION PIVOT_TBL(P_GROUP_BY1 VARCHAR2, P_GROUP_BY2 VARCHAR2, P_DAYS NUMBER ) RETURN XL_LINES PIPELINED
IS

DB     DB_DATA;
C      COLS;
R      RWS;

GC    GenRefCursor;

SQL_STMT   VARCHAR2(32000);

CNT1      NUMBER;
CNT2      PLS_INTEGER;
CNT3      NUMBER;
ADDED     NUMBER;
headings  PLS_INTEGER;
Ncols     PLS_INTEGER;
BEGIN

headings := 2;

/*
TYPE DB_DATA IS RECORD(
GRP1       DBMS_SQL.VARCHAR2_TABLE,
GRP2       DBMS_SQL.VARCHAR2_TABLE,
CNT        DBMS_SQL.NUMBER_TABLE
);
*/


----- ROWS         COLUMNS
--- LOSS_ANALYST, CURTAIL_DATE, 7

ADDED := 0;

XLS := XL_LINES();


SQL_STMT := 'SELECT '||P_GROUP_BY1||' FROM LA_ASSIGNMENT WHERE '||P_GROUP_BY1||' IS NOT NULL GROUP BY '||P_GROUP_BY1||' ORDER BY '||P_GROUP_BY1||' ';

OPEN GC FOR SQL_STMT;
         FETCH GC BULK COLLECT INTO R.GR2;
         CNT2 := R.GR2.count;
close gc;


--- CURTAIL_DATEs CNT1 is how many columns
SQL_STMT := 'SELECT '||P_GROUP_BY2||' FROM LA_ASSIGNMENT WHERE '||P_GROUP_BY2||' IS NOT NULL GROUP BY '||P_GROUP_BY2||' ORDER BY '||P_GROUP_BY2||' ';

OPEN GC FOR SQL_STMT;
         FETCH GC BULK COLLECT INTO C.GR1;
         CNT1 := C.GR1.count;
close gc;
-- Loss Analyst, curtail date, ...
--- columns of data to add up

Ncols   :=  (CNT1 - 1);


XLS.EXTEND;

--- LOSS_ANALYST, CURTAIL_DATE, CURTAIL_DATE, CURTAIL_DATE
--------- ROW, COLUMN NUMBER, VALUE
SET_VALUE (1, 1,P_GROUP_BY1);
SET_VALUE (R=>1, C=>33, V=>1);

------ set curtail date across the page
FOR X IN 1..CNT1 LOOP

     SET_VALUE (1, (X+1), P_GROUP_BY2);

END LOOP;

------------------ROW # 2
---- st the values of curtail dates across the page

XLS.EXTEND;

------- 25-JUL-16, 26-JUL-16

----- make it pretty  on second row

SET_VALUE (2, 1,'------------');
SET_VALUE (R=>2, C=>33, V=>2);


FOR X IN 1..CNT1 LOOP


    SET_VALUE (2, (X + 1), C.GR1(X));

END LOOP;

--- CNT1 IS THE COLUMNS
--- CNT2 IS THE ROWS

---- christian, 0, 0, 0, 0
------- starting on third line row 2 + z
------- set the row number at pos 33
--------- zero out rows x columns (3,1) = 0 (3,2) = 0

FOR Z IN 1..CNT2 LOOP

XLS.EXTEND;
     SET_VALUE ( R=>(z + 2), C=>33, V=>(z + 2) );
     SET_VALUE ( (z + 2), 1, R.GR2(z));

     FOR Y IN 1..CNT1 LOOP
          SET_VALUE (( z + 2), (Y + 1), '0');

     END LOOP;

END LOOP;



----------------- Find loss analyst and update their count

SQL_STMT := 'SELECT  '||P_GROUP_BY1||','||P_GROUP_BY2||', COUNT(*) AS CNT FROM LA_ASSIGNMENT WHERE '||P_GROUP_BY1||' IS NOT NULL GROUP BY '||P_GROUP_BY1||','||P_GROUP_BY2||' ORDER BY '||P_GROUP_BY1||' ';

OPEN GC FOR SQL_STMT;
         FETCH GC BULK COLLECT INTO DB.GRP1,
                                    DB.GRP2,
                                    DB.CNT;
         CNT3 := DB.GRP1.count;

close gc;

-----PROCEDURE SET_CNT (R NUMBER, V VARCHAR2, N VARCHAR2, L VARCHAR2)
---  R => ROW
---  walk down group by  v is the date, L is the loss Analyst
FOR Y IN 1..CNT2 LOOP


      FOR Z IN 1..CNT3 LOOP
              SET_CNT (R=>(y + 2), V=>DB.GRP2(Z),  N=>NVL(DB.CNT(Z),0), L=>DB.GRP1(Z) );
      END LOOP;

 END LOOP;


---- cnt2 how many rows only 4

/*
FOR Z IN 1..CNT2 LOOP

--                XLS(2).COL2  = V   AND XLS(R).COL1 = L )  THEN  XLS(R).COL2  := N;

                 XLS(Z + 2).TOTAL := CASE WHEN P_DAYS IN (7) THEN XLS(Z + 2).COL2 + XLS(Z + 2).COL3 + XLS(Z + 2 ).COL4 + XLS(Z + 2 ).COL5 + XLS(Z + 2).COL6 + XLS(Z + 2).COL7 + XLS(Z +2 ).COL8
                                      ELSE XLS(Z).COL2 + XLS(Z).COL3 + XLS(Z).COL4 + XLS(Z).COL5 + XLS(Z).COL6 + XLS(Z).COL7 + XLS(Z).COL8 + XLS(Z).COL9 + XLS(Z).COL10 + XLS(Z).COL11 + XLS(Z).COL12 + XLS(Z).COL13
                                 END;





END LOOP;
*/


           for k in 1..XLS.COUNT  loop
               if ( k > headings ) then
                    if ( Ncols = 1 ) then  XLS(k).TOTAL  := XLS(k).COL2; end if;
                    if ( Ncols = 2 ) then  XLS(k).TOTAL  :=  XLS(k).COL2 + XLS(k).COL3;  end if;
                    if ( Ncols = 3 ) then  XLS(k).TOTAL  :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4; end if;
                    if ( Ncols = 4 ) then  XLS(k).TOTAL  :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5; end if;
                    if ( Ncols = 5 ) then  XLS(k).TOTAL  :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6; end if;
                    if ( Ncols = 6 ) then  XLS(k).TOTAL  :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7; end if;
                    if ( Ncols = 7 ) then  XLS(k).TOTAL  :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8; end if;
                    if ( Ncols = 8 ) then  XLS(k).TOTAL  :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9; end if;
                    if ( Ncols = 9 ) then  XLS(k).TOTAL  :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10; end if;
                    if ( Ncols = 10 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11; end if;
                    if ( Ncols = 11 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12; end if;
                    if ( Ncols = 12 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13; end if;
                    if ( Ncols = 13 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14; end if;
                    if ( Ncols = 14 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15; end if;
                    if ( Ncols = 15 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16; end if;
                    if ( Ncols = 16 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17; end if;
                    if ( Ncols = 17 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18; end if;
                    if ( Ncols = 18 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19; end if;
                    if ( Ncols = 19 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20; end if;
                    if ( Ncols = 20 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21; end if;
                    if ( Ncols = 21 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22; end if;
                    if ( Ncols = 22 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23; end if;
                    if ( Ncols = 23 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23 + XLS(k).COL24; end if;
                    if ( Ncols = 24 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23 + XLS(k).COL24 + XLS(k).COL25; end if;
                    if ( Ncols = 25 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23 + XLS(k).COL24 + XLS(k).COL25 + XLS(k).COL26; end if;
                    if ( Ncols = 26 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23 + XLS(k).COL24 + XLS(k).COL25 + XLS(k).COL26 + XLS(k).COL27; end if;
                    if ( Ncols = 27 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23 + XLS(k).COL24 + XLS(k).COL25 + XLS(k).COL26 + XLS(k).COL27 + XLS(k).COL28; end if;
                    if ( Ncols = 28 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23 + XLS(k).COL24 + XLS(k).COL25 + XLS(k).COL26 + XLS(k).COL27 + XLS(k).COL28 + XLS(k).COL29; end if;
                    if ( Ncols = 29 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23 + XLS(k).COL24 + XLS(k).COL25 + XLS(k).COL26 + XLS(k).COL27 + XLS(k).COL28 + XLS(k).COL29 + XLS(k).COL30; end if;
                    if ( Ncols = 30 ) then  XLS(k).TOTAL :=  XLS(k).COL2 + XLS(k).COL3 + XLS(k).COL4 + XLS(k).COL5 + XLS(k).COL6 + XLS(k).COL7 + XLS(k).COL8 + XLS(k).COL9 + XLS(k).COL10 + XLS(k).COL11 + XLS(k).COL12 + XLS(k).COL13 + XLS(k).COL14 + XLS(k).COL15 + XLS(k).COL16 + XLS(k).COL17 + XLS(k).COL18 + XLS(k).COL19 + XLS(k).COL20 + XLS(k).COL21 + XLS(k).COL22 + XLS(k).COL23 + XLS(k).COL24 + XLS(k).COL25 + XLS(k).COL26 + XLS(k).COL27 + XLS(k).COL28 + XLS(k).COL29 + XLS(k).COL30 + XLS(k).COL31; end if;

               end if;

           end loop;



            for k in 1..XLS.COUNT  loop
                 PIPE ROW (XLS(k));
           end loop;



END;



FUNCTION DATE_FMTS ( P_DATE VARCHAR2) RETURN date
IS
LOC_DATE    DATE;
LOC_PARM    VARCHAR2(40);
RET_VALUE   DATE;

BEGIN

LOC_DATE  := NULL;
RET_VALUE := NULL;

    LOC_PARM   := CASE WHEN LENGTH (LTRIM(RTRIM(P_DATE))) IN (9)  THEN SUBSTR(LTRIM(RTRIM(P_DATE)), 1,9)
                       WHEN LENGTH (LTRIM(RTRIM(P_DATE))) IN (10) THEN SUBSTR(LTRIM(RTRIM(P_DATE)), 1,10)
                       WHEN LENGTH (LTRIM(RTRIM(P_DATE))) > 10    THEN CASE  WHEN SUBSTR(LTRIM(RTRIM(P_DATE)),3,3) IN (' 1 ',' 2 ',' 3 ',' 4 ',' 5 ',' 6 ',' 7 ',' 8 ',' 9 ') THEN  SUBSTR(LTRIM(RTRIM(P_DATE)), 1,10)
                                                                       ELSE  SUBSTR(LTRIM(RTRIM(P_DATE)), 1,11)
                                                                       END
                  END;
     BEGIN

      LOC_DATE :=  TO_DATE(LOC_PARM,'DD-MON-YY');


      RETURN LOC_DATE;


     EXCEPTION
             WHEN OTHERS THEN

               begin
                     LOC_DATE :=  TO_DATE(LOC_PARM,'MM-DD-YYYY');

                     RETURN LOC_DATE;

               exception
                         when others then

                         begin
                                LOC_DATE :=  TO_DATE(LOC_PARM,'MM/DD/YYYY');

                                RETURN LOC_DATE;

                                EXCEPTION
                                WHEN OTHERS THEN

                                  BEGIN

                                  LOC_DATE :=  TO_DATE(LOC_PARM,'mon dd yyyy');

                                  RETURN LOC_DATE;

                                  EXCEPTION
                                  WHEN OTHERS THEN
                                    return RET_VALUE;
                                  END;
                         end;

               end;
     end;

RETURN RET_VALUE;

EXCEPTION
     WHEN OTHERS THEN

      RETURN RET_VALUE;

END;


PROCEDURE CreateRecordSet
(
p_loss_Analyst       IN     VARCHAR2,
p_Client             IN     VARCHAR2,
p_Approval           in     varchar2,
p_Appeal             in     varchar2,
p_source             in     varchar2,
p_opr                in     varchar2,
p_dispute_amt        in     varchar2,
p_dispute_type       in     varchar2,
p_APP_USER           IN     VARCHAR2,
p_RecordsFound       OUT    NUMBER,
p_MESSAGE            OUT    VARCHAR2
)
is

    COL_FMT         VARCHAR2(1000 BYTE);
    MSG_STMT        VARCHAR2(1000 BYTE);
    SQL_STMT        VARCHAR2(32000 BYTE);
    RS_STMT         VARCHAR2(32000 BYTE);
    WHR_STMT        VARCHAR2(32000 BYTE);
    TBL_STMT        VARCHAR2(32000 BYTE);
    SEL_STMT        VARCHAR2(32000 BYTE);
    GRASS_STMT      VARCHAR2(1000 BYTE);
    V_LOAN_TYPE     VARCHAR2(20 BYTE);
    LOAN_TYPE       VARCHAR2(20 BYTE);
    ByWho           PLS_INTEGER;
    GC              la_file_process.GenRefCursor;
    plc_hold        NUMBER(10);
    Q_SIZE          NUMBER(10);
    REC_SET_SIZE    NUMBER(10);
    v_includes      NUMBER(10);
    v_excludes      NUMBER(10);

    WhrList       la_file_process.DynTbl;
    RS            la_file_process.RECORD_SET;
    BAD_DATA      EXCEPTION;

begin

   SELECT USER_ID
   INTO Bywho
   FROM LA_EMP_SECURITY
   WHERE UPPER(LOGIN) = UPPER(P_APP_USER);

         PLC_HOLD := 1;


         CreateList(pmode =>'sel',pname =>'LOSS_ANALYST', pvalue =>p_loss_Analyst,List_cnt =>PLC_HOLD, ArrayList =>WhrList);
         CreateList(pmode =>'sel',pname =>'CLIENT_CODE',  pvalue =>p_Client,List_cnt =>PLC_HOLD, ArrayList =>WhrList);
         CreateList(pmode =>'sel',pname =>'APPROVAL',     pvalue =>p_Approval,List_cnt =>PLC_HOLD, ArrayList =>WhrList);
         CreateList(pmode =>'sel',pname =>'APPEAL',       pvalue =>p_Appeal,List_cnt =>PLC_HOLD, ArrayList =>WhrList);
         CreateList(pmode =>'sel',pname =>'SOURCE_OF_DISPUTE',pvalue =>p_source,List_cnt =>PLC_HOLD, ArrayList =>WhrList);
         CreateList(pmode =>'sel',pname =>'DISPUTE_AMT', pOpr =>p_opr, pvalue =>p_dispute_amt, List_cnt =>PLC_HOLD, ArrayList =>WhrList);
         CreateList(pmode =>'sel',pname =>'DISPUTE_TYPE',pvalue =>p_dispute_type,List_cnt =>PLC_HOLD, ArrayList =>WhrList);


                 for k in 1..WhrList.setVal.count loop

                          COL_FMT  := CASE WHEN WhrList.setVal(k) IN ('DISPUTE_AMT') THEN  ' REPLACE(REPLACE(C.DISPUTE_AMT,''$'',''''),'','','''') '||p_opr
                                           ELSE ' C.'||WhrList.setVal(k)||' = '
                                      END;

                          WHR_stmt := WHR_stmt||COL_FMT||' :'||WhrList.plcVal(k)||' AND';
                 end loop;



              WHR_STMT   := RTRIM(WHR_STMT,'AND');


              IF      PLC_HOLD = 1  THEN
                      TBL_STMT := 'INSERT INTO LA_ADHOC_QUEUE( DISPUTE_ID, USER_ID ) SELECT C.DISPUTE_ID, '||ByWho||' as user_id  FROM LA_ASSIGNMENT C WHERE C.QUEUE_ID = :A ';
              ELSE
                      TBL_STMT := 'INSERT INTO LA_ADHOC_QUEUE( DISPUTE_ID, USER_ID ) SELECT C.DISPUTE_ID, '||ByWho||' as user_id  FROM LA_ASSIGNMENT C WHERE 1 = :A AND  ';
              end if;


              SQL_STMT := TBL_STMT||WHR_STMT;

--              insert into show_stmt values (SQL_STMT);
--              COMMIT;


              IF      PLC_HOLD = 1  THEN
                      EXECUTE IMMEDIATE SQL_STMT USING ByWho;
              elsif   PLC_HOLD = 2  THEN
                      EXECUTE IMMEDIATE SQL_STMT using 1, whrList.useChrVal(1);
              ELSIF  plc_hold = 3  THEN
                      EXECUTE IMMEDIATE SQL_STMT using 1, whrList.useChrVal(1), whrList.useChrVal(2);
              ELSIF  plc_hold = 4  THEN
                      EXECUTE IMMEDIATE SQL_STMT using 1, whrList.useChrVal(1), whrList.useChrVal(2), whrList.useChrVal(3);
              ELSIF  plc_hold = 5  THEN
                      EXECUTE IMMEDIATE SQL_STMT using 1, whrList.useChrVal(1), whrList.useChrVal(2),whrList.useChrVal(3),whrList.useChrVal(4);
              ELSIF  plc_hold = 6  THEN
                      EXECUTE IMMEDIATE SQL_STMT using 1, whrList.useChrVal(1), whrList.useChrVal(2),whrList.useChrVal(3),whrList.useChrVal(4),whrList.useChrVal(5);
              ELSIF  plc_hold = 7  THEN
                      EXECUTE IMMEDIATE SQL_STMT using 1, whrList.useChrVal(1), whrList.useChrVal(2),whrList.useChrVal(3),whrList.useChrVal(4),whrList.useChrVal(5),whrList.useChrVal(6);
              ELSIF  plc_hold = 8  THEN
                      EXECUTE IMMEDIATE SQL_STMT using 1, whrList.useChrVal(1), whrList.useChrVal(2),whrList.useChrVal(3),whrList.useChrVal(4),whrList.useChrVal(5),whrList.useChrVal(6),whrList.useChrVal(7);

              end if;


             p_RecordsFound := SQL%ROWCOUNT;

           COMMIT;

          p_Message := CASE WHEN  p_RecordsFound = 0   THEN 'Sorry, the criteria didn''t return rows '
                            WHEN  p_RecordsFound > 0   THEN 'The record set was created successfully'
                            ELSE  'Some issue occured'   END;


        INSERT INTO BOA_PROCESS_LOG
        (
          PROCESS,
          SUB_PROCESS,
          ENTRYDTE,
          ROWCOUNTS,
          MESSAGE
        )
        VALUES ( 'LA_ASSIGNMENT','create record set ',SYSDATE, p_RecordsFound, 'priv_id '||ByWho);

        COMMIT;

 EXCEPTION
     WHEN BAD_DATA THEN
          p_RecordsFound := 0;
     WHEN OTHERS THEN
          p_Message := SQLERRM;
          p_RecordsFound := SQLCODE;
  END;



/*
  for varchar2
 */

PROCEDURE CreateList (pmode VARCHAR2 default 'dml', pname VARCHAR2 default null, pOpr VARCHAR2 default '=', pvalue VARCHAR2 default null, List_cnt in out NUMBER, ArrayList IN OUT DynTbl)
is

validOpr  VARCHAR2(100);

begin
        validOpr :=  CASE WHEN upper(pOpr) in ('=','!=','<>','<','>','>=','<=','LIKE') THEN pOpr ELSE '=' end;

       IF pvalue is not null  then
          if pmode = 'sel'  then
              ArrayList.SetVal(list_cnt) := pname;
              ArrayList.plcVal(list_cnt) := list_cnt;
              ArrayList.useChrVal(list_cnt) := pvalue;
              ArrayList.useOprVal(list_cnt) := validOpr;
          else
              ArrayList.SetVal(list_cnt) := pname;
              ArrayList.plcVal(list_cnt) := list_cnt;
              ArrayList.useChrVal(list_cnt) := CASE WHEN UPPER(Pvalue) = 'NULL' THEN 'NVL_VAL' ELSE ''''||Pvalue||'''' END;
              ArrayList.useOprVal(list_cnt) := validOpr;
          end if;
          list_cnt := list_cnt + 1;
       end if;


end;

/*
   for number
 */

PROCEDURE CreateList (pmode VARCHAR2 default 'dml', pname VARCHAR2 default null, pOpr VARCHAR2 default '=',  pvalue NUMBER default null,   List_cnt in out NUMBER, ArrayList IN OUT DynTbl)
is

validOpr  VARCHAR2(100);

begin
         validOpr :=  CASE WHEN upper(pOpr) in ('=','!=','<>','<','>','>=','<=','LIKE') THEN pOpr ELSE '=' end;

       IF pvalue is not null  then

          ArrayList.SetVal(list_cnt)    := pname;
          ArrayList.plcVal(list_cnt)    := list_cnt;
          ArrayList.useCHRVal(list_cnt) := TO_CHAR(pvalue);
          ArrayList.useOprVal(list_cnt) := validOpr;
          list_cnt := list_cnt + 1;

       end if;


end;

/*
     for dates
 */
PROCEDURE CreateList (pmode VARCHAR2 default 'dml', pname VARCHAR2 default null, pOpr VARCHAR2 default '=',  pvalue date default null,     List_cnt in out NUMBER, ArrayList IN OUT DynTbl)
is

vdate       date;
validOpr    VARCHAR2(100);

begin

 validOpr :=  CASE WHEN upper(pOpr) in ('=','!=','<>','<','>','>=','<=','LIKE') THEN pOpr ELSE '=' end;

       IF pvalue is not null  then

          if pmode = 'sel'  then
              VDATE := trunc(pvalue);
              ArrayList.SetVal(list_cnt) := 'to_char('||pname||',''MM/DD/YYYY'')';
              ArrayList.plcVal(list_cnt) := list_cnt;
              ArrayList.useChrVal(list_cnt) := to_char(vdate,'MM/DD/YYYY');
              ArrayList.useOprVal(list_cnt) := validOpr;
          elsif pmode = 'dml' then
              ArrayList.SetVal(list_cnt) := pname;
              ArrayList.plcVal(list_cnt) := list_cnt;
              VDATE := pvalue;
              ArrayList.useChrVal(list_cnt)  := 'TO_DATE('''||to_char(VDATE,'MM/DD/YYYY:HH:MI:SS')||''','''||'MM/DD/YYYY:HH:MI:SS'')';
              ArrayList.useOprVal(list_cnt) := validOpr;
          elsif pmode = 'ins' then
              ArrayList.SetVal(list_cnt) := pname;
              ArrayList.plcVal(list_cnt) := list_cnt;
              VDATE := pvalue;
              ArrayList.useChrVal(list_cnt)  := 'TO_DATE('''||to_char(VDATE,'MM/DD/YYYY:HH:MI:SS')||''','''||'MM/DD/YYYY:HH:MI:SS'')';
              ArrayList.useOprVal(list_cnt) := validOpr;

          end if;

          list_cnt := list_cnt + 1;

       end if;

end;


PROCEDURE LOAD_CLIENT_CODES
IS

GC     GenRefCursor;

SQL_STMT   VARCHAR2(32000 BYTE);
SQLROWCNT  number;

BEGIN
    SQL_STMT := 'SELECT CLIENT_CODE, SOURCES FROM LA_CLIENT_CODES ';

    OPEN GC FOR SQL_STMT;
            FETCH GC BULK COLLECT INTO codes.CLIENT_CODE, codes.SOURCES;
            SQLROWCNT := codes.CLIENT_CODE.COUNT;
    CLOSE GC;

END;



PROCEDURE LOAD_LA_FILES
IS

/********************************************************
    Process what has not been moved from stage to Work order lists
          LA_FILE_PROCESS.LOAD_LA_FILES;
 *********************************************************/
CURSOR C1
IS
select PID, FILE_TYPE, FILE_NAME, RECORDCNT, LOAD_DATE, LOADED_BY, COMMENTS, BEGIN_LOAD_ID, END_LOAD_ID, LOADED, PROCESS_NO
from  LA_FILES_LOADED_LIST
WHERE LOADED = 0;

R1  C1%ROWTYPE;

RAL         LA_RP;
RP          LA_RESOLUTION_PENDING;
GC          GenRefCursor;
SEL_STMT    VARCHAR2(32000 BYTE);
DEL_STMT    VARCHAR2(32000 BYTE);
UPD_STMT    VARCHAR2(32000 BYTE);
MSG         VARCHAR2(1000 BYTE);
cnt1        NUMBER(10);
max_id      number;
min_id      number;

/*

 */

BEGIN


OPEN C1;
    LOOP
    FETCH C1 INTO R1;
    EXIT WHEN C1%NOTFOUND;
     IF (R1.PROCESS_NO IN (1) )
        THEN
      /*
        ASSIGN  PID to stage table  ASSIGNING EACH RECORD To the File that was just loaded
      */
          IF   (R1.FILE_TYPE IN (1,8) )
            THEN
                  BEGIN

                      UPD_STMT := 'UPDATE LA_OUTSTANDING_ADJUSTED_STG set PID = :1 WHERE LOAD_ID BETWEEN :2 AND :3 ';

                      EXECUTE IMMEDIATE UPD_STMT USING  R1.PID, R1.BEGIN_LOAD_ID, R1.END_LOAD_ID;

                      cnt1  := SQL%ROWCOUNT;

                      COMMIT;

                      /*
                        move from stage to PENDING
                      */

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, 'from '||R1.FILE_NAME);
                              COMMIT;

                      /*
                         close out the queue record
                      */
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 1, RECORDCNT = cnt1 WHERE PID = R1.PID;

                            COMMIT;

                            DELETE FROM LA_OUTSTANDING_ADJUSTED_STG WHERE INVOICE_NBR IN ('BEGIN','END');
                            COMMIT;

                            LA_FILE_PROCESS.CONVERT_OUTSTANDING_ADJUSTED ( P_FILE_ID=>R1.PID);

                  EXCEPTION WHEN OTHERS THEN
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0 WHERE PID = R1.PID;
                            COMMIT;
                            MSG   := SQLERRM;
                           SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.LOAD_LA_FILES',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );
                  END;
          END IF;
/*************************************************************************
     file type 2  RESOLUTION PENDING
 *************************************************************************/
          IF  ( R1.FILE_TYPE IN (2,9) )
            THEN
                  BEGIN

                      UPD_STMT := 'UPDATE LA_RESOLUTION_PENDING_STG set PID = :1 WHERE LOAD_ID BETWEEN :2 AND :3 ';


                      EXECUTE IMMEDIATE UPD_STMT USING  R1.PID, R1.BEGIN_LOAD_ID, R1.END_LOAD_ID;

                      cnt1  := SQL%ROWCOUNT;

                      COMMIT;

                      /*
                        move from stage to PENDING
                      */

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, 'from '||R1.FILE_NAME);
                              COMMIT;

                      /*
                         close out the queue record
                      */
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 1, RECORDCNT = cnt1 WHERE PID = R1.PID;

                            COMMIT;

                            DELETE FROM LA_RESOLUTION_PENDING_STG WHERE INVOICE_NBR IN ('BEGIN','END');
                            COMMIT;


                            LA_FILE_PROCESS.CONVERT_RESOLUTION_PENDING ( P_FILE_ID=>R1.PID);

                  EXCEPTION WHEN OTHERS THEN
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0 WHERE PID = R1.PID;
                            COMMIT;
                            MSG   := SQLERRM;
                           SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.LOAD_LA_FILES',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );
                  END;
          END IF;

          IF  ( R1.FILE_TYPE IN (3) )
            THEN
                 BEGIN
                      UPD_STMT := 'UPDATE LA_PENDING_APPROVAL_STG set FILE_ID = :1 WHERE LOAD_ID BETWEEN :2 AND :3 ';


                      EXECUTE IMMEDIATE UPD_STMT USING  R1.PID, R1.BEGIN_LOAD_ID, R1.END_LOAD_ID;

                      cnt1  := SQL%ROWCOUNT;

                      COMMIT;

                      DELETE FROM LA_PENDING_APPROVAL_STG WHERE SERVICER IN ('BEGIN','END');

                      COMMIT;


                      /*
                        move from stage to PENDING
                      */

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, 'from '||R1.FILE_NAME);
                              COMMIT;

                      /*
                         close out the queue record
                      */
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 1, RECORDCNT = cnt1 WHERE PID = R1.PID;

                            COMMIT;


                         LA_FILE_PROCESS.CONVERT_PENDING_APPROVAL (P_FILE_ID=>R1.PID);


                 EXCEPTION WHEN OTHERS THEN

                    UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0 WHERE PID = R1.PID;
                    COMMIT;

                    MSG   := SQLERRM;


                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, MSG||' IS from '||R1.FILE_NAME);
                              COMMIT;



                    SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.LOAD_LA_FILES',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );

                 END;

          end if;

          IF  ( R1.FILE_TYPE IN (4) )
            THEN
                 BEGIN
                      UPD_STMT := 'UPDATE LA_PENDING_REJECTIONS_STG set FILE_ID = :1 WHERE LOAD_ID BETWEEN :2 AND :3 ';


                      EXECUTE IMMEDIATE UPD_STMT USING  R1.PID, R1.BEGIN_LOAD_ID, R1.END_LOAD_ID;

                      cnt1  := SQL%ROWCOUNT;

                      COMMIT;

                      DELETE FROM LA_PENDING_REJECTIONS_STG WHERE SERVICER IN ('BEGIN','END');

                      COMMIT;


                      /*
                        move from stage to PENDING
                      */

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, 'from '||R1.FILE_NAME);
                              COMMIT;

                      /*
                         close out the queue record
                      */
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 1, RECORDCNT = cnt1 WHERE PID = R1.PID;

                            COMMIT;


                         LA_FILE_PROCESS.CONVERT_PENDING_REJECTIONS (P_FILE_ID=>R1.PID);

                 EXCEPTION WHEN OTHERS THEN

                    UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0 WHERE PID = R1.PID;
                    COMMIT;

                    MSG   := SQLERRM;


                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, MSG||' IS from '||R1.FILE_NAME);
                              COMMIT;



                    SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.LOAD_LA_FILES',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );

                 END;

          end if;

          IF  ( R1.FILE_TYPE IN (5) )
            THEN
                 BEGIN
                      UPD_STMT := 'UPDATE LA_IR_ASSIGNMENT_STG set FILE_ID = :1 WHERE LOAD_ID BETWEEN :2 AND :3 ';


                      EXECUTE IMMEDIATE UPD_STMT USING  R1.PID, R1.BEGIN_LOAD_ID, R1.END_LOAD_ID;

                      cnt1  := SQL%ROWCOUNT;

                      COMMIT;

                      DELETE FROM LA_IR_ASSIGNMENT_STG A WHERE A.RECEIVED_DATE IN ('BEGIN','END');

                      COMMIT;


                      /*
                        move from stage to PENDING
                      */

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, 'from '||R1.FILE_NAME);
                              COMMIT;

                      /*
                         close out the queue record
                      */
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 1, RECORDCNT = cnt1 WHERE PID = R1.PID;

                            COMMIT;


                         LA_FILE_PROCESS.CONVERT_IR_ASSIGNMENT (P_FILE_ID=>R1.PID);

                 EXCEPTION WHEN OTHERS THEN

                    UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0 WHERE PID = R1.PID;
                    COMMIT;

                    MSG   := SQLERRM;


                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, MSG||' IS from '||R1.FILE_NAME);
                              COMMIT;



                    SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.LOAD_LA_FILES',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );

                 END;

          end if;

          IF  ( R1.FILE_TYPE IN (11) )
            THEN
                  BEGIN


                      EXECUTE IMMEDIATE 'TRUNCATE TABLE LA_VALIDATION DROP STORAGE';

                      UPD_STMT := 'UPDATE LA_VALIDATION_STG set FILE_ID = :1 WHERE LOAD_ID BETWEEN :2 AND :3 ';


                      EXECUTE IMMEDIATE UPD_STMT USING  R1.PID, R1.BEGIN_LOAD_ID, R1.END_LOAD_ID;

                      cnt1  := SQL%ROWCOUNT;

                      COMMIT;

                      /*
                        move from stage
                      */

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES',SYSDATE, cnt1, 'from '||R1.FILE_NAME);
                              COMMIT;

                      /*
                         close out the queue record
                      */
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 1, RECORDCNT = cnt1 WHERE PID = R1.PID;

                            COMMIT;


                            UPD_STMT := ' DELETE  LA_VALIDATION_STG WHERE LOAD_ID = :2 ';


                            EXECUTE IMMEDIATE UPD_STMT USING  R1.BEGIN_LOAD_ID;

                            EXECUTE IMMEDIATE UPD_STMT USING  R1.END_LOAD_ID;


                            insert into LA_VALIDATION(client_code,LA_HIGH,LA_LOW)
                            select   A.CLIENT_CODE, CASE WHEN A.H_LEN > 1 THEN   REPLACE(A.LA_HIGH,' ','.') END , CASE WHEN A.L_LEN > 1 THEN REPLACE(A.LA_LOW,' ','.') END
                            FROM ( SELECT CLIENT_CODE, LENGTH(NVL(LA_HIGH,0)) H_LEN, LA_HIGH, LENGTH(NVL(LA_LOW,0)) L_LEN, LA_LOW
                                   from LA_VALIDATION_STG
                                   WHERE FILE_ID = R1.PID)A;


                            COMMIT;

                            EXECUTE IMMEDIATE 'TRUNCATE TABLE LA_VALIDATION_STG DROP STORAGE';


                  EXCEPTION WHEN OTHERS THEN
                            UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0 WHERE PID = R1.PID;
                            COMMIT;
                            MSG   := SQLERRM;
                           SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.LOAD_LA_FILES',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );
                  END;
          END IF;
     END IF;
     IF (R1.PROCESS_NO IN (2) )
       THEN
       NULL;
     END IF;

    END LOOP;
CLOSE C1;
exception
     when others then
          cnt1  := sqlcode;
           msg  := sqlerrm;

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'LOAD_LA_FILES', SYSDATE, cnt1, msg);
        COMMIT;


    SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.LOAD_LA_FILES',P_SUBJECT=>'Procedure issue' ,P_MESSAGE=>MSG );

END;

/************************************************************

        RESOLUTION PENDING

*************************************************************/
PROCEDURE CONVERT_RESOLUTION_PENDING ( P_FILE_ID NUMBER)
is
  RAL         LA_RP;
  RP          LA_RESOLUTION_PENDING;
  GC          GenRefCursor;
  SEL_STMT    VARCHAR2(32000 BYTE);
  DEL_STMT    VARCHAR2(32000 BYTE);
  UPD_STMT    VARCHAR2(32000 BYTE);
  msg         VARCHAR2(1000 BYTE);
  CLIENT_TMP  VARCHAR2(100 BYTE);
  CLIENT_DATA VARCHAR2(100 BYTE);
  INVOICE_NBR VARCHAR2(100 BYTE);
  INVOICE_PRE VARCHAR2(100 BYTE);
  INVOICE_SUF VARCHAR2(100 BYTE);
  WORK_ORDER  VARCHAR2(100 BYTE);
  ACTION      VARCHAR2(100 BYTE);

  cnt1          NUMBER(10);
  cnt2          NUMBER(10);
  Y             PLS_INTEGER;
  W             PLS_INTEGER;
  Tot           PLS_INTEGER;
  C             PLS_INTEGER;
  I             PLS_INTEGER;

  PTR_START     PLS_INTEGER;
  PTR_END       PLS_INTEGER;

  LOAD_TMP      NUMBER(10);
  RCODE         NUMBER;
  MESSAGE       VARCHAR2(1000 BYTE);
  BAD_DATA      EXCEPTION;

FUNCTION FIND_THE_END
(
 P_BEGIN PLS_INTEGER
)
RETURN PLS_INTEGER
IS
S          PLS_INTEGER;

P_END      PLS_INTEGER;
C           VARCHAR2(100);

BEGIN

    C   := 'BEGIN';
    S   := P_BEGIN;

    WHILE ( C NOT IN ('END') )
   LOOP
       S   := S + 1;
       C   := RP.CLIENT(S);

   END LOOP;

   P_END   := S;
   RETURN P_END;

END;
----- lookup the client name


FUNCTION GET_CLIENT_NAME (P_NAME VARCHAR2) RETURN VARCHAR2
IS
     CLIENT_NAME VARCHAR2(100);
     CLIENT_SRC  VARCHAR2(200);
     MSG         VARCHAR2(200);
     FOUND_IT    NUMBER;
     LIST_CNT    NUMBER;
BEGIN
      FOUND_IT := 0;
      LIST_CNT := codes.client_code.count;
      CLIENT_NAME := 'NOT-FOUND';

          FOR i in 1..codes.client_code.count LOOP

               IF (P_NAME LIKE '%'||codes.sources(i)||'%' ) THEN
                   CLIENT_NAME := codes.client_code(i);
                   EXIT;
               end if;

                FOUND_IT := FOUND_IT + 1;
          END LOOP;

    RETURN CLIENT_NAME;

EXCEPTION WHEN OTHERS  THEN
   MSG  := SUBSTR(SQLERRM,1,200);
   CLIENT_NAME := MSG;

   RETURN CLIENT_NAME;

END;
----------- SET THE RESULTS
-----------------------------
PROCEDURE SET_CLIENT_NAME ( P_BEGIN PLS_INTEGER, P_END PLS_INTEGER, P_CLIENT VARCHAR2)
IS

BEGIN

   FOR X IN P_BEGIN..P_END LOOP

           RP.CLIENT(P_BEGIN) := 'DELETE';

       IF ( RP.INVOICE_NBR_SHORT(X) LIKE 'INVOICE%'  )
          THEN
            RP.CLIENT(X) := 'DELETE';
       ELSE
            RP.CLIENT(X)  := P_CLIENT;
       END IF;

   END LOOP;


END;


begin


          DEL_STMT := 'DELETE LA_RESOLUTION_PENDING_AUD WHERE PID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

          DEL_STMT := 'DELETE LA_RESOLUTION_PENDING WHERE PID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

              INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_RESOLUTION_PENDING',SYSDATE, 0, 'And the race is on..');
              COMMIT;


          SEL_STMT := 'SELECT CLIENT, ';
          SEL_STMT := SEL_STMT||' INVOICE_NBR,';
          SEL_STMT := SEL_STMT||' INVOICE_NBR_SHORT,';
          SEL_STMT := SEL_STMT||' ORDER_NBR,';
          SEL_STMT := SEL_STMT||' VENDOR_CONTACT,';
          SEL_STMT := SEL_STMT||' LOAN_NBR,';
          SEL_STMT := SEL_STMT||' INVOICE_DATE,  ';
          SEL_STMT := SEL_STMT||' DEPT,';
          SEL_STMT := SEL_STMT||' STATE, ';
          SEL_STMT := SEL_STMT||' RESOLUTION_TYPE,';
          SEL_STMT := SEL_STMT||' INVOICE_AMT,';
          SEL_STMT := SEL_STMT||' VENDOR_COMMENT,';
          SEL_STMT := SEL_STMT||' VENDOR_DATE,';
          SEL_STMT := SEL_STMT||' CLIENT_COMMENT,';
          SEL_STMT := SEL_STMT||' CLIENT_DATE,';
          SEL_STMT := SEL_STMT||' REASON,';
          SEL_STMT := SEL_STMT||' RESOLUTION_DEADLINE,';
          SEL_STMT := SEL_STMT||' CURTAIL_DATE, ';
          SEL_STMT := SEL_STMT||' PID, ';
          SEL_STMT := SEL_STMT||' LOAD_ID ';
          SEL_STMT := SEL_STMT||' FROM ( SELECT ''NOT-ASSIGNED'' AS CLIENT,';
          SEL_STMT := SEL_STMT||' INVOICE_NBR,';
          SEL_STMT := SEL_STMT||' REPLACE(UPPER(LTRIM(INVOICE_NBR)),''&'',''^'')  INVOICE_NBR_SHORT,';
          SEL_STMT := SEL_STMT||' ORDER_NBR,';
          SEL_STMT := SEL_STMT||' VENDOR_CONTACT,';
          SEL_STMT := SEL_STMT||' LOAN_NBR, ';
          SEL_STMT := SEL_STMT||' INVOICE_DATE,';
          SEL_STMT := SEL_STMT||' DEPT,';
          SEL_STMT := SEL_STMT||' STATE, ';
          SEL_STMT := SEL_STMT||' RESOLUTION_TYPE,';
          SEL_STMT := SEL_STMT||' INVOICE_AMT,';
          SEL_STMT := SEL_STMT||' VENDOR_COMMENT, ';
          SEL_STMT := SEL_STMT||' VENDOR_DATE,';
          SEL_STMT := SEL_STMT||' CLIENT_COMMENT,';
          SEL_STMT := SEL_STMT||' CLIENT_DATE,';
          SEL_STMT := SEL_STMT||' REASON,';
          SEL_STMT := SEL_STMT||' RESOLUTION_DEADLINE,';
          SEL_STMT := SEL_STMT||' CURTAIL_DATE,';
          SEL_STMT := SEL_STMT||' PID,';
          SEL_STMT := SEL_STMT||' LOAD_ID';
          SEL_STMT := SEL_STMT||' FROM LA_RESOLUTION_PENDING_STG';
          SEL_STMT := SEL_STMT||' WHERE INVOICE_NBR IS NOT NULL  ';
          SEL_STMT := SEL_STMT||'  And   PID = :1 ) ';
          SEL_STMT := SEL_STMT||' ORDER BY LOAD_ID ';
OPEN GC FOR SEL_STMT USING P_FILE_ID;

        FETCH GC BULK COLLECT INTO  RP.CLIENT,
                                    RP.INVOICE_NBR,
                                    RP.INVOICE_NBR_SHORT,
                                    RP.ORDER_NBR,
                                    RP.VENDOR_CONTACT,
                                    RP.LOAN_NBR,
                                    RP.INVOICE_DATE,
                                    RP.DEPT,
                                    RP.STATE,
                                    RP.RESOLUTION_TYPE,
                                    RP.INVOICE_AMT,
                                    RP.VENDOR_COMMENT,
                                    RP.VENDOR_DATE,
                                    RP.CLIENT_COMMENT,
                                    RP.CLIENT_DATE,
                                    RP.REASON,
                                    RP.RESOLUTION_DEADLINE,
                                    RP.CURTAIL_DATE,
                                    RP.PID,
                                    RP.LOAD_ID;
          Tot := RP.PID.COUNT;
CLOSE GC;
/*
 LA_RP  IS RECORD (
LOAD_ID      DBMS_SQL.NUMBER_TABLE,
CLIENT       DBMS_SQL.VARCHAR2_TABLE,
Invoice_nbr  DBMS_SQL.VARCHAR2_TABLE
*/


I := 1;
Y := 0;

         FOR X IN 1..Tot LOOP
             IF ( RP.INVOICE_NBR_SHORT(X) LIKE 'INVOICE%'  )
             THEN
--                     RAL.LOAD_ID(I)      := RP.LOAD_ID(Y);
                       RP.CLIENT(Y)       := 'BEGIN';
--                     RAL.INVOICE_NBR(I)  := RP.INVOICE_NBR(Y);
--                     I := I +1;

             END IF;

             IF ( RP.INVOICE_NBR_SHORT(x) LIKE  'COUNT%' )
             THEN
---                     RAL.LOAD_ID(I)      := RP.LOAD_ID(Y);
                        RP.CLIENT(Y)       := 'END';
                        RP.INVOICE_NBR(x)  := 'DELETE';

             END IF;

              Y := Y + 1;

             IF ( RP.INVOICE_NBR_SHORT(x) LIKE  'GRAND TOTAL COUNT%' )
             THEN
                            RP.CLIENT(X) := 'DELETE';
             END IF;
         END LOOP;

--I := I -1;
              INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_RESOLUTION_PENDING',SYSDATE, y, 'FIRST LOOP');
              COMMIT;

--2092-NOT-ASSIGNED-Bank of America, N.A. (COUNTRY) Plano, TX

         FOR X IN 1..Tot LOOP
                    IF ( RP.CLIENT(X) = 'BEGIN'  )
                    THEN
--                       GET_CLIENT_NAME (RP.INVOICE_NBR_SHORT(X));
                       CLIENT_TMP := GET_CLIENT_NAME (RP.INVOICE_NBR_SHORT(X));

                       PTR_START := X;

                       PTR_END   := FIND_THE_END(X);

--                       IF (CLIENT_TMP  NOT IN ('NOT-FOUND') ) THEN
--                           RP.INVOICE_NBR_SHORT(X) := 'DELETE';
--                       END IF;

                       SET_CLIENT_NAME ( PTR_START, PTR_END, CLIENT_TMP);


                    END IF;

         END LOOP;

         FOR X IN 1..Tot LOOP

                   RP.INVOICE_AMT(x) := TRIM(TRANSLATE(RP.INVOICE_AMT(x), '"',' '));
                   RP.VENDOR_COMMENT(x) := TRIM(TRANSLATE(RP.VENDOR_COMMENT(x), '"',' '));                    
                                               
            END LOOP;

           FOR X IN 1..Tot LOOP

                IF (RP.CLIENT(X) IN ('DELETE','BEGIN','END') OR RP.INVOICE_NBR(X) IN ('DELETE'))
                   THEN
                        ACTION := 'DELETE';
                ELSE
                        ACTION := 'UPDATE';
                END IF;

                IF ( ACTION IN ('UPDATE')  )
                   THEN

                   BEGIN

                         INSERT INTO LA_RESOLUTION_PENDING ( CLIENT, LPS_ICLEAR,INVOICE_NBR,ORDER_NBR,VENDOR_CONTACT,LOAN_NBR,INVOICE_DATE,DEPT,STATE,RESOLUTION_TYPE,INVOICE_AMT,VENDOR_COMMENT,VENDOR_DATE,CLIENT_COMMENT,CLIENT_DATE,REASON,RESOLUTION_DEADLINE,CURTAIL_DATE,PID,LOAD_ID)
                         VALUES ( RP.CLIENT(x),
                                  RP.INVOICE_NBR_SHORT(x),
                                  LA_FILE_PROCESS.clean_invoice_nbr( RP.INVOICE_NBR_SHORT(x)),
                                  LA_FILE_PROCESS.clean_order_nbr( RP.ORDER_NBR(x)),
                                  RP.VENDOR_CONTACT(x),
                                  RP.LOAN_NBR(x),
                                  LA_FILE_PROCESS.DATE_REFORMAT(RP.INVOICE_DATE(x)),
                                  RP.DEPT(x),
                                  RP.STATE(x),
                                  RP.RESOLUTION_TYPE(x),
                                  RP.INVOICE_AMT(x),
                                  RP.VENDOR_COMMENT(x),
                                  LA_FILE_PROCESS.DATE_REFORMAT(RP.VENDOR_DATE(x)),
                                  RP.CLIENT_COMMENT(x),
                                  LA_FILE_PROCESS.DATE_REFORMAT(RP.CLIENT_DATE(x)),
                                  RP.REASON(x),
                                  LA_FILE_PROCESS.DATE_REFORMAT(RP.RESOLUTION_DEADLINE(x)),
                                  LA_FILE_PROCESS.DATE_REFORMAT(RP.CURTAIL_DATE(x)),
                                  RP.PID(x),
                                  RP.LOAD_ID(x));


                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(RP.INVOICE_DATE(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(RP.VENDOR_DATE(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(RP.CLIENT_DATE(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(RP.RESOLUTION_DEADLINE(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(RP.CURTAIL_DATE(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                     EXCEPTION
                            WHEN BAD_DATA THEN

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_RESOLUTION_PENDING',SYSDATE, Tot, 'DATE VALIDATION ISSUE');
                              COMMIT;

                              SEND_EMAIL  ( P_TEAM=> 'RDM', P_FROM=>'CONVERT_RESOLUTION_PENDING', P_SUBJECT=>'DATE VALIDATION ISSUE FILE '||RP.PID(X),  P_MESSAGE=> 'WE can not continue');



                            WHEN OTHERS THEN

                                RCODE   := SQLCODE;
                                MESSAGE := SQLERRM;

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;


                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_RESOLUTION_PENDING',SYSDATE, RCODE, MESSAGE);
                              COMMIT;


                     END;


                     COMMIT;


                END IF;

                   INSERT INTO LA_RESOLUTION_PENDING_AUD ( ACTION_TAKEN,INVOICE_NBR,ORDER_NBR,VENDOR_CONTACT,LOAN_NBR,INVOICE_DATE,DEPT,STATE,RESOLUTION_TYPE,INVOICE_AMT,VENDOR_COMMENT,VENDOR_DATE,CLIENT_COMMENT,CLIENT_DATE,REASON,RESOLUTION_DEADLINE,CURTAIL_DATE,PID,LOAD_ID)
                   SELECT ACTION,INVOICE_NBR,ORDER_NBR,VENDOR_CONTACT,LOAN_NBR,INVOICE_DATE,DEPT,STATE,RESOLUTION_TYPE,INVOICE_AMT,VENDOR_COMMENT,VENDOR_DATE,CLIENT_COMMENT,CLIENT_DATE,REASON,RESOLUTION_DEADLINE,CURTAIL_DATE,PID,LOAD_ID
                   FROM LA_RESOLUTION_PENDING_STG
                   WHERE PID = RP.PID(x)
                   AND   LOAD_ID = RP.LOAD_ID(x);

                   COMMIT;

           end LOOP;


              INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_RESOLUTION_PENDING',SYSDATE, Tot, ' records Reviewed');
              COMMIT;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 2, RECORDCNT = tot WHERE PID = P_FILE_ID;

              COMMIT;


exception
     when others then
          cnt1  := sqlcode;
           msg  := sqlerrm;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
               WHERE PID = P_FILE_ID;

              COMMIT;

              SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.CONVERT_RESOLUTION_PENDING',P_SUBJECT=>'Procedure issue' ,P_MESSAGE=>MSG );

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'CONVERT_RESOLUTION_PENDING', SYSDATE, cnt1, msg);
        COMMIT;

end;
/************************************************************

       OUTSTANDING ADJUSTED

*************************************************************/
PROCEDURE CONVERT_OUTSTANDING_ADJUSTED ( P_FILE_ID NUMBER)
IS

  OA          LA_OUTSTANDING_ADJUSTED;
  GC          GenRefCursor;
  SEL_STMT    VARCHAR2(32000 BYTE);
  DEL_STMT    VARCHAR2(32000 BYTE);
  UPD_STMT    VARCHAR2(32000 BYTE);
  msg         VARCHAR2(1000 BYTE);
  CLIENT_TMP  VARCHAR2(100 BYTE);
  CLIENT_DATA VARCHAR2(100 BYTE);
  INVOICE_NBR VARCHAR2(100 BYTE);
  INVOICE_PRE VARCHAR2(100 BYTE);
  INVOICE_SUF VARCHAR2(100 BYTE);
  WORK_ORDER  VARCHAR(100 BYTE);
  ACTION      VARCHAR2(100 BYTE);
  Adjust_total  number;
  cnt1          NUMBER(10);
  cnt2          NUMBER(10);
  Y             PLS_INTEGER;
  W             PLS_INTEGER;
  Tot           PLS_INTEGER;
  C             PLS_INTEGER;
  I             PLS_INTEGER;

  PTR_START     PLS_INTEGER;
  PTR_END       PLS_INTEGER;

  LOAD_TMP      NUMBER(10);
  RCODE         NUMBER;
  MESSAGE       VARCHAR2(1000 BYTE);
  BAD_DATA      EXCEPTION;


FUNCTION FIND_THE_END
(
 P_BEGIN PLS_INTEGER
)
RETURN PLS_INTEGER
IS
S          PLS_INTEGER;

P_END      PLS_INTEGER;
C           VARCHAR2(100);

BEGIN

    C   := 'BEGIN';
    S   := P_BEGIN;

    WHILE ( C NOT IN ('END') )
   LOOP
       S   := S + 1;
       C   := OA.CLIENT(S);

   END LOOP;

   P_END   := S;
   RETURN P_END;

END;

FUNCTION GET_CLIENT_NAME (P_NAME VARCHAR2) RETURN VARCHAR2
IS
     CLIENT_NAME VARCHAR2(100);
     CLIENT_SRC  VARCHAR2(100);

     FOUND_IT    NUMBER;
     LIST_CNT    NUMBER;
BEGIN
      FOUND_IT := 0;
      LIST_CNT := codes.client_code.count;
      CLIENT_NAME := 'NOT-FOUND';

          FOR i in 1..codes.client_code.count LOOP

               IF (P_NAME LIKE '%'||codes.sources(i)||'%' ) THEN
                   CLIENT_NAME := codes.client_code(i);
                   EXIT;
               end if;
                FOUND_IT := FOUND_IT + 1;
          END LOOP;

    RETURN CLIENT_NAME;

EXCEPTION WHEN OTHERS  THEN
   RETURN CLIENT_NAME;

END;
----------- SET THE RESULTS
-----------------------------
PROCEDURE SET_CLIENT_NAME ( P_BEGIN PLS_INTEGER, P_END PLS_INTEGER, P_CLIENT VARCHAR2)
IS

BEGIN

   FOR X IN P_BEGIN..P_END LOOP

           OA.CLIENT(P_BEGIN) := 'DELETE';

       IF ( OA.INVOICE_NBR_SHORT(X) LIKE 'INVOICE%'  )
          THEN
            OA.CLIENT(X) := 'DELETE';
       ELSE
            OA.CLIENT(X)  := P_CLIENT;
       END IF;

   END LOOP;


END;

begin
             INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_OUTSTANDING_ADJUSTED',SYSDATE, 0, 'And the race is on..');
              COMMIT;

          DEL_STMT := 'DELETE LA_OUTSTANDING_ADJUSTED_AUD WHERE PID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

          DEL_STMT := 'DELETE LA_OUTSTANDING_ADJUSTED WHERE PID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;



          SEL_STMT := 'SELECT CLIENT, ';
          SEL_STMT := SEL_STMT||' INVOICE_NBR,';
          SEL_STMT := SEL_STMT||' INVOICE_NBR_SHORT,';
          SEL_STMT := SEL_STMT||' Order_nbr,';
          SEL_STMT := SEL_STMT||' VENDOR,';
          SEL_STMT := SEL_STMT||' VENDOR_CONTACT,';
          SEL_STMT := SEL_STMT||' LOAN_NBR, ';
          SEL_STMT := SEL_STMT||' INVOICE_DATE,';
          SEL_STMT := SEL_STMT||' DEPT,';
          SEL_STMT := SEL_STMT||' STATE, ';
          SEL_STMT := SEL_STMT||' BORROWER,';
          SEL_STMT := SEL_STMT||' Invoice_amt,';
          SEL_STMT := SEL_STMT||' Dispute_amt,';
          SEL_STMT := SEL_STMT||' ADJUSTED_TOTAL,';
          SEL_STMT := SEL_STMT||' EARLIEST_ADJ_DT,';
          SEL_STMT := SEL_STMT||' CURTAIL_DATE,';
          SEL_STMT := SEL_STMT||' PID,';
          SEL_STMT := SEL_STMT||' LOAD_ID';
          SEL_STMT := SEL_STMT||' FROM ( SELECT ''NOT-ASSIGNED'' AS CLIENT,';
          SEL_STMT := SEL_STMT||' INVOICE_NBR,';
          SEL_STMT := SEL_STMT||' REPLACE(UPPER(LTRIM(INVOICE_NBR)),''&'',''^'')  INVOICE_NBR_SHORT,';
          SEL_STMT := SEL_STMT||' NULL AS Order_nbr,';
          SEL_STMT := SEL_STMT||' VENDOR,';
          SEL_STMT := SEL_STMT||' VENDOR_CONTACT,';
          SEL_STMT := SEL_STMT||' LOAN_NBR, ';
          SEL_STMT := SEL_STMT||' INVOICE_DATE,';
          SEL_STMT := SEL_STMT||' DEPT,';
          SEL_STMT := SEL_STMT||' STATE, ';
          SEL_STMT := SEL_STMT||' BORROWER,';
          SEL_STMT := SEL_STMT||' ADJUSTED_TOTAL as Invoice_amt,';
          SEL_STMT := SEL_STMT||' ADJUSTED_TOTAL as Dispute_amt,';
          SEL_STMT := SEL_STMT||' ADJUSTED_TOTAL,';
          SEL_STMT := SEL_STMT||' EARLIEST_ADJ_DT,';
          SEL_STMT := SEL_STMT||' CURTAIL_DATE,';
          SEL_STMT := SEL_STMT||' PID,';
          SEL_STMT := SEL_STMT||' LOAD_ID';
          SEL_STMT := SEL_STMT||' FROM LA_OUTSTANDING_ADJUSTED_STG';
          SEL_STMT := SEL_STMT||' WHERE INVOICE_NBR IS NOT NULL';
          SEL_STMT := SEL_STMT||'  And   PID = :1 ) ';
          SEL_STMT := SEL_STMT||' ORDER BY LOAD_ID ';
OPEN GC FOR SEL_STMT USING P_FILE_ID;

/*
TYPE LA_OUTSTANDING_ADJUSTED IS RECORD (
      Client              DBMS_SQL.VARCHAR2_TABLE,
      Invoice_nbr         DBMS_SQL.VARCHAR2_TABLE,
      INVOICE_NBR_SHORT   DBMS_SQL.VARCHAR2_TABLE,
      Order_nbr           DBMS_SQL.VARCHAR2_TABLE,
      Vendor              DBMS_SQL.VARCHAR2_TABLE,
      Vendor_Contact      DBMS_SQL.VARCHAR2_TABLE,
      Loan_nbr            DBMS_SQL.VARCHAR2_TABLE,
      Invoice_Date        DBMS_SQL.VARCHAR2_TABLE,
      Dept                DBMS_SQL.VARCHAR2_TABLE,
      State               DBMS_SQL.VARCHAR2_TABLE,
      BORROWER            DBMS_SQL.VARCHAR2_TABLE,
      Invoice_amt         DBMS_SQL.VARCHAR2_TABLE,
      Dispute_amt         DBMS_SQL.VARCHAR2_TABLE,
      Adjusted_total      DBMS_SQL.VARCHAR2_TABLE,
      Earliest_Adj_Dt     DBMS_SQL.VARCHAR2_TABLE,
      Curtail_Date        DBMS_SQL.VARCHAR2_TABLE,
      pid                 DBMS_SQL.NUMBER_TABLE,
      LOAD_ID             DBMS_SQL.NUMBER_TABLE
);

 */


        FETCH GC BULK COLLECT INTO  OA.CLIENT,
                                    OA.INVOICE_NBR,
                                    OA.INVOICE_NBR_SHORT,
                                    OA.Order_nbr,
                                    OA.VENDOR,
                                    OA.VENDOR_CONTACT,
                                    OA.LOAN_NBR,
                                    OA.INVOICE_DATE,
                                    OA.DEPT,
                                    OA.STATE,
                                    OA.BORROWER,
                                    OA.Invoice_amt,
                                    OA.Dispute_amt,
                                    OA.ADJUSTED_TOTAL,
                                    OA.EARLIEST_ADJ_DT,
                                    OA.CURTAIL_DATE,
                                    OA.PID,
                                    OA.LOAD_ID;
          Tot := OA.PID.COUNT;
CLOSE GC;

I := 1;
Y := 0;

         FOR X IN 1..Tot LOOP
             IF ( OA.INVOICE_NBR_SHORT(X) LIKE 'INVOICE%'  )
             THEN
--                     RAL.LOAD_ID(I)      := OA.LOAD_ID(Y);
                       OA.CLIENT(Y)       := 'BEGIN';
--                     RAL.INVOICE_NBR(I)  := OA.INVOICE_NBR(Y);
--                     I := I +1;

             END IF;

             IF ( OA.INVOICE_NBR_SHORT(x) LIKE  'COUNT%' )
             THEN
---                     RAL.LOAD_ID(I)      := OA.LOAD_ID(Y);
                        OA.CLIENT(Y)       := 'END';
                        OA.INVOICE_NBR(x)  := 'DELETE';
                        OA.CLIENT(x)       := 'DELETE';
             END IF;

              Y := Y + 1;

             IF ( OA.INVOICE_NBR_SHORT(x) LIKE  'GRAND TOTAL COUNT%' )
             THEN
                            OA.CLIENT(X) := 'DELETE';
             END IF;
         END LOOP;

--I := I -1;
              INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_OUTSTANDING_ADJUSTED',SYSDATE, y, 'FIRST LOOP');
              COMMIT;

--2092-NOT-ASSIGNED-Bank of America, N.A. (COUNTRY) Plano, TX

         FOR X IN 1..Tot LOOP
                    IF ( OA.CLIENT(X) = 'BEGIN'  )
                    THEN
--                       GET_CLIENT_NAME (OA.INVOICE_NBR_SHORT(X));
                       CLIENT_TMP := GET_CLIENT_NAME (OA.INVOICE_NBR_SHORT(X));

                       PTR_START := X;

                       PTR_END   := FIND_THE_END(X);

--                       IF (CLIENT_TMP  NOT IN ('NOT-FOUND') ) THEN
--                           OA.INVOICE_NBR_SHORT(X) := 'DELETE';
--                       END IF;

                       SET_CLIENT_NAME ( PTR_START, PTR_END, CLIENT_TMP);


                    END IF;

         END LOOP;




         FOR X IN 1..Tot LOOP

          --INVOICE_NBR

                   OA.ADJUSTED_TOTAL(x) := TRIM(TRANSLATE(OA.ADJUSTED_TOTAL(x), '"',' '));

                   INVOICE_NBR := OA.INVOICE_NBR_SHORT(x);
                   WORK_ORDER  := NULL;

                        -------- JUST NUMBERS   0123456789
                   IF (OA.CLIENT(X) NOT IN ('DELETE') AND OA.INVOICE_NBR(X) NOT IN ('DELETE'))
                       THEN
                            IF (LENGTH(TRIM(TRANSLATE(OA.INVOICE_NBR_SHORT(X), '0123456789',' ')))  IS NULL)
                                THEN
                                  INVOICE_NBR := OA.INVOICE_NBR_SHORT(x);
                            END IF;
                       ----------- THERE IS A DASH (-) NUMBER 00123456789  SO SPLIT
                       -------- Invoice-workorder
                      IF  (INSTR(OA.INVOICE_NBR_SHORT(x),'-') > 0 ) THEN

--                            IF  (LENGTH(TRIM(TRANSLATE(OA.INVOICE_NBR_SHORT(x), '-0123456789',' '))) IS NULL)
--                                THEN
                                   INVOICE_NBR := SUBSTR(OA.INVOICE_NBR_SHORT(x),1,(INSTR(OA.INVOICE_NBR_SHORT(x),'-') - 1));
                                   WORK_ORDER  := SUBSTR(OA.INVOICE_NBR_SHORT(x),(INSTR(OA.INVOICE_NBR_SHORT(x),'-') + 1));
--                            END IF;

--                            IF (LENGTH(TRIM(TRANSLATE(OA.INVOICE_NBR_SHORT(x), '-0123456789',' '))) IS NOT NULL )
--                             THEN
                                --- ABC   plus   0123456789
--                               INVOICE_PRE := SUBSTR(OA.INVOICE_NBR_SHORT(x),1,(INSTR(OA.INVOICE_NBR_SHORT(x),'-') - 1));
                                --- 0123456789  and  0123456789ABC
--                               INVOICE_SUF := SUBSTR(OA.INVOICE_NBR_SHORT(x),(INSTR(OA.INVOICE_NBR_SHORT(x),'-') + 1));
                               -----------
--                                 IF ( LENGTH(TRIM(TRANSLATE(INVOICE_PRE, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '))) IS NULL )
--                                  THEN
--                                       INVOICE_NBR := TRIM(TRANSLATE(INVOICE_SUF,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
--                                  else
--                                       INVOICE_NBR := TRIM(TRANSLATE(INVOICE_PRE,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
--                                       WORK_ORDER  := TRIM(TRANSLATE(INVOICE_SUF,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
--                                 END IF;

--                            END IF;

                           OA.order_nbr(x) :=  WORK_ORDER;
                           OA.INVOICE_NBR_SHORT(x) := INVOICE_NBR;


                      END IF;


                          Adjust_total := REPLACE(REPLACE(OA.ADJUSTED_TOTAL(x),'$',''),',','');
                          OA.Dispute_amt(x) := OA.ADJUSTED_TOTAL(x);
                          OA.invoice_amt(x) := to_char((2 * Adjust_total), '$9,999,999.99');


                   END IF;


         END LOOP;

           FOR X IN 1..Tot LOOP

                IF (OA.CLIENT(X) IN ('DELETE') OR OA.INVOICE_NBR(X) IN ('DELETE'))
                   THEN
                        ACTION := 'DELETE';
                ELSE
                        ACTION := 'UPDATE';
                END IF;

                IF ( ACTION IN ('UPDATE')  )
                   THEN
                   BEGIN
                   INSERT INTO LA_OUTSTANDING_ADJUSTED (    CLIENT,       INVOICE_NBR,        VENDOR_CONTACT,   WORKORDER_NBR,      LOAN_NBR,      INVOICE_DATE,      DEPT,      STATE,      BORROWER,   INVOICE_AMT,         DISPUTE_AMT,      ADJUSTED_TOTAL,       EARLIEST_ADJ_DT,      CURTAIL_DATE,      PID,      LOAD_ID )
                                                VALUES ( OA.CLIENT(x),
                                                         OA.INVOICE_NBR_SHORT(x),
                                                         OA.VENDOR_CONTACT(x),
                                                         OA.Order_nbr(x),
                                                         OA.LOAN_NBR(x),
                                                         LA_FILE_PROCESS.DATE_REFORMAT(OA.INVOICE_DATE(x)),
                                                         OA.DEPT(x),
                                                         OA.STATE(x),
                                                         OA.BORROWER(x),
                                                         OA.invoice_amt(x),
                                                         OA.Dispute_amt(x),
                                                         OA.ADJUSTED_TOTAL(x),
                                                         LA_FILE_PROCESS.DATE_REFORMAT(OA.EARLIEST_ADJ_DT(x)),
                                                         LA_FILE_PROCESS.DATE_REFORMAT(OA.CURTAIL_DATE(x)),
                                                         OA.PID(x),
                                                         OA.LOAD_ID(x));


                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(OA.INVOICE_DATE(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;


                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(OA.EARLIEST_ADJ_DT(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(OA.CURTAIL_DATE(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                   EXCEPTION
                            WHEN BAD_DATA THEN

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_OUTSTANDING_ADJUSTED',SYSDATE, Tot, 'DATE VALIDATION ISSUE');
                              COMMIT;

                              SEND_EMAIL  ( P_TEAM=> 'RDM', P_FROM=>'CONVERT_OUTSTANDING_ADJUSTED', P_SUBJECT=>'DATE VALIDATION ISSUE FILE '||OA.PID(X),  P_MESSAGE=> 'WE can not continue');



                            WHEN OTHERS THEN

                                RCODE   := SQLCODE;
                                MESSAGE := SQLERRM;

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;


                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_OUTSTANDING_ADJUSTED',SYSDATE, RCODE, MESSAGE);
                              COMMIT;


                   END;



                   COMMIT;

                END IF;

                   INSERT INTO LA_OUTSTANDING_ADJUSTED_AUD ( ACTION_TAKEN,  CLIENT,     INVOICE_NBR, VENDOR, VENDOR_CONTACT, LOAN_NBR, INVOICE_DATE, DEPT, STATE,BORROWER,  ADJUSTED_TOTAL,  EARLIEST_ADJ_DT, CURTAIL_DATE, PID, LOAD_ID )
                                                      SELECT ACTION,     OA.CLIENT(x),  INVOICE_NBR, VENDOR, VENDOR_CONTACT, LOAN_NBR, INVOICE_DATE, DEPT, STATE, BORROWER, ADJUSTED_TOTAL,  EARLIEST_ADJ_DT, CURTAIL_DATE, PID, LOAD_ID
                   FROM LA_OUTSTANDING_ADJUSTED_STG
                   WHERE PID = OA.PID(x)
                   AND   LOAD_ID = OA.LOAD_ID(x);

                   COMMIT;

           end LOOP;


              INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_OUTSTANDING_ADJUSTED',SYSDATE, Tot, ' records Reviewed');
              COMMIT;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 2, RECORDCNT = tot WHERE PID = P_FILE_ID;

              COMMIT;


exception
     when others then
          cnt1  := sqlcode;
           msg  := sqlerrm;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
               WHERE PID = P_FILE_ID;

              COMMIT;

              SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.CONVERT_OUTSTANDING_ADJUSTED',P_SUBJECT=>'Procedure issue' ,P_MESSAGE=>MSG );

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'CONVERT_OUTSTANDING_ADJUSTED', SYSDATE, cnt1, msg);
        COMMIT;
END;
/************************************************************

       PENDING APPROVAL

*************************************************************/
PROCEDURE CONVERT_PENDING_APPROVAL ( P_FILE_ID NUMBER)
IS

  PA          LA_PENDING_APPROVAL;
  GC          GenRefCursor;
  SEL_STMT    VARCHAR2(32000 BYTE);
  DEL_STMT    VARCHAR2(32000 BYTE);
  UPD_STMT    VARCHAR2(32000 BYTE);
  msg         VARCHAR2(1000 BYTE);
  CLIENT_TMP  VARCHAR2(100 BYTE);
  CLIENT_DATA VARCHAR2(100 BYTE);
  INVOICE_NBR VARCHAR2(100 BYTE);
  INVOICE_PRE VARCHAR2(100 BYTE);
  INVOICE_SUF VARCHAR2(100 BYTE);
  WORK_ORDER  VARCHAR(100 BYTE);
  ACTION      VARCHAR2(100 BYTE);
  Adjust_total  number;
  cnt1          NUMBER(10);
  cnt2          NUMBER(10);
  Y             PLS_INTEGER;
  W             PLS_INTEGER;
  Tot           PLS_INTEGER;
  C             PLS_INTEGER;
  I             PLS_INTEGER;

  PTR_START     PLS_INTEGER;
  PTR_END       PLS_INTEGER;

  LOAD_TMP      NUMBER(10);
  RCODE         NUMBER;
  MESSAGE       VARCHAR2(1000 BYTE);
  BAD_DATA      EXCEPTION;

FUNCTION FIND_THE_END
(
 P_BEGIN PLS_INTEGER
)
RETURN PLS_INTEGER
IS
S          PLS_INTEGER;

P_END      PLS_INTEGER;
C           VARCHAR2(100);

BEGIN

    C   := 'BEGIN';
    S   := P_BEGIN;

    WHILE ( C NOT IN ('END') )
   LOOP
       S   := S + 1;
       C   := PA.CLIENT(S);

   END LOOP;

   P_END   := S;
   RETURN P_END;

END;

FUNCTION GET_CLIENT_NAME (P_NAME VARCHAR2) RETURN VARCHAR2
IS
     CLIENT_NAME VARCHAR2(100);
     CLIENT_SRC  VARCHAR2(100);

     FOUND_IT    NUMBER;
     LIST_CNT    NUMBER;
BEGIN
      FOUND_IT := 0;
      LIST_CNT := codes.client_code.count;
      CLIENT_NAME := 'NOT-ASSIGNED';

          FOR i in 1..codes.client_code.count LOOP

               IF (P_NAME LIKE '%'||codes.sources(i)||'%' ) THEN
                   CLIENT_NAME := codes.client_code(i);
                   EXIT;
               end if;
                FOUND_IT := FOUND_IT + 1;
          END LOOP;

    RETURN CLIENT_NAME;

EXCEPTION WHEN OTHERS  THEN
   RETURN CLIENT_NAME;

END;
----------- SET THE RESULTS
-----------------------------
PROCEDURE SET_CLIENT_NAME ( P_BEGIN PLS_INTEGER, P_END PLS_INTEGER, P_CLIENT VARCHAR2)
IS

BEGIN

   FOR X IN P_BEGIN..P_END LOOP

            PA.CLIENT(X)  := P_CLIENT;

   END LOOP;


END;

begin
             INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_APPROVAL',SYSDATE, 0, 'And the race is on..');
              COMMIT;

          DEL_STMT := 'DELETE LA_PENDING_APPROVAL_AUD WHERE FILE_ID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

          DEL_STMT := 'DELETE LA_PENDING_APPROVAL WHERE FILE_ID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

          SEL_STMT := ' SELECT CLIENT, ';
          SEL_STMT := SEL_STMT||' SERVICER,';
          SEL_STMT := SEL_STMT||' LOAN_NBR,';
          SEL_STMT := SEL_STMT||' ORDER_NBR,';
          SEL_STMT := SEL_STMT||' INVOICE_TYPE,';
          SEL_STMT := SEL_STMT||' INVOICE_DATE,';
          SEL_STMT := SEL_STMT||' INVOICE_NBR,';
          SEL_STMT := SEL_STMT||' INVOICE_AMT, ';
          SEL_STMT := SEL_STMT||' STATE,';
          SEL_STMT := SEL_STMT||' LI_CODE,';
          SEL_STMT := SEL_STMT||' LI_DESCRIPTION,';
          SEL_STMT := SEL_STMT||' LI_AMT,';
          SEL_STMT := SEL_STMT||' ADJUSTED_AMT,';
          SEL_STMT := SEL_STMT||' TOTAL_LI_AMOUNT,';
          SEL_STMT := SEL_STMT||' REASON,';
          SEL_STMT := SEL_STMT||' COMMENTS_DATE,';
          SEL_STMT := SEL_STMT||' EXPIRES_IN,';
          SEL_STMT := SEL_STMT||' LOAD_ID,';
          SEL_STMT := SEL_STMT||' FILE_ID FROM(';
          SEL_STMT := SEL_STMT||' SELECT ''NOT-ASSIGNED'' AS CLIENT, ';
          SEL_STMT := SEL_STMT||' UPPER(SERVICER) AS SERVICER,';
          SEL_STMT := SEL_STMT||' LOAN_NBR,';
          SEL_STMT := SEL_STMT||' NULL AS ORDER_NBR,';
          SEL_STMT := SEL_STMT||' INVOICE_TYPE,';
          SEL_STMT := SEL_STMT||' INVOICE_DATE,';
          SEL_STMT := SEL_STMT||' UPPER(INVOICE_NBR) AS INVOICE_NBR,';
          SEL_STMT := SEL_STMT||' ''0.0'' AS INVOICE_AMT, ';
          SEL_STMT := SEL_STMT||' STATE,';
          SEL_STMT := SEL_STMT||' LI_CODE,';
          SEL_STMT := SEL_STMT||' LI_DESCRIPTION,';
          SEL_STMT := SEL_STMT||' LI_AMT,';
          SEL_STMT := SEL_STMT||' ADJUSTED_AMT,';
          SEL_STMT := SEL_STMT||' TOTAL_LI_AMOUNT,';
          SEL_STMT := SEL_STMT||' REASON,';
          SEL_STMT := SEL_STMT||' COMMENTS_DATE,';
          SEL_STMT := SEL_STMT||' EXPIRES_IN,';
          SEL_STMT := SEL_STMT||' LOAD_ID,';
          SEL_STMT := SEL_STMT||' FILE_ID ';
          SEL_STMT := SEL_STMT||' FROM LA_PENDING_APPROVAL_STG ';
          SEL_STMT := SEL_STMT||' WHERE FILE_ID = :A )';
          SEL_STMT := SEL_STMT||' ORDER BY LOAD_ID ';

OPEN GC FOR SEL_STMT USING P_FILE_ID;



        FETCH GC BULK COLLECT INTO  PA.CLIENT,
                                    PA.SERVICER,
                                    PA.LOAN_NBR,
                                    PA.ORDER_NBR,
                                    PA.INVOICE_TYPE,
                                    PA.INVOICE_DATE,
                                    PA.INVOICE_NBR,
                                    PA.INVOICE_AMT,
                                    PA.STATE,
                                    PA.LI_CODE,
                                    PA.LI_DESCRIPTION,
                                    PA.LI_AMT,
                                    PA.ADJUSTED_AMT,
                                    PA.TOTAL_LI_AMOUNT,
                                    PA.REASON,
                                    PA.COMMENTS_DATE,
                                    PA.EXPIRES_IN,
                                    PA.LOAD_ID,
                                    PA.FILE_ID;
           Tot := PA.FILE_ID.COUNT;
CLOSE GC;

Y := 0;

         FOR X IN 1..Tot LOOP

             IF ( PA.SERVICER(x) IS NULL )
             THEN
                        PA.CLIENT(x)       := 'DELETE';
             END IF;

             PA.ADJUSTED_AMT(x)  := REPLACE(PA.ADJUSTED_AMT(x),'-','');

             IF (PA.EXPIRES_IN(X) IS NOT NULL) THEN
                 PA.EXPIRES_IN(X)    := TO_CHAR((SYSDATE + PA.EXPIRES_IN(X)),'MM/DD/YYYY');
             END IF;

             IF (Y > 0 )
                THEN
                    PA.INVOICE_AMT(y) :=  PA.TOTAL_LI_AMOUNT(x);
             END IF;

             IF ( UPPER(PA.LOAN_NBR(x)) IN  ('LOAN NUMBER') )
             THEN
                            PA.CLIENT(X) := 'DELETE';
             END IF;

              Y := Y + 1;

         END LOOP;


         FOR X IN 1..Tot LOOP
                    IF ( PA.CLIENT(X) IN ('NOT-ASSIGNED') )
                    THEN
--                       GET_CLIENT_NAME (OA.INVOICE_NBR_SHORT(X));

                       CLIENT_TMP := GET_CLIENT_NAME (PA.SERVICER(X));

                       PTR_START := X;

                       PTR_END   := X;

                       SET_CLIENT_NAME ( PTR_START, PTR_END, CLIENT_TMP);

                    END IF;

         END LOOP;


         FOR X IN 1..Tot LOOP

          --INVOICE_NBR


                   INVOICE_NBR := PA.INVOICE_NBR(x);
                   WORK_ORDER  := NULL;

                        -------- JUST NUMBERS   0123456789
                   IF (PA.CLIENT(X) NOT IN ('DELETE') )
                       THEN
                            IF (LENGTH(TRIM(TRANSLATE(PA.INVOICE_NBR(X), '0123456789',' ')))  IS NULL)
                                THEN
                                  INVOICE_NBR := PA.INVOICE_NBR(x);
                            END IF;
                       ----------- THERE IS A DASH (-) NUMBER 00123456789  SO SPLIT
                       -------- Invoice-workorder
                      IF  (INSTR(PA.INVOICE_NBR(x),'-') > 0 ) THEN

                            IF  (LENGTH(TRIM(TRANSLATE(PA.INVOICE_NBR(x), '-0123456789',' '))) IS NULL)
                                THEN
                                   INVOICE_NBR := SUBSTR(PA.INVOICE_NBR(x),1,(INSTR(PA.INVOICE_NBR(x),'-') - 1));
                                   WORK_ORDER  := SUBSTR(PA.INVOICE_NBR(x),(INSTR(PA.INVOICE_NBR(x),'-') + 1));
                            END IF;

                            IF (LENGTH(TRIM(TRANSLATE(PA.INVOICE_NBR(x), '-0123456789',' '))) IS NOT NULL )
                             THEN
                                --- ABC   plus   0123456789
                               INVOICE_PRE := SUBSTR(PA.INVOICE_NBR(x),1,(INSTR(PA.INVOICE_NBR(x),'-') - 1));
                                --- 0123456789  and  0123456789ABC
                               INVOICE_SUF := SUBSTR(PA.INVOICE_NBR(x),(INSTR(PA.INVOICE_NBR(x),'-') + 1));
                               -----------
                                 IF ( LENGTH(TRIM(TRANSLATE(INVOICE_PRE, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '))) IS NULL )
                                  THEN
                                       INVOICE_NBR := TRIM(TRANSLATE(INVOICE_SUF,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                                  else
                                       INVOICE_NBR := TRIM(TRANSLATE(INVOICE_PRE,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                                       WORK_ORDER  := TRIM(TRANSLATE(INVOICE_SUF,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                                 END IF;

                            END IF;

                      ELSE


--                                 0123456789(A-Z)
                            INVOICE_NBR := TRIM(TRANSLATE(PA.INVOICE_NBR(x),'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                            WORK_ORDER  := NULL;


                      END IF;



                          PA.order_nbr(x) :=  WORK_ORDER;


                   END IF;

                         PA.order_nbr(x) :=  WORK_ORDER;
                       PA.INVOICE_NBR(x) := INVOICE_NBR;

         END LOOP;


           FOR X IN 1..Tot LOOP

                IF (PA.CLIENT(X) IN ('DELETE') )
                   THEN
                        ACTION := 'DELETE';
                ELSE
                        ACTION := 'UPDATE';
                END IF;

                IF ( ACTION IN ('UPDATE')  )
                   THEN

                   BEGIN

                      INSERT INTO LA_PENDING_APPROVAL (CLIENT,      LOAN_NBR,      ORDER_NBR,       INVOICE_TYPE,      INVOICE_DATE,      INVOICE_NBR,      INVOICE_AMT,      STATE,      LI_CODE,        LI_DESCRIPTION,      LI_AMT,      ADJUSTED_AMT,      TOTAL_LI_AMOUNT,      REASON,      COMMENTS_DATE,      EXPIRES_IN,       LOAD_ID,     FILE_ID)
                                                VALUES(PA.CLIENT(X),
                                                       PA.LOAN_NBR(X),
                                                       PA.ORDER_NBR(x),
                                                       PA.INVOICE_TYPE(X),
                                                       PA.INVOICE_DATE(X),
                                                       PA.INVOICE_NBR(X),
                                                       PA.INVOICE_AMT(X),
                                                       PA.STATE(X),
                                                       PA.LI_CODE(X),
                                                       PA.LI_DESCRIPTION(X),
                                                       PA.LI_AMT(X),
                                                       PA.ADJUSTED_AMT(X),
                                                       PA.TOTAL_LI_AMOUNT(X),
                                                       PA.REASON(X),
                         LA_FILE_PROCESS.DATE_REFORMAT(PA.COMMENTS_DATE(X)),
                                                       PA.EXPIRES_IN(X),
                                                       PA.LOAD_ID(X),
                                                       PA.FILE_ID(X));


                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(PA.COMMENTS_DATE(X)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;


                   EXCEPTION
                            WHEN BAD_DATA THEN

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_APPROVAL',SYSDATE, Tot, 'DATE VALIDATION ISSUE');
                              COMMIT;

                              SEND_EMAIL  ( P_TEAM=> 'RDM', P_FROM=>'CONVERT_PENDING_APPROVAL', P_SUBJECT=>'DATE VALIDATION ISSUE FILE '||PA.FILE_ID(X),  P_MESSAGE=> 'WE can not continue');



                            WHEN OTHERS THEN

                                RCODE   := SQLCODE;
                                MESSAGE := SQLERRM;

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;


                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_APPROVAL',SYSDATE, RCODE, MESSAGE);
                              COMMIT;


                   END;


                     COMMIT;

                END IF;

                      INSERT INTO LA_PENDING_APPROVAL_AUD (ACTION_TAKEN,SERVICER, LOAN_NBR, INVOICE_TYPE, INVOICE_DATE, INVOICE_NBR, STATE, LI_CODE, LI_DESCRIPTION, LI_AMT, ADJUSTED_AMT,TOTAL_LI_AMOUNT, REASON, COMMENTS_DATE,EXPIRES_IN,LOAD_ID,FILE_ID)
                                                  SELECT   ACTION,      SERVICER, LOAN_NBR, INVOICE_TYPE, INVOICE_DATE, INVOICE_NBR, STATE, LI_CODE, LI_DESCRIPTION, LI_AMT, ADJUSTED_AMT,TOTAL_LI_AMOUNT, REASON, COMMENTS_DATE,EXPIRES_IN,LOAD_ID,FILE_ID
                      FROM LA_PENDING_APPROVAL_STG
                      WHERE FILE_ID = PA.FILE_ID(x)
                     AND   LOAD_ID = PA.LOAD_ID(x);

                   COMMIT;

           end LOOP;


              INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_APPROVAL',SYSDATE, Tot, ' records Reviewed');
              COMMIT;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 2, RECORDCNT = tot WHERE PID = P_FILE_ID;

              COMMIT;


exception
     when others then
          cnt1  := sqlcode;
           msg  := sqlerrm;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
               WHERE PID = P_FILE_ID;

              COMMIT;

              SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.CONVERT_PENDING_APPROVAL',P_SUBJECT=>'Procedure issue' ,P_MESSAGE=>MSG );

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_APPROVAL', SYSDATE, cnt1, msg);
        COMMIT;
END;
/************************************************************

       PENDING REJECTIONS

*************************************************************/
PROCEDURE CONVERT_PENDING_REJECTIONS ( P_FILE_ID NUMBER)
IS

  PR          LA_FILE_PROCESS.LA_PENDING_REJECTIONS;
  GC          LA_FILE_PROCESS.GenRefCursor;
  SEL_STMT    VARCHAR2(32000 BYTE);
  DEL_STMT    VARCHAR2(32000 BYTE);
  UPD_STMT    VARCHAR2(32000 BYTE);
  msg         VARCHAR2(1000 BYTE);
  CLIENT_TMP  VARCHAR2(100 BYTE);
  CLIENT_DATA VARCHAR2(100 BYTE);
  INVOICE_NBR VARCHAR2(100 BYTE);
  INVOICE_PRE VARCHAR2(100 BYTE);
  INVOICE_SUF VARCHAR2(100 BYTE);
  WORK_ORDER  VARCHAR(100 BYTE);
  ACTION      VARCHAR2(100 BYTE);
  Adjust_total  number;
  cnt1          NUMBER(10);
  cnt2          NUMBER(10);
  Y             PLS_INTEGER;
  W             PLS_INTEGER;
  Tot           PLS_INTEGER;
  C             PLS_INTEGER;
  I             PLS_INTEGER;

  PTR_START     PLS_INTEGER;
  PTR_END       PLS_INTEGER;

  LOAD_TMP      NUMBER(10);
  RCODE         NUMBER;
  MESSAGE       VARCHAR2(1000 BYTE);
  BAD_DATA      EXCEPTION;

FUNCTION FIND_THE_END
(
 P_BEGIN PLS_INTEGER
)
RETURN PLS_INTEGER
IS
S          PLS_INTEGER;

P_END      PLS_INTEGER;
C           VARCHAR2(100);

BEGIN

    C   := 'BEGIN';
    S   := P_BEGIN;

    WHILE ( C NOT IN ('END') )
   LOOP
       S   := S + 1;
       C   := PR.CLIENT(S);

   END LOOP;

   P_END   := S;
   RETURN P_END;

END;

FUNCTION GET_CLIENT_NAME (P_NAME VARCHAR2) RETURN VARCHAR2
IS
     CLIENT_NAME VARCHAR2(100);
     CLIENT_SRC  VARCHAR2(100);

     FOUND_IT    NUMBER;
     LIST_CNT    NUMBER;
BEGIN
      FOUND_IT := 0;
      LIST_CNT := codes.client_code.count;
      CLIENT_NAME := 'NOT-FOUND';

          FOR i in 1..codes.client_code.count LOOP

               IF (P_NAME LIKE '%'||codes.sources(i)||'%' ) THEN
                   CLIENT_NAME := codes.client_code(i);
                   EXIT;
               end if;
                FOUND_IT := FOUND_IT + 1;
          END LOOP;

    RETURN CLIENT_NAME;

EXCEPTION WHEN OTHERS  THEN
   RETURN CLIENT_NAME;

END;
----------- SET THE RESULTS
-----------------------------
PROCEDURE SET_CLIENT_NAME ( P_BEGIN PLS_INTEGER, P_END PLS_INTEGER, P_CLIENT VARCHAR2)
IS

BEGIN

   FOR X IN P_BEGIN..P_END LOOP

            PR.CLIENT(X)  := P_CLIENT;

   END LOOP;


END;

begin
             INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_REJECTIONS',SYSDATE, 0, 'And the race is on..');
              COMMIT;

          DEL_STMT := 'DELETE LA_PENDING_REJECTIONS_AUD WHERE FILE_ID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

          DEL_STMT := 'DELETE LA_PENDING_REJECTIONS WHERE FILE_ID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

            SEL_STMT := ' SELECT ';
            SEL_STMT := SEL_STMT||' CLIENT,';
            SEL_STMT := SEL_STMT||' SERVICER,';
            SEL_STMT := SEL_STMT||' LOAN_NBR,';
            SEL_STMT := SEL_STMT||' INVOICE_TYPE,';
            SEL_STMT := SEL_STMT||' INVOICE_DATE,';
            SEL_STMT := SEL_STMT||' INVOICE_NBR,';
            SEL_STMT := SEL_STMT||' ORDER_NBR,';
            SEL_STMT := SEL_STMT||' STATE,';
            SEL_STMT := SEL_STMT||' SERVICER_COMMENTS,';
            SEL_STMT := SEL_STMT||' COMMENTS_DATE,';
            SEL_STMT := SEL_STMT||' EXPIRES_IN,';
            SEL_STMT := SEL_STMT||' INVOICE_AMT,';
            SEL_STMT := SEL_STMT||' LOAD_ID,';
            SEL_STMT := SEL_STMT||' FILE_ID ';
            SEL_STMT := SEL_STMT||' FROM ( ';
            SEL_STMT := SEL_STMT||' SELECT ';
            SEL_STMT := SEL_STMT||' ''NOT-ASSIGNED'' AS CLIENT,';
            SEL_STMT := SEL_STMT||' upper(SERVICER) as SERVICER,';
            SEL_STMT := SEL_STMT||' LOAN_NBR,';
            SEL_STMT := SEL_STMT||' INVOICE_TYPE,';
            SEL_STMT := SEL_STMT||' INVOICE_DATE,';
            SEL_STMT := SEL_STMT||' UPPER(INVOICE_NBR) AS INVOICE_NBR,';
            SEL_STMT := SEL_STMT||' NULL AS ORDER_NBR,';
            SEL_STMT := SEL_STMT||' STATE,';
            SEL_STMT := SEL_STMT||' SERVICER_COMMENTS,';
            SEL_STMT := SEL_STMT||' COMMENTS_DATE,';
            SEL_STMT := SEL_STMT||' EXPIRES_IN,';
            SEL_STMT := SEL_STMT||' INVOICE_AMT,';
            SEL_STMT := SEL_STMT||' LOAD_ID,';
            SEL_STMT := SEL_STMT||' FILE_ID ';
            SEL_STMT := SEL_STMT||' FROM LA_PENDING_REJECTIONS_STG';
            SEL_STMT := SEL_STMT||' WHERE FILE_ID = :A';
            SEL_STMT := SEL_STMT||' ORDER BY LOAD_ID) ';

OPEN GC FOR SEL_STMT USING P_FILE_ID;

        FETCH GC BULK COLLECT INTO PR.CLIENT,
                                   PR.SERVICER,
                                   PR.LOAN_NBR,
                                   PR.INVOICE_TYPE,
                                   PR.INVOICE_DATE,
                                   PR.INVOICE_NBR,
                                   PR.ORDER_NBR,
                                   PR.STATE,
                                   PR.SERVICER_COMMENTS,
                                   PR.COMMENTS_DATE,
                                   PR.EXPIRES_IN,
                                   PR.INVOICE_AMT,
                                   PR.LOAD_ID,
                                   PR.FILE_ID;
           Tot := PR.FILE_ID.COUNT;
CLOSE GC;

Y := 0;

         FOR X IN 1..Tot LOOP

             IF ( PR.SERVICER(x) IS NULL )
             THEN
                        PR.CLIENT(x)       := 'DELETE';
             END IF;


             IF (PR.EXPIRES_IN(X) IS NOT NULL) THEN
                 PR.EXPIRES_IN(X)    := TO_CHAR((SYSDATE + PR.EXPIRES_IN(X)),'MM/DD/YYYY');
             END IF;

             IF ( UPPER(PR.LOAN_NBR(x)) IN  ('LOAN NUMBER') )
             THEN
                            PR.CLIENT(X) := 'DELETE';
             END IF;

              Y := Y + 1;

         END LOOP;


         FOR X IN 1..Tot LOOP
                    IF ( PR.CLIENT(X) IN ('NOT-ASSIGNED') )
                    THEN
--                       GET_CLIENT_NAME (OA.INVOICE_NBR_SHORT(X));

                       CLIENT_TMP := GET_CLIENT_NAME (PR.SERVICER(X));

                       PTR_START := X;

                       PTR_END   := X;

                       SET_CLIENT_NAME ( PTR_START, PTR_END, CLIENT_TMP);

                    END IF;

         END LOOP;




         FOR X IN 1..Tot LOOP

          --INVOICE_NBR


                   INVOICE_NBR := PR.INVOICE_NBR(x);
                   WORK_ORDER  := NULL;

                        -------- JUST NUMBERS   0123456789
                   IF (PR.CLIENT(X) NOT IN ('DELETE') )
                       THEN
                            IF (LENGTH(TRIM(TRANSLATE(PR.INVOICE_NBR(X), '0123456789',' ')))  IS NULL)
                                THEN
                                  INVOICE_NBR := PR.INVOICE_NBR(x);
                            END IF;
                       ----------- THERE IS A DASH (-) NUMBER 00123456789  SO SPLIT
                       -------- Invoice-workorder
                      IF  (INSTR(PR.INVOICE_NBR(x),'-') > 0 ) THEN

                            IF  (LENGTH(TRIM(TRANSLATE(PR.INVOICE_NBR(x), '-0123456789',' '))) IS NULL)
                                THEN
                                   INVOICE_NBR := SUBSTR(PR.INVOICE_NBR(x),1,(INSTR(PR.INVOICE_NBR(x),'-') - 1));
                                   WORK_ORDER  := SUBSTR(PR.INVOICE_NBR(x),(INSTR(PR.INVOICE_NBR(x),'-') + 1));
                            END IF;

                            IF (LENGTH(TRIM(TRANSLATE(PR.INVOICE_NBR(x), '-0123456789',' '))) IS NOT NULL )
                             THEN
                                --- ABC   plus   0123456789
                               INVOICE_PRE := SUBSTR(PR.INVOICE_NBR(x),1,(INSTR(PR.INVOICE_NBR(x),'-') - 1));
                                --- 0123456789  and  0123456789ABC
                               INVOICE_SUF := SUBSTR(PR.INVOICE_NBR(x),(INSTR(PR.INVOICE_NBR(x),'-') + 1));
                               -----------
                                 IF ( LENGTH(TRIM(TRANSLATE(INVOICE_PRE, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '))) IS NULL )
                                  THEN
                                       INVOICE_NBR := TRIM(TRANSLATE(INVOICE_SUF,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                                  else
                                       INVOICE_NBR := TRIM(TRANSLATE(INVOICE_PRE,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                                       WORK_ORDER  := TRIM(TRANSLATE(INVOICE_SUF,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                                 END IF;

                            END IF;

                      ELSE


--                                 0123456789(A-Z)
                            INVOICE_NBR := TRIM(TRANSLATE(PR.INVOICE_NBR(x),'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                            WORK_ORDER  := NULL;


                      END IF;



                          PR.order_nbr(x) :=  WORK_ORDER;


                   END IF;

                         PR.order_nbr(x) :=  WORK_ORDER;
                       PR.INVOICE_NBR(x) := INVOICE_NBR;

         END LOOP;


           FOR X IN 1..Tot LOOP

                IF (PR.CLIENT(X) IN ('DELETE') )
                   THEN
                        ACTION := 'DELETE';
                ELSE
                        ACTION := 'UPDATE';
                END IF;

                IF ( ACTION IN ('UPDATE')  )
                   THEN

                   BEGIN

                      INSERT INTO LA_PENDING_REJECTIONS (CLIENT, LOAN_NBR, INVOICE_TYPE, INVOICE_DATE, INVOICE_NBR, ORDER_NBR, STATE, SERVICER_COMMENTS, COMMENTS_DATE, EXPIRES_IN, INVOICE_AMT, LOAD_ID, FILE_ID)
                      VALUES(PR.CLIENT(X),
                             PR.LOAN_NBR(X),
                             PR.INVOICE_TYPE(X),
                             LA_FILE_PROCESS.DATE_REFORMAT(PR.INVOICE_DATE(X)),
                             PR.INVOICE_NBR(X),
                             PR.ORDER_NBR(X),
                             PR.STATE(X),
                             PR.SERVICER_COMMENTS(X),
                             LA_FILE_PROCESS.DATE_REFORMAT(PR.COMMENTS_DATE(X)),
                             PR.EXPIRES_IN(X),
                             PR.INVOICE_AMT(X),
                             PR.LOAD_ID(X),
                             PR.FILE_ID(X));

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(PR.INVOICE_DATE(X)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(PR.COMMENTS_DATE(X)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;


                   EXCEPTION
                            WHEN BAD_DATA THEN

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_REJECTIONS',SYSDATE, Tot, 'DATE VALIDATION ISSUE');
                              COMMIT;

                              SEND_EMAIL  ( P_TEAM=> 'RDM', P_FROM=>'CONVERT_PENDING_REJECTIONS', P_SUBJECT=>'DATE VALIDATION ISSUE FILE '||PR.FILE_ID(X),  P_MESSAGE=> 'WE can not continue');



                            WHEN OTHERS THEN

                                RCODE   := SQLCODE;
                                MESSAGE := SQLERRM;

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;


                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_REJECTIONS',SYSDATE, RCODE, MESSAGE);
                              COMMIT;


                   END;

                     COMMIT;

                END IF;

                      INSERT INTO LA_PENDING_REJECTIONS_AUD (ACTION_TAKEN,SERVICER, LOAN_NBR, INVOICE_TYPE, INVOICE_DATE, INVOICE_NBR, ORDER_NBR, STATE, SERVICER_COMMENTS, COMMENTS_DATE, EXPIRES_IN, INVOICE_AMT, LOAD_ID, FILE_ID)
                      SELECT   ACTION, SERVICER, LOAN_NBR, INVOICE_TYPE, INVOICE_DATE, INVOICE_NBR, ORDER_NBR, STATE, SERVICER_COMMENTS, COMMENTS_DATE, EXPIRES_IN, INVOICE_AMT, LOAD_ID, FILE_ID
                      FROM LA_PENDING_REJECTIONS_STG
                      WHERE FILE_ID = PR.FILE_ID(x)
                       AND   LOAD_ID = PR.LOAD_ID(x);

                   COMMIT;

           end LOOP;


              INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_REJECTIONS',SYSDATE, Tot, ' records Reviewed');
              COMMIT;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 2, RECORDCNT = tot WHERE PID = P_FILE_ID;

              COMMIT;


exception
     when others then
          cnt1  := sqlcode;
           msg  := sqlerrm;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
               WHERE PID = P_FILE_ID;

              COMMIT;

              SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.CONVERT_PENDING_REJECTIONS',P_SUBJECT=>'Procedure issue' ,P_MESSAGE=>MSG );

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'CONVERT_PENDING_REJECTIONS', SYSDATE, cnt1, msg);
        COMMIT;
END;
/************************************************************

       IR ASSIGNMENT

*************************************************************/
PROCEDURE CONVERT_IR_ASSIGNMENT ( P_FILE_ID NUMBER)
IS

  IR          LA_FILE_PROCESS.LA_IR_ASSIGNMENT;
  GC          LA_FILE_PROCESS.GenRefCursor;
  SEL_STMT    VARCHAR2(32000 BYTE);
  DEL_STMT    VARCHAR2(32000 BYTE);
  UPD_STMT    VARCHAR2(32000 BYTE);
  msg         VARCHAR2(1000 BYTE);
  CLIENT_TMP  VARCHAR2(100 BYTE);
  CLIENT_DATA VARCHAR2(100 BYTE);
  INVOICE_NBR VARCHAR2(100 BYTE);
  INVOICE_PRE VARCHAR2(100 BYTE);
  INVOICE_SUF VARCHAR2(100 BYTE);
  WORK_ORDER  VARCHAR(100 BYTE);
  ACTION      VARCHAR2(100 BYTE);
  Adjust_total  number;
  cnt1          NUMBER(10);
  cnt2          NUMBER(10);
  cents         number(10,2);
  Y             PLS_INTEGER;
  W             PLS_INTEGER;
  Tot           PLS_INTEGER;
  C             PLS_INTEGER;
  I             PLS_INTEGER;

  PTR_START     PLS_INTEGER;
  PTR_END       PLS_INTEGER;

  LOAD_TMP      NUMBER(10);
  RCODE         NUMBER;
  MESSAGE       VARCHAR2(1000 BYTE);
  BAD_DATA      EXCEPTION;

FUNCTION FIND_THE_END
(
 P_BEGIN PLS_INTEGER
)
RETURN PLS_INTEGER
IS
S          PLS_INTEGER;

P_END      PLS_INTEGER;
C           VARCHAR2(100);

BEGIN

    C   := 'BEGIN';
    S   := P_BEGIN;

    WHILE ( C NOT IN ('END') )
   LOOP
       S   := S + 1;
       C   := IR.CLIENT(S);

   END LOOP;

   P_END   := S;
   RETURN P_END;

END;

FUNCTION GET_CLIENT_NAME (P_NAME VARCHAR2) RETURN VARCHAR2
IS
     CLIENT_NAME VARCHAR2(100);
     CLIENT_SRC  VARCHAR2(100);

     FOUND_IT    NUMBER;
     LIST_CNT    NUMBER;
BEGIN
      FOUND_IT := 0;
      LIST_CNT := codes.client_code.count;
      CLIENT_NAME := 'NOT-FOUND';

          FOR i in 1..codes.client_code.count LOOP

               IF (P_NAME LIKE '%'||codes.sources(i)||'%' ) THEN
                   CLIENT_NAME := codes.client_code(i);
                   EXIT;
               end if;

               IF (P_NAME = codes.sources(i)) THEN
                   CLIENT_NAME := codes.client_code(i);
                   EXIT;
               end if;

                FOUND_IT := FOUND_IT + 1;
          END LOOP;

    RETURN CLIENT_NAME;

EXCEPTION WHEN OTHERS  THEN
   RETURN CLIENT_NAME;

END;
----------- SET THE RESULTS
-----------------------------
PROCEDURE SET_CLIENT_NAME ( P_BEGIN PLS_INTEGER, P_CLIENT VARCHAR2)
IS

BEGIN


            IR.CLIENT_CODE(P_BEGIN)  := P_CLIENT;


END;

begin
             INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_IR_ASSIGNMENT',SYSDATE, 0, 'And the race is on..');
              COMMIT;

          DEL_STMT := 'DELETE LA_IR_ASSIGNMENT_AUD WHERE FILE_ID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

          DEL_STMT := 'DELETE LA_IR_ASSIGNMENT WHERE FILE_ID = :A';
          EXECUTE IMMEDIATE DEL_STMT USING P_FILE_ID;
          COMMIT;

            SEL_STMT := ' SELECT ';
            SEL_STMT := SEL_STMT||' CLIENT_CODE,';
            SEL_STMT := SEL_STMT||' RECEIVED_DATE,';
            SEL_STMT := SEL_STMT||' LAST_UPDATED,';
            SEL_STMT := SEL_STMT||' CLIENT,';
            SEL_STMT := SEL_STMT||' COL_D,';
            SEL_STMT := SEL_STMT||' INVOICE_NBR,';
            SEL_STMT := SEL_STMT||' INVOICE_DATE,';
            SEL_STMT := SEL_STMT||' WORK_ORDER_NBR,';
            SEL_STMT := SEL_STMT||' LOAN_NBR,';
            SEL_STMT := SEL_STMT||' COL_I,';
            SEL_STMT := SEL_STMT||' DISPUTE_AMT,';
            SEL_STMT := SEL_STMT||' COL_K,';
            SEL_STMT := SEL_STMT||' CLIENT_COMMENT,';
            SEL_STMT := SEL_STMT||' COL_M,';
            SEL_STMT := SEL_STMT||' LOSS_ANALYST,';
            SEL_STMT := SEL_STMT||' WRITE_OFF_AMOUNT,';
            SEL_STMT := SEL_STMT||' WRITE_OFF,';
            SEL_STMT := SEL_STMT||' WRITE_OFF_REASON_CODE,';
            SEL_STMT := SEL_STMT||' WRITE_OFF_REASON,';
            SEL_STMT := SEL_STMT||' DONE_BILLING_CODE,';
            SEL_STMT := SEL_STMT||' VENDOR_CODE,';
            SEL_STMT := SEL_STMT||' CHARGEBACK_AMOUNT,';
            SEL_STMT := SEL_STMT||' DISPUTE_TYPE,';
            SEL_STMT := SEL_STMT||' SOURCE_OF_DISPUTE,';
            SEL_STMT := SEL_STMT||' COL_X,';
            SEL_STMT := SEL_STMT||' APPROVAL,';
            SEL_STMT := SEL_STMT||' PENDING_RESEARCH,';
            SEL_STMT := SEL_STMT||' DISPUTE_APPEAL_COMMENT,';
            SEL_STMT := SEL_STMT||' IM_ICLEAR_INV,';
            SEL_STMT := SEL_STMT||' CLIENT_EMPLOYEE,';
            SEL_STMT := SEL_STMT||' LOAD_ID,';
            SEL_STMT := SEL_STMT||' FILE_ID';
            SEL_STMT := SEL_STMT||' FROM ( SELECT ';
            SEL_STMT := SEL_STMT||' ''NOT-ASSIGNED'' AS CLIENT_CODE,';
            SEL_STMT := SEL_STMT||' RECEIVED_DATE,';
            SEL_STMT := SEL_STMT||' LAST_UPDATED,';
            SEL_STMT := SEL_STMT||' UPPER(CLIENT) AS CLIENT,';
            SEL_STMT := SEL_STMT||' COL_D,';
            SEL_STMT := SEL_STMT||' UPPER(INVOICE_NBR) AS INVOICE_NBR,';
            SEL_STMT := SEL_STMT||' INVOICE_DATE,';
            SEL_STMT := SEL_STMT||' WORK_ORDER_NBR,';
            SEL_STMT := SEL_STMT||' LOAN_NBR,';
            SEL_STMT := SEL_STMT||' COL_I,';
            SEL_STMT := SEL_STMT||' DISPUTE_AMT,';
            SEL_STMT := SEL_STMT||' COL_K,';
            SEL_STMT := SEL_STMT||' CLIENT_COMMENT,';
            SEL_STMT := SEL_STMT||' COL_M,';
            SEL_STMT := SEL_STMT||' LOSS_ANALYST,';
            SEL_STMT := SEL_STMT||' WRITE_OFF_AMOUNT,';
            SEL_STMT := SEL_STMT||' WRITE_OFF,';
            SEL_STMT := SEL_STMT||' WRITE_OFF_REASON_CODE,';
            SEL_STMT := SEL_STMT||' WRITE_OFF_REASON,';
            SEL_STMT := SEL_STMT||' DONE_BILLING_CODE,';
            SEL_STMT := SEL_STMT||' VENDOR_CODE,';
            SEL_STMT := SEL_STMT||' CHARGEBACK_AMOUNT,';
            SEL_STMT := SEL_STMT||' DISPUTE_TYPE,';
            SEL_STMT := SEL_STMT||' SOURCE_OF_DISPUTE,';
            SEL_STMT := SEL_STMT||' COL_X,';
            SEL_STMT := SEL_STMT||' APPROVAL,';
            SEL_STMT := SEL_STMT||' PENDING_RESEARCH,';
            SEL_STMT := SEL_STMT||' DISPUTE_APPEAL_COMMENT,';
            SEL_STMT := SEL_STMT||' IM_ICLEAR_INV,';
            SEL_STMT := SEL_STMT||' CLIENT_EMPLOYEE,';
            SEL_STMT := SEL_STMT||' LOAD_ID,';
            SEL_STMT := SEL_STMT||' FILE_ID';
            SEL_STMT := SEL_STMT||' FROM LA_IR_ASSIGNMENT_STG ';
            SEL_STMT := SEL_STMT||' WHERE FILE_ID = :A)';
            SEL_STMT := SEL_STMT||' ORDER BY LOAD_ID';

OPEN GC FOR SEL_STMT USING P_FILE_ID;

        FETCH GC BULK COLLECT INTO  IR.CLIENT_CODE,
                                    IR.RECEIVED_DATE,
                                    IR.LAST_UPDATED,
                                    IR.CLIENT,
                                    IR.COL_D,
                                    IR.INVOICE_NBR,
                                    IR.INVOICE_DATE,
                                    IR.WORK_ORDER_NBR,
                                    IR.LOAN_NBR,
                                    IR.COL_I,
                                    IR.DISPUTE_AMT,
                                    IR.COL_K,
                                    IR.CLIENT_COMMENT,
                                    IR.COL_M,
                                    IR.LOSS_ANALYST,
                                    IR.WRITE_OFF_AMOUNT,
                                    IR.WRITE_OFF,
                                    IR.WRITE_OFF_REASON_CODE,
                                    IR.WRITE_OFF_REASON,
                                    IR.DONE_BILLING_CODE,
                                    IR.VENDOR_CODE,
                                    IR.CHARGEBACK_AMOUNT,
                                    IR.DISPUTE_TYPE,
                                    IR.SOURCE_OF_DISPUTE,
                                    IR.COL_X,
                                    IR.APPROVAL,
                                    IR.PENDING_RESEARCH,
                                    IR.DISPUTE_APPEAL_COMMENT,
                                    IR.IM_ICLEAR_INV,
                                    IR.CLIENT_EMPLOYEE,
                                    IR.LOAD_ID,
                                    IR.FILE_ID;
           Tot := IR.FILE_ID.COUNT;
CLOSE GC;

Y := 0;

         FOR X IN 1..Tot LOOP

             IF ( IR.CLIENT(x) IS NULL )
             THEN
                        IR.CLIENT_CODE(x)       := 'DELETE';
             END IF;


             IF ( UPPER(IR.RECEIVED_DATE(x)) IN  ('RECEIVED DATE') )
             THEN
                        IR.CLIENT_CODE(x)       := 'DELETE';
             END IF;


             IF (IR.DISPUTE_AMT(X) IS NOT NULL) THEN
                 cents  :=  to_number(IR.DISPUTE_AMT(X));
                 IR.DISPUTE_AMT(X) := to_char(cents,'$999,999,999.99');
             END IF;


         END LOOP;


         FOR X IN 1..Tot LOOP
                    IF ( IR.CLIENT_CODE(X) IN ('NOT-ASSIGNED') )
                    THEN

                       CLIENT_TMP := GET_CLIENT_NAME (IR.CLIENT(X));

                       PTR_START := X;

                       SET_CLIENT_NAME ( PTR_START, CLIENT_TMP);

                    END IF;

         END LOOP;




         FOR X IN 1..Tot LOOP

          --INVOICE_NBR


                   INVOICE_NBR := IR.INVOICE_NBR(x);

                        -------- JUST NUMBERS   0123456789
                   IF (IR.CLIENT_CODE(X) NOT IN ('DELETE') )
                       THEN
                            IF (LENGTH(TRIM(TRANSLATE(IR.INVOICE_NBR(X), '0123456789',' ')))  IS NULL)
                                THEN
                                  INVOICE_NBR := IR.INVOICE_NBR(x);
                            END IF;
                       ----------- THERE IS A DASH (-) NUMBER 00123456789  SO SPLIT
                       -------- Invoice-workorder
                      IF  (INSTR(IR.INVOICE_NBR(x),'-') > 0 ) THEN

                            IF  (LENGTH(TRIM(TRANSLATE(IR.INVOICE_NBR(x), '-0123456789',' '))) IS NULL)
                                THEN
                                   INVOICE_NBR := SUBSTR(IR.INVOICE_NBR(x),1,(INSTR(IR.INVOICE_NBR(x),'-') - 1));
--                                   WORK_ORDER  := SUBSTR(IR.INVOICE_NBR(x),(INSTR(IR.INVOICE_NBR(x),'-') + 1));
                            END IF;

                            IF (LENGTH(TRIM(TRANSLATE(IR.INVOICE_NBR(x), '-0123456789',' '))) IS NOT NULL )
                             THEN
                                --- ABC   plus   0123456789
                               INVOICE_PRE := SUBSTR(IR.INVOICE_NBR(x),1,(INSTR(IR.INVOICE_NBR(x),'-') - 1));
                                --- 0123456789  and  0123456789ABC
                               INVOICE_SUF := SUBSTR(IR.INVOICE_NBR(x),(INSTR(IR.INVOICE_NBR(x),'-') + 1));
                               -----------
                                 IF ( LENGTH(TRIM(TRANSLATE(INVOICE_PRE, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '))) IS NULL )
                                  THEN
                                       INVOICE_NBR := TRIM(TRANSLATE(INVOICE_SUF,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                                  else
                                       INVOICE_NBR := TRIM(TRANSLATE(INVOICE_PRE,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));
                                 END IF;

                            END IF;

                      ELSE


--                                 0123456789(A-Z)
                            INVOICE_NBR := TRIM(TRANSLATE(IR.INVOICE_NBR(x),'ABCDEFGHIJKLMNOPQRSTUVWXYZ',' '));


                      END IF;



                   END IF;

                       IR.INVOICE_NBR(x) := INVOICE_NBR;

         END LOOP;


           FOR X IN 1..Tot LOOP

                IF (IR.CLIENT_CODE(X) IN ('DELETE') )
                   THEN
                        ACTION := 'DELETE';
                ELSE
                        ACTION := 'UPDATE';
                END IF;

                IF ( ACTION IN ('UPDATE')  )
                   THEN

                    BEGIN

                      INSERT INTO LA_IR_ASSIGNMENT (RECEIVED_DATE,
                                                     LAST_UPDATED,
                                                     CLIENT,
                                                     COL_D,
                                                     INVOICE_NBR,
                                                     INVOICE_DATE,
                                                     WORK_ORDER_NBR,
                                                     LOAN_NBR,
                                                     COL_I,
                                                     DISPUTE_AMT,
                                                     COL_K,
                                                     CLIENT_COMMENT,
                                                     COL_M,
                                                     LOSS_ANALYST,
                                                     WRITE_OFF_AMOUNT,
                                                     WRITE_OFF,
                                                     WRITE_OFF_REASON_CODE,
                                                     WRITE_OFF_REASON,
                                                     DONE_BILLING_CODE,
                                                     VENDOR_CODE,
                                                     CHARGEBACK_AMOUNT,
                                                     DISPUTE_TYPE,
                                                     SOURCE_OF_DISPUTE,
                                                     COL_X,
                                                     APPROVAL,
                                                     PENDING_RESEARCH,
                                                     DISPUTE_APPEAL_COMMENT,
                                                     IM_ICLEAR_INV,
                                                     CLIENT_EMPLOYEE,
                                                     LOAD_ID,
                                                     FILE_ID)
                                           VALUES(LA_FILE_PROCESS.DATE_REFORMAT(IR.RECEIVED_DATE(x)),
                                                  LA_FILE_PROCESS.DATE_REFORMAT(IR.LAST_UPDATED(x)),
                                                  IR.CLIENT_CODE(x),
                                                  IR.COL_D(x),
                                                  IR.INVOICE_NBR(x),
                                                  LA_FILE_PROCESS.DATE_REFORMAT(IR.INVOICE_DATE(x)),
                                                  IR.WORK_ORDER_NBR(x),
                                                  IR.LOAN_NBR(x),
                                                  IR.COL_I(x),
                                                  IR.DISPUTE_AMT(x),
                                                  IR.COL_K(x),
                                                  IR.CLIENT_COMMENT(x),
                                                  IR.COL_M(x),
                                                  IR.LOSS_ANALYST(x),
                                                  IR.WRITE_OFF_AMOUNT(x),
                                                  IR.WRITE_OFF(x),
                                                  IR.WRITE_OFF_REASON_CODE(x),
                                                  IR.WRITE_OFF_REASON(x),
                                                  IR.DONE_BILLING_CODE(x),
                                                  IR.VENDOR_CODE(x),
                                                  IR.CHARGEBACK_AMOUNT(x),
                                                  IR.DISPUTE_TYPE(x),
                                                  IR.SOURCE_OF_DISPUTE(x),
                                                  IR.COL_X(x),
                                                  IR.APPROVAL(x),
                                                  IR.PENDING_RESEARCH(x),
                                                  IR.DISPUTE_APPEAL_COMMENT(x),
                                                  IR.IM_ICLEAR_INV(x),
                                                  IR.CLIENT_EMPLOYEE(x),
                                                  IR.LOAD_ID(x),
                                                  IR.FILE_ID(x));

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(IR.INVOICE_DATE(X)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(IR.LAST_UPDATED(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;

                                 IF    ( LA_FILE_PROCESS.DATE_REFORMAT(IR.RECEIVED_DATE(x)) ) LIKE 'FAIL%'
                                       THEN   RAISE BAD_DATA;
                                 END IF;


                   EXCEPTION
                            WHEN BAD_DATA THEN

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;

                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_LA_IR_ASSIGNMENT',SYSDATE, Tot, 'DATE VALIDATION ISSUE');
                              COMMIT;

                              SEND_EMAIL  ( P_TEAM=> 'RDM', P_FROM=>'CONVERT_LA_IR_ASSIGNMENT', P_SUBJECT=>'DATE VALIDATION ISSUE FILE '||IR.FILE_ID(X),  P_MESSAGE=> 'WE can not continue');



                            WHEN OTHERS THEN

                                RCODE   := SQLCODE;
                                MESSAGE := SQLERRM;

                                UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                                 WHERE PID = P_FILE_ID;


                              INSERT INTO BOA_PROCESS_LOG
                                          (
                                            PROCESS,
                                            SUB_PROCESS,
                                            ENTRYDTE,
                                            ROWCOUNTS,
                                            MESSAGE
                                          )
                              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_LA_IR_ASSIGNMENT',SYSDATE, RCODE, MESSAGE);
                              COMMIT;


                   END;

                     COMMIT;

                END IF;
                   INSERT INTO LA_IR_ASSIGNMENT_AUD (ACTION_TAKEN,
                                                     RECEIVED_DATE,
                                                     LAST_UPDATED,
                                                     CLIENT,
                                                     COL_D,
                                                     INVOICE_NBR,
                                                     INVOICE_DATE,
                                                     WORK_ORDER_NBR,
                                                     LOAN_NBR,
                                                     COL_I,
                                                     DISPUTE_AMT,
                                                     COL_K,
                                                     CLIENT_COMMENT,
                                                     COL_M,
                                                     LOSS_ANALYST,
                                                     WRITE_OFF_AMOUNT,
                                                     WRITE_OFF,
                                                     WRITE_OFF_REASON_CODE,
                                                     WRITE_OFF_REASON,
                                                     DONE_BILLING_CODE,
                                                     VENDOR_CODE,
                                                     CHARGEBACK_AMOUNT,
                                                     DISPUTE_TYPE,
                                                     SOURCE_OF_DISPUTE,
                                                     COL_X,
                                                     APPROVAL,
                                                     PENDING_RESEARCH,
                                                     DISPUTE_APPEAL_COMMENT,
                                                     IM_ICLEAR_INV,
                                                     CLIENT_EMPLOYEE,
                                                     LOAD_ID,
                                                     FILE_ID)

                      SELECT    ACTION,
                                RECEIVED_DATE,
                                LAST_UPDATED,
                                CLIENT,
                                COL_D,
                                INVOICE_NBR,
                                INVOICE_DATE,
                                WORK_ORDER_NBR,
                                LOAN_NBR,
                                COL_I,
                                DISPUTE_AMT,
                                COL_K,
                                CLIENT_COMMENT,
                                COL_M,
                                LOSS_ANALYST,
                                WRITE_OFF_AMOUNT,
                                WRITE_OFF,
                                WRITE_OFF_REASON_CODE,
                                WRITE_OFF_REASON,
                                DONE_BILLING_CODE,
                                VENDOR_CODE,
                                CHARGEBACK_AMOUNT,
                                DISPUTE_TYPE,
                                SOURCE_OF_DISPUTE,
                                COL_X,
                                APPROVAL,
                                PENDING_RESEARCH,
                                DISPUTE_APPEAL_COMMENT,
                                IM_ICLEAR_INV,
                                CLIENT_EMPLOYEE,
                                LOAD_ID,
                                FILE_ID
                      FROM LA_IR_ASSIGNMENT_STG
                      WHERE FILE_ID = IR.FILE_ID(x)
                       AND   LOAD_ID = IR.LOAD_ID(x);

                   COMMIT;

           end LOOP;

              INSERT INTO BOA_PROCESS_LOG
                          (
                            PROCESS,
                            SUB_PROCESS,
                            ENTRYDTE,
                            ROWCOUNTS,
                            MESSAGE
                          )
              VALUES ( 'LA_FILE_PROCESS', 'CONVERT_IR_ASSIGNMENT',SYSDATE, Tot, ' records Reviewed');
              COMMIT;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 2, RECORDCNT = tot WHERE PID = P_FILE_ID;

              COMMIT;


exception
     when others then
          cnt1  := sqlcode;
           msg  := sqlerrm;

              UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
               WHERE PID = P_FILE_ID;

              COMMIT;

              SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.CONVERT_IR_ASSIGNMENT',P_SUBJECT=>'Procedure issue' ,P_MESSAGE=>MSG );

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'CONVERT_IR_ASSIGNMENT', SYSDATE, cnt1, msg);
        COMMIT;
END;

PROCEDURE SAVE_HIGH_QUEUE ( P_HIGH_LIST VARCHAR2, P_PID NUMBER )
is
    CLIENTCODES   apex_application_global.vc_arr2;
    cnt        number;
    SQL_STMT   VARCHAR2(32000);
begin

     cnt := 0;

     BEGIN
          DELETE TABLE(SELECT LA_CLIENT_QUEUE_LISTS.HIGH_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID);
          COMMIT;
     END;


    CLIENTCODES := apex_util.string_to_table (P_HIGH_LIST);

    for i in 1..CLIENTCODES.count
    loop
         if ( CLIENTCODES(i) is not null ) then
             cnt := cnt + 1;

            SQL_STMT := ' INSERT INTO TABLE(SELECT LA_CLIENT_QUEUE_LISTS.HIGH_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = :A )';
            SQL_STMT := SQL_STMT||' VALUES ('''||CLIENTCODES(i)||''' )';

            BEGIN
            EXECUTE IMMEDIATE SQL_STMT USING P_PID;
            EXCEPTION
                  WHEN OTHERS THen
                     NULL;
            END;

         end if;


        commit;
    end loop;

    IF (cnt > 0) THEN
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.HIGH_QUE_CNT = CNT  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    ELSE
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.HIGH_QUE_CNT = 0  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    END IF;



COMMIT;


end;

PROCEDURE SAVE_LOW_QUEUE ( P_LOW_LIST VARCHAR2, P_PID NUMBER )
is
    CLIENTCODES   apex_application_global.vc_arr2;
    cnt        number;
    SQL_STMT   VARCHAR2(32000);
begin

     cnt := 0;

     BEGIN
          DELETE TABLE(SELECT LA_CLIENT_QUEUE_LISTS.LOW_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID);
          COMMIT;
     END;


    CLIENTCODES := apex_util.string_to_table (P_LOW_LIST);

    for i in 1..CLIENTCODES.count
    loop
         if ( CLIENTCODES(i) is not null ) then
             cnt := cnt + 1;

            SQL_STMT := ' INSERT INTO TABLE(SELECT LA_CLIENT_QUEUE_LISTS.LOW_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = :A )';
            SQL_STMT := SQL_STMT||' VALUES ('''||CLIENTCODES(i)||''' )';

            BEGIN
            EXECUTE IMMEDIATE SQL_STMT USING P_PID;
            EXCEPTION
                  WHEN OTHERS THen
                     NULL;
            END;

         end if;


        commit;
    end loop;

    IF (cnt > 0) THEN
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.LOW_QUE_CNT = CNT  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    ELSE
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.LOW_QUE_CNT = 0  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    END IF;


COMMIT;


end;


PROCEDURE RESET_QUEUES
IS

CURSOR C1
IS
SELECT PID,
       LOGIN,
       STATUS
FROM LA_QUEUE_PROCESSORS
WHERE STATUS = 'Active'
ORDER BY PID;

R1  C1%ROWTYPE;

SQL_STMT   VARCHAR2(32000);
MSG        VARCHAR2(1000);
HI_CNT     NUMBER;
LO_CNT     NUMBER;
CNT        NUMBER;

BEGIN

CNT    := 0;
HI_CNT := 0;
LO_CNT := 0;

       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'RESET_QUEUES', SYSDATE, CNT, 'Starting..');
        COMMIT;

/*******************************************************************
  Have to reset / zero everything out.
 *******************************************************************/

    SQL_STMT := 'update LA_ASSIGNMENT set queue_id = 0 where nvl(processor_id,0) = 0 ';
    EXECUTE IMMEDIATE SQL_STMT;

    COMMIT;




OPEN C1;
   LOOP
      FETCH C1 INTO R1;
      EXIT WHEN C1%NOTFOUND;

    SQL_STMT := ' UPDATE LA_ASSIGNMENT c ';
    SQL_STMT := SQL_STMT||' SET c.QUEUE_ID = :E,  c.LOSS_ANALYST = :F, C.ADHOC_INDC = ''HIGH''';
    SQL_STMT := SQL_STMT||'     where exists ( select 1 ';
    SQL_STMT := SQL_STMT||'                   from LA_ASSIGNMENT a, ';
    SQL_STMT := SQL_STMT||'  TABLE(SELECT LA_CLIENT_QUEUE_LISTS.HIGH_QUEUE ';
    SQL_STMT := SQL_STMT||'       FROM LA_CLIENT_QUEUE_LISTS ';
    SQL_STMT := SQL_STMT||'       WHERE LA_CLIENT_QUEUE_LISTS.pid = :G) b ';
    SQL_STMT := SQL_STMT||' where Upper(trim(a.CLIENT_CODE)) = Upper(TRIM(b.CLIENT_code )) ';
    SQL_STMT := SQL_STMT||'  and  a.dispute_id = c.dispute_id) ';
    SQL_STMT := SQL_STMT||'  and nvl(c.PROCESSOR_ID,0) = 0 ';
    SQL_STMT := SQL_STMT||'  and c.QUEUE_NAME = ''HIGH'' ';
    SQL_STMT := SQL_STMT||'  and c.APPROVAL in (''Not Approved'') ';

    EXECUTE IMMEDIATE SQL_STMT using r1.pid, R1.LOGIN,  r1.pid;
    HI_CNT := SQL%ROWCOUNT;

    COMMIT;

    SQL_STMT := ' UPDATE LA_ASSIGNMENT c ';
    SQL_STMT := SQL_STMT||' SET c.QUEUE_ID = :E,  c.LOSS_ANALYST = :F, C.ADHOC_INDC = ''LOW''';
    SQL_STMT := SQL_STMT||'     where exists ( select 1 ';
    SQL_STMT := SQL_STMT||'                   from LA_ASSIGNMENT a, ';
    SQL_STMT := SQL_STMT||'  TABLE(SELECT LA_CLIENT_QUEUE_LISTS.LOW_QUEUE ';
    SQL_STMT := SQL_STMT||'       FROM LA_CLIENT_QUEUE_LISTS ';
    SQL_STMT := SQL_STMT||'       WHERE LA_CLIENT_QUEUE_LISTS.pid = :F) b ';
    SQL_STMT := SQL_STMT||' where Upper(trim(a.CLIENT_CODE)) = Upper(TRIM(b.CLIENT_code )) ';
    SQL_STMT := SQL_STMT||'  and  a.dispute_id = c.dispute_id) ';
    SQL_STMT := SQL_STMT||'  and nvl(c.PROCESSOR_ID,0) = 0 ';
    SQL_STMT := SQL_STMT||'  and c.QUEUE_NAME = ''LOW'' ';
    SQL_STMT := SQL_STMT||'  AND c.APPROVAL  in (''Not Approved'')  ';

    EXECUTE IMMEDIATE SQL_STMT using r1.pid, r1.login, r1.pid;
    LO_CNT := SQL%ROWCOUNT;

    COMMIT;

   CNT := CNT + HI_CNT + LO_CNT;

   END LOOP;
CLOSE C1;


                INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'RESET_QUEUES', SYSDATE, CNT, 'LA_ASSIGNMENT QUEUE ID(s) updated');
        COMMIT;

EXCEPTION
  WHEN OTHERS THEN
  CNT  := SQLCODE;
  MSG  := SQLERRM;

                INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'RESET_QUEUES', SYSDATE, CNT, MSG);
        COMMIT;


END;



PROCEDURE SAVE_REVIEW_QUEUE ( P_REVIEW_LIST VARCHAR2, P_PID NUMBER )
is
    CLIENTCODES   apex_application_global.vc_arr2;
    cnt        number;
    SQL_STMT   VARCHAR2(32000);
begin

     cnt := 0;

     BEGIN
          DELETE TABLE(SELECT LA_CLIENT_QUEUE_LISTS.REV_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID);
          COMMIT;
     END;


    CLIENTCODES := apex_util.string_to_table (P_REVIEW_LIST);

    for i in 1..CLIENTCODES.count
    loop
         if ( CLIENTCODES(i) is not null ) then
             cnt := cnt + 1;

            SQL_STMT := ' INSERT INTO TABLE(SELECT LA_CLIENT_QUEUE_LISTS.REV_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = :A )';
            SQL_STMT := SQL_STMT||' VALUES ('''||CLIENTCODES(i)||''' )';

            BEGIN
            EXECUTE IMMEDIATE SQL_STMT USING P_PID;
            EXCEPTION
                  WHEN OTHERS THen
                     NULL;
            END;

         end if;


        commit;
    end loop;

    IF (cnt > 0) THEN
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.REV_QUE_CNT = CNT  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    ELSE
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.REV_QUE_CNT = 0  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    END IF;


COMMIT;


end;


PROCEDURE SAVE_ADHOC_QUEUE ( P_ADHOC_LIST VARCHAR2, P_PID NUMBER )
is
    CLIENTCODES   apex_application_global.vc_arr2;
    cnt        number;
    SQL_STMT   VARCHAR2(32000);
begin

     cnt := 0;

     BEGIN
          DELETE TABLE(SELECT LA_CLIENT_QUEUE_LISTS.ADH_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID);
          COMMIT;
     END;


    CLIENTCODES := apex_util.string_to_table (P_ADHOC_LIST);

    for i in 1..CLIENTCODES.count
    loop
         if ( CLIENTCODES(i) is not null ) then
             cnt := cnt + 1;

            SQL_STMT := ' INSERT INTO TABLE(SELECT LA_CLIENT_QUEUE_LISTS.ADH_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = :A )';
            SQL_STMT := SQL_STMT||' VALUES ('''||CLIENTCODES(i)||''' )';

            BEGIN
            EXECUTE IMMEDIATE SQL_STMT USING P_PID;
            EXCEPTION
                  WHEN OTHERS THen
                     NULL;
            END;

         end if;


        commit;
    end loop;

    IF (cnt > 0) THEN
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.ADH_QUE_CNT = CNT  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    ELSE
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.ADH_QUE_CNT = 0  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    END IF;


COMMIT;


end;

PROCEDURE UPDATE_HIGH_QUEUES ( P_PID NUMBER)
IS

SQL_STMT VARCHAR2(32000);
CNT      NUMBER;


BEGIN
    SQL_STMT := ' UPDATE LA_ASSIGNMENT c ';
    SQL_STMT := SQL_STMT||' SET c.QUEUE_ID = :E ';
    SQL_STMT := SQL_STMT||'     where exists ( select 1 ';
    SQL_STMT := SQL_STMT||'                   from LA_ASSIGNMENT a, ';
    SQL_STMT := SQL_STMT||'  TABLE(SELECT LA_CLIENT_QUEUE_LISTS.HIGH_QUEUE ';
    SQL_STMT := SQL_STMT||'       FROM LA_CLIENT_QUEUE_LISTS ';
    SQL_STMT := SQL_STMT||'       WHERE LA_CLIENT_QUEUE_LISTS.pid = :F) b ';
    SQL_STMT := SQL_STMT||' where Upper(trim(a.CLIENT_CODE)) = Upper(TRIM(b.CLIENT_code )) ';
    SQL_STMT := SQL_STMT||'  and  a.dispute_id = c.dispute_id) ';
    SQL_STMT := SQL_STMT||'  and nvl(c.PROCESSOR_ID,0) = 0 ';
    SQL_STMT := SQL_STMT||'  and c.QUEUE_NAME = ''HIGH'' ';
    SQL_STMT := SQL_STMT||'  and c.APPROVAL IS NULL ';

    EXECUTE IMMEDIATE SQL_STMT using P_PID, P_PID;
    CNT := SQL%ROWCOUNT;

    COMMIT;

END;

PROCEDURE SAVE_ADHOC_INDC ( P_PID NUMBER )
IS

CURSOR C1 (USER_ID NUMBER)
IS
select CLIENT_CODE
FROM LA_ASSIGNMENT
where ADHOC_INDC  = 'Y'
AND   QUEUE_ID =  USER_ID
AND  PROCESSOR_ID IS NULL
GROUP BY CLIENT_CODE
UNION
SELECT B.CLIENT_CODE
FROM TABLE(SELECT LA_CLIENT_QUEUE_LISTS.ADH_QUEUE
      FROM LA_CLIENT_QUEUE_LISTS
      WHERE LA_CLIENT_QUEUE_LISTS.pid = USER_ID) b;

R1  C1%ROWTYPE;

SQL_STMT VARCHAR2(32000);
CNT      NUMBER;


BEGIN
CNT   := 0;

     BEGIN
          DELETE TABLE(SELECT LA_CLIENT_QUEUE_LISTS.ADH_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID);
          COMMIT;
     END;


      OPEN C1(P_PID);
          LOOP
             FETCH C1 INTO R1;
             EXIT WHEN C1%NOTFOUND;
                SQL_STMT := ' INSERT INTO TABLE(SELECT LA_CLIENT_QUEUE_LISTS.ADH_QUEUE FROM LA_CLIENT_QUEUE_LISTS  WHERE LA_CLIENT_QUEUE_LISTS.pid = :A )';
                SQL_STMT := SQL_STMT||' VALUES ('''||R1.CLIENT_CODE||''' )';

                BEGIN
                EXECUTE IMMEDIATE SQL_STMT USING P_PID;
                EXCEPTION
                      WHEN OTHERS THen
                         NULL;
                END;

               CNT := CNT + 1;
               COMMIT;

          END LOOP;
     CLOSE C1;

    IF (cnt > 0) THEN
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.ADH_QUE_CNT = CNT  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    ELSE
        UPDATE LA_CLIENT_QUEUE_LISTS SET  LA_CLIENT_QUEUE_LISTS.ADH_QUE_CNT = 0  WHERE LA_CLIENT_QUEUE_LISTS.pid = P_PID;
    END IF;

COMMIT;

END;


PROCEDURE SPECIAL_ASSIGNMENT ( P_APP_ID NUMBER,  P_PAGE_ID NUMBER, P_APPL_USER VARCHAR2, P_ASSIGN_TO VARCHAR2, P_CURTAIL_DATE DATE, P_TABLE VARCHAR2, P_TAG VARCHAR2,  P_MESSAGE OUT VARCHAR2)
IS

CURSOR C1 (APP_ID NUMBER,  PAGE_ID NUMBER, APPL_USER VARCHAR2, TAB_NAME VARCHAR2, ASSIGN_TO VARCHAR2)
IS
SELECT A.CONDITION_COLUMN_NAME, B.COLUMN_NAME, A.CONDITION_OPERATOR, A.CONDITION_EXPRESSION, A.CONDITION_EXPRESSION2, B.DATA_TYPE, C.USER_ID
  from APEX_APPLICATION_PAGE_IR_COND A
  LEFT JOIN ( SELECT DATA_TYPE, COLUMN_NAME  FROM ALL_TAB_COLUMNS  WHERE TABLE_NAME =  TAB_NAME ) B  ON ( A.CONDITION_COLUMN_NAME =   B.COLUMN_NAME)
  LEFT JOIN ( SELECT UPPER(LOGIN) AS LOGIN , PID AS USER_ID FROM LA_QUEUE_PROCESSORS )  C ON ( C.LOGIN =  UPPER(ASSIGN_TO) )
 where APPLICATION_ID = APP_ID
 AND  APPLICATION_USER = UPPER(APPL_USER);

R1   C1%ROWTYPE;


SQL_STMT    VARCHAR2(32000);
WHR_STMT    VARCHAR2(32000);
TOTAL_WHR   VARCHAR2(32000);
MSG         VARCHAR2(1000);
CNT         NUMBER;
SQLROWCNT   NUMBER;
TAG         VARCHAR2(1000);
CURTAIL_DTE DATE;
P_USER_ID   NUMBER;

BEGIN

CNT := 0;
SQLROWCNT := 0;



       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SPECIAL_ASSIGNMENT', SYSDATE, CNT, 'Starting..');
        COMMIT;

--20160202000000
OPEN C1( P_APP_ID,  P_PAGE_ID, P_APPL_USER, P_TABLE, P_ASSIGN_TO);
     loop
          FETCH C1 INTO R1;
          exit when C1%notfound;

          CNT := CNT + 1;
          WHR_STMT := CASE WHEN R1.DATA_TYPE IN ('DATE') AND UPPER(R1.CONDITION_OPERATOR) IN ('BETWEEN') THEN  ' '||R1.CONDITION_COLUMN_NAME||' BETWEEN  TO_DATE( '||R1.CONDITION_EXPRESSION||',''YYYYMMDDHH24MISS'')'||' AND TO_DATE( '||R1.CONDITION_EXPRESSION2||',''YYYYMMDDHH24MISS'')'
                           WHEN R1.DATA_TYPE IN ('DATE') AND UPPER(R1.CONDITION_OPERATOR) NOT IN ('BETWEEN' ) THEN  ' '||R1.CONDITION_COLUMN_NAME||' '||R1.CONDITION_OPERATOR||' TO_DATE( '||R1.CONDITION_EXPRESSION||',''YYYYMMDDHH24MISS'')'
                           WHEN R1.DATA_TYPE IN ('VARCHAR2') AND UPPER(R1.CONDITION_OPERATOR) IN ('LIKE') THEN  ' '||R1.CONDITION_COLUMN_NAME||' LIKE '''||R1.CONDITION_EXPRESSION||''' '
                           WHEN R1.DATA_TYPE IN ('VARCHAR2') AND UPPER(R1.CONDITION_OPERATOR) NOT IN ('LIKE') THEN  ' '||R1.CONDITION_COLUMN_NAME||' '||R1.CONDITION_OPERATOR||' '''||R1.CONDITION_EXPRESSION||''' '
                           WHEN R1.DATA_TYPE IN ('NUMBER') AND UPPER(R1.CONDITION_OPERATOR) IN ('BETWEEN') THEN  ' '||R1.CONDITION_COLUMN_NAME||'  BETWEEN '||R1.CONDITION_EXPRESSION||' AND '||R1.CONDITION_EXPRESSION2

                      END;

          TAG := R1.COLUMN_NAME;

          P_USER_ID := R1.USER_ID;

          TOTAL_WHR := TOTAL_WHR||WHR_STMT||' AND';

     end loop;
CLOSE C1;


SQL_STMT := 'UPDATE '||P_TABLE||'  SET QUEUE_ID = '||P_USER_ID||', LOSS_ANALYST = :A , ADHOC_INDC =  :B  WHERE  nvl(PROCESSOR_ID,0) = 0  AND ';


        IF ( P_CURTAIL_DATE IS NOT NULL)
          THEN
                SQL_STMT := 'UPDATE '||P_TABLE||'  SET QUEUE_ID = '||P_USER_ID||', LOSS_ANALYST = :A , ADHOC_INDC =  :B, CURTAIL_DATE = :C  WHERE  nvl(PROCESSOR_ID,0) = 0  AND ';
        END IF;


TOTAL_WHR := RTRIM(TOTAL_WHR,'AND');


SQL_STMT := SQL_STMT||TOTAL_WHR;

--insert into show_stmt values (sql_stmt);
--commit;


TAG := CASE WHEN P_TAG IS NULL  THEN TAG||'-No-Tag' else P_TAG END;


  IF ( P_CURTAIL_DATE IS NOT NULL)
    THEN

      EXECUTE IMMEDIATE SQL_STMT USING P_ASSIGN_TO, TAG, P_CURTAIL_DATE;
 ELSE
      EXECUTE IMMEDIATE SQL_STMT USING P_ASSIGN_TO, TAG;

 END IF;


SQLROWCNT  := SQL%ROWCOUNT;

COMMIT;

P_MESSAGE := SQLROWCNT||' Records were assigned to '||P_ASSIGN_TO;


       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SPECIAL_ASSIGNMENT', SYSDATE, SQLROWCNT, SQLROWCNT||' records were assigned to '||P_ASSIGN_TO);
        COMMIT;



EXCEPTION
    WHEN OTHERS THEN
    P_MESSAGE := SUBSTR(SQLERRM,1, 200);
    SQLROWCNT := SQLCODE;
    MSG       := SQLERRM;

       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SPECIAL_ASSIGNMENT', SYSDATE, SQLROWCNT, MSG);
        COMMIT;

END;


PROCEDURE ASSIGN_HIGH_LOW ( P_INVOICE_AMT number)
IS

/*
TYPE LA_SCORING IS RECORD (
     DISPUTE_ID          DBMS_SQL.NUMBER_TABLE,
     Invoice_Amt         DBMS_SQL.VARCHAR2_TABLE,
     QUEUE_NAME          DBMS_SQL.VARCHAR2_TABLE
);
*/

S   LA_FILE_PROCESS.LA_SCORING;
GC  GenRefCursor;

SQL_STMT   VARCHAR2(32000 BYTE);
UPD_STMT   VARCHAR2(32000 BYTE);
MSG        VARCHAR2(1000  BYTE);
CNT        NUMBER;
SQLROWCNT  NUMBER;

BEGIN

CNT := 0;
SQLROWCNT := 0;

       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'ASSIGN_HIGH_LOW', SYSDATE, CNT, 'Starting..');
        COMMIT;

SQL_STMT := 'SELECT DISPUTE_ID, INVOICE_AMT, CASE WHEN INVOICE_AMT > :A THEN ''HIGH'' ELSE ''LOW'' END AS QUEUE_NAME, ROWID ';
SQL_STMT := SQL_STMT||' FROM( select DISPUTE_ID, to_number(replace(replace(INVOICE_AMT,''$'',''''),'','','''')) as invoice_amt, ROWID from LA_ASSIGNMENT where queue_name is null)';

UPD_STMT := 'UPDATE LA_ASSIGNMENT SET QUEUE_NAME = :A WHERE ROWID = :B';
OPEN GC FOR SQL_STMT USING P_INVOICE_AMT;

LOOP
    FETCH GC BULK COLLECT INTO S.DISPUTE_ID, S.INVOICE_AMT, S.QUEUE_NAME, S.ROWIDS LIMIT 10000;
    EXIT WHEN S.DISPUTE_ID.COUNT = 0;
    SQLROWCNT := SQLROWCNT +  S.DISPUTE_ID.COUNT;
    FORALL I IN 1..S.DISPUTE_ID.COUNT
    EXECUTE IMMEDIATE UPD_STMT USING S.QUEUE_NAME(I), S.ROWIDS(I);

    COMMIT;

END LOOP;

       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'ASSIGN_HIGH_LOW', SYSDATE, SQLROWCNT, 'Disputes updated');
        COMMIT;


EXCEPTION
    WHEN OTHERS THEN
    SQLROWCNT := SQLCODE;
    MSG       := SQLERRM;

       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'ASSIGN_HIGH_LOW', SYSDATE, SQLROWCNT, MSG);
        COMMIT;

END;
/*****************************************************************************
  PURPOSE
  1  clear out LA_ASSIGNED_PREV
  2. copy LA_ASSIGNMENT TO LA_ASSIGNED_PREV
  3. copy files that were just loaded into LA_ASSIGNED_PREV
  4. dedupe keeping the copy of yesterday's work first (THE ASSIGNED)
  5. insert the not assigned into LA_ASSIGNMENT
  process_no determines the difference between the 7 daily and adhoc reports.
*******************************************************************************/
PROCEDURE GATHER_NEW_REPORTS
IS

CURSOR C1
IS
select A.PID, A.FILE_TYPE, A.FILE_NAME, A.RECORDCNT, A.LOAD_DATE, A.LOADED_BY, A.COMMENTS, A.BEGIN_LOAD_ID, A.END_LOAD_ID, A.LOADED, A.PROCESS_NO
from  LA_FILES_LOADED_LIST A
WHERE A.LOADED = 2;
R1  C1%ROWTYPE;

  SQL_STMT  VARCHAR2(32000);
  SQLROWCNT NUMBER;
  RCODE     NUMBER;
  MSG       VARCHAR2(1000);

BEGIN


      SQL_STMT := 'TRUNCATE TABLE LA_ASSIGNED_PREV DROP STORAGE';
      execute immediate sql_stmt;

------------ we are not considering yesterdays assignment DATA NOW 01/09/2017
/**********************************************************************

      SQL_STMT := 'INSERT INTO LA_ASSIGNED_PREV  ';
      SQL_STMT := SQL_STMT||' (ADHOC_INDC,ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,';
      SQL_STMT := SQL_STMT||' DISPUTE_ID,DISPUTE_TYPE,IM_ICLEAR_NBR,INVOICE_AMT,INVOICE_DATE,INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,';
      SQL_STMT := SQL_STMT||' RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,X_DISPUTED,FILE_ID, LOAD_ID)';
      SQL_STMT := SQL_STMT||' SELECT  ';
      SQL_STMT := SQL_STMT||' ADHOC_INDC,ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,';
      SQL_STMT := SQL_STMT||' DISPUTE_ID,DISPUTE_TYPE,IM_ICLEAR_NBR,INVOICE_AMT,INVOICE_DATE,INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,';
      SQL_STMT := SQL_STMT||' RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,X_DISPUTED, FILE_ID, LOAD_ID ';
      SQL_STMT := SQL_STMT||' FROM LA_ASSIGNMENT ';
      EXECUTE IMMEDIATE SQL_STMT;
      SQLROWCNT := SQL%ROWCOUNT;
      COMMIT;
****************************************************************/
OPEN C1;
  LOOP
     FETCH C1 INTO R1;
     EXIT WHEN C1%NOTFOUND;
   IF (R1.PROCESS_NO IN (1) )
     THEN
/******************************************************************

      OUTSTANDING ADJUSTED

*******************************************************************/


      IF ( R1.FILE_TYPE IN( 1,8) )
      THEN
              BEGIN


                 SQL_STMT := ' INSERT INTO LA_ASSIGNED_PREV (INVOICE_NBR,IM_ICLEAR_NBR,WORKORDER_NBR,LOAN_NBR,CLIENT_CODE,DISPUTE_AMT,INVOICE_AMT,VENDOR_CODE,INVOICE_DATE, CLIENT_COMMENTS, SOURCE_OF_DISPUTE,CURTAIL_DATE,ADJUSTED_TOTAL,RECEIVED_DATE,FILE_ID, LOAD_ID) ';
                 SQL_STMT := SQL_STMT||'              SELECT INVOICE_NBR,INVOICE_NBR,  WORKORDER_NBR,LOAN_NBR,CLIENT,     DISPUTE_AMT,INVOICE_AMT,VENDOR,TO_DATE(INVOICE_DATE,''MM/DD/YYYY''),''0'',''Outstanding Adjusted'',to_date(CURTAIL_DATE,''MM/DD/YYYY''),ADJUSTED_TOTAL,TO_DATE(EARLIEST_ADJ_DT,''MM/DD/YYYY''),PID,LOAD_ID ';
                 SQL_STMT := SQL_STMT||'  FROM LA_OUTSTANDING_ADJUSTED  WHERE PID = :A';
               EXECUTE IMMEDIATE SQL_STMT USING R1.PID;
               SQLROWCNT := SQL%ROWCOUNT;
               COMMIT;

                        INSERT INTO BOA_PROCESS_LOG
                                    (
                                      PROCESS,
                                      SUB_PROCESS,
                                      ENTRYDTE,
                                      ROWCOUNTS,
                                      MESSAGE
                                    )
                        VALUES ( 'LA_FILE_PROCESS', 'Outstanding Adjusted',SYSDATE, SQLROWCNT, R1.FILE_NAME);
                        COMMIT;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 3, RECORDCNT = SQLROWCNT
                        WHERE PID = R1.PID;
                        COMMIT;


          exception
               when others then
                     RCODE  := sqlcode;
                     MSG    := sqlerrm;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                         WHERE PID = R1.PID;

                        COMMIT;

                        SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.GATHER_NEW_REPORTS',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );

                        INSERT INTO BOA_PROCESS_LOG
                              (
                                PROCESS,
                                SUB_PROCESS,
                                ENTRYDTE,
                                ROWCOUNTS,
                                MESSAGE
                              )
                  VALUES ( 'LA_FILE_PROCESS', 'Outstanding Adjusted', SYSDATE, RCODE, MSG);
                  COMMIT;
          END;
      END IF;

/******************************************************************

      RESOLUTION PENDING


*******************************************************************/

      IF ( R1.FILE_TYPE IN( 2,9) )
      THEN
          BEGIN
--               INVOICE_NBR, IM_ICLEAR_NBR, WORKORDER_NBR, LOAN_NBR, CLIENT_CODE, CLIENT_COMMENTS, DISPUTE_AMT, INVOICE_AMT, WRITE_OFF, VENDOR_CODE, CHARGE_BACK_AMT_1, APPROVAL, PENDING_RESEARCH, APPEAL, DISPUTE_APPEAL_COMMENT, DEPARTMENT, CLIENT_EMPL, BUCKET, INVOICE_DATE, X_DISPUTED, DISPUTE_TYPE, SOURCE_OF_DISPUTE, CURTAIL_DATE, LAST_UPDATED, COMMENTS, RECEIVED_DATE, WORK_CODE, ADJUSTED_TOTAL, MONTH_DATE, LOSS_ANALYST, PROCESSOR_ID, QUEUE_NAME, QUEUE_ID, DISPUTE_ID, LOAD_DATE, REVIEW_QUEUE, ADHOC_INDC, REVIEWER_ID, FILE_ID, LOAD_ID
                SQL_STMT := 'INSERT INTO LA_ASSIGNED_PREV (INVOICE_NBR, IM_ICLEAR_NBR, WORKORDER_NBR, LOAN_NBR, CLIENT_CODE, CLIENT_COMMENTS, RECEIVED_DATE,                       INVOICE_AMT,    DISPUTE_AMT, ADJUSTED_TOTAL, INVOICE_DATE,  SOURCE_OF_DISPUTE, CURTAIL_DATE, FILE_ID, LOAD_ID) ';
                SQL_STMT := SQL_STMT||'            SELECT  INVOICE_NBR, INVOICE_NBR,   ORDER_NBR,     LOAN_NBR, CLIENT,      CLIENT_COMMENT,  TO_DATE(CLIENT_DATE,''MM/DD/YYYY''), INVOICE_AMT,    INVOICE_AMT, 0,TO_DATE(INVOICE_DATE,''MM/DD/YYYY''),''Res Pending'' AS SOURCE_OF_DISPUTE, TO_DATE(CURTAIL_DATE,''MM/DD/YYYY''), PID, LOAD_ID';
                SQL_STMT := SQL_STMT||' FROM LA_RESOLUTION_PENDING  WHERE PID = :A ';

                EXECUTE IMMEDIATE SQL_STMT USING R1.PID;
                SQLROWCNT := SQL%ROWCOUNT;
                COMMIT;


                        INSERT INTO BOA_PROCESS_LOG
                                    (
                                      PROCESS,
                                      SUB_PROCESS,
                                      ENTRYDTE,
                                      ROWCOUNTS,
                                      MESSAGE
                                    )
                        VALUES ( 'LA_FILE_PROCESS', 'RESOLUTION PENDING',SYSDATE, SQLROWCNT, R1.FILE_NAME);
                        COMMIT;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 3, RECORDCNT = SQLROWCNT
                        WHERE PID = R1.PID;
                        COMMIT;


          exception
               when others then
                     RCODE  := sqlcode;
                     MSG    := sqlerrm;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                         WHERE PID = R1.PID;

                        COMMIT;

                        SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.GATHER_NEW_REPORTS',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );

                        INSERT INTO BOA_PROCESS_LOG
                              (
                                PROCESS,
                                SUB_PROCESS,
                                ENTRYDTE,
                                ROWCOUNTS,
                                MESSAGE
                              )
                  VALUES ( 'LA_FILE_PROCESS', 'GATHER_NEW_REPORTS', SYSDATE, RCODE, MSG);
                  COMMIT;
          END;
      END IF;
/******************************************************************

      PENDING APPROVAL MASTER

*******************************************************************/
      IF ( R1.FILE_TYPE = 3)
      THEN
          BEGIN
--
                SQL_STMT := 'INSERT INTO LA_ASSIGNED_PREV (INVOICE_NBR, IM_ICLEAR_NBR, WORKORDER_NBR, LOAN_NBR, CLIENT_CODE, CLIENT_COMMENTS,RECEIVED_DATE,INVOICE_AMT, DISPUTE_AMT, INVOICE_DATE, APPEAL, SOURCE_OF_DISPUTE, CURTAIL_DATE, ADJUSTED_TOTAL, FILE_ID, LOAD_ID) ';
                SQL_STMT := SQL_STMT||'  SELECT  INVOICE_NBR,INVOICE_NBR,ORDER_NBR,LOAN_NBR,CLIENT,REASON, TO_DATE(COMMENTS_DATE,''MM/DD/YYYY''), TO_CHAR((REPLACE(REPLACE(INVOICE_AMT,''$'',''''),'','','''') + ADJUSTED_AMT),''$999,999,999.99''),';
                SQL_STMT := SQL_STMT||'  INVOICE_AMT, TO_DATE(INVOICE_DATE,''MM/DD/YYYY HH:MI:SS PM''),LI_DESCRIPTION, ''Pending Approval'' AS SOURCE_OF_DISPUTE,TO_DATE(EXPIRES_IN,''MM/DD/YYYY''), ADJUSTED_AMT, FILE_ID, LOAD_ID ';
                SQL_STMT := SQL_STMT||' FROM LA_PENDING_APPROVAL ';
                SQL_STMT := SQL_STMT||' WHERE FILE_ID = :A ';

                EXECUTE IMMEDIATE SQL_STMT USING R1.PID;
                SQLROWCNT := SQL%ROWCOUNT;
                COMMIT;


                        INSERT INTO BOA_PROCESS_LOG
                                    (
                                      PROCESS,
                                      SUB_PROCESS,
                                      ENTRYDTE,
                                      ROWCOUNTS,
                                      MESSAGE
                                    )
                        VALUES ( 'LA_FILE_PROCESS', 'PENDING APPROVAL',SYSDATE, SQLROWCNT, R1.FILE_NAME);
                        COMMIT;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 3, RECORDCNT = SQLROWCNT
                        WHERE PID = R1.PID;
                        COMMIT;


          exception
               when others then
                     RCODE  := sqlcode;
                     MSG    := sqlerrm;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                         WHERE PID = R1.PID;

                        COMMIT;

                        SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.GATHER_NEW_REPORTS',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );

                        INSERT INTO BOA_PROCESS_LOG
                              (
                                PROCESS,
                                SUB_PROCESS,
                                ENTRYDTE,
                                ROWCOUNTS,
                                MESSAGE
                              )
                  VALUES ( 'LA_FILE_PROCESS', 'GATHER_NEW_REPORTS', SYSDATE, RCODE, MSG);
                  COMMIT;
          END;
      END IF;
/******************************************************************

      PENDING REJECTIONS MASTER

*******************************************************************/
      IF ( R1.FILE_TYPE = 4)
      THEN
          BEGIN
--
                SQL_STMT := 'INSERT INTO LA_ASSIGNED_PREV (INVOICE_NBR, IM_ICLEAR_NBR, WORKORDER_NBR, LOAN_NBR, CLIENT_CODE, CLIENT_COMMENTS,RECEIVED_DATE,INVOICE_AMT,     INVOICE_DATE,SOURCE_OF_DISPUTE,CURTAIL_DATE, FILE_ID, LOAD_ID) ';
                SQL_STMT := SQL_STMT||' SELECT INVOICE_NBR, INVOICE_NBR, ORDER_NBR, LOAN_NBR, CLIENT, SERVICER_COMMENTS, TO_DATE(COMMENTS_DATE,''MM/DD/YYYY''),INVOICE_AMT,  TO_DATE(INVOICE_DATE ,''MM/DD/YYYY''), ''Pending Rejection'' AS SOURCE_OF_DISPUTE,TO_DATE(EXPIRES_IN,''MM/DD/YYYY'') AS CURTAIL_DATE, FILE_ID, LOAD_ID';
                SQL_STMT := SQL_STMT||' FROM LA_PENDING_REJECTIONS ';
                SQL_STMT := SQL_STMT||' WHERE FILE_ID = :A ';

                EXECUTE IMMEDIATE SQL_STMT USING R1.PID;
                SQLROWCNT := SQL%ROWCOUNT;
                COMMIT;


                        INSERT INTO BOA_PROCESS_LOG
                                    (
                                      PROCESS,
                                      SUB_PROCESS,
                                      ENTRYDTE,
                                      ROWCOUNTS,
                                      MESSAGE
                                    )
                        VALUES ( 'LA_FILE_PROCESS', 'PENDING REJECTIONS',SYSDATE, SQLROWCNT, R1.FILE_NAME);
                        COMMIT;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 3, RECORDCNT = SQLROWCNT
                        WHERE PID = R1.PID;
                        COMMIT;


          exception
               when others then
                     RCODE  := sqlcode;
                     MSG    := sqlerrm;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                         WHERE PID = R1.PID;

                        COMMIT;

                        SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.GATHER_NEW_REPORTS',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );

                        INSERT INTO BOA_PROCESS_LOG
                              (
                                PROCESS,
                                SUB_PROCESS,
                                ENTRYDTE,
                                ROWCOUNTS,
                                MESSAGE
                              )
                  VALUES ( 'LA_FILE_PROCESS', 'GATHER_NEW_REPORTS', SYSDATE, RCODE, MSG);
                  COMMIT;
          END;
      END IF;

/******************************************************************

      UAT Master - CARDS

*******************************************************************/
      IF ( R1.FILE_TYPE = 5)
      THEN
          BEGIN

                SQL_STMT := ' INSERT INTO  LA_ASSIGNED_PREV (APPROVAL,CHARGE_BACK_AMT_1,CLIENT_CODE, CLIENT_COMMENTS,CLIENT_EMPL,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,IM_ICLEAR_NBR,INVOICE_DATE,INVOICE_NBR,LOAN_NBR,RECEIVED_DATE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,FILE_ID,LOAD_ID) ';
                SQL_STMT := SQL_STMT||' SELECT APPROVAL,CHARGEBACK_AMOUNT,CLIENT,CLIENT_COMMENT, CLIENT_EMPLOYEE,DISPUTE_AMT, DISPUTE_APPEAL_COMMENT, DISPUTE_TYPE, INVOICE_NBR, TO_DATE(INVOICE_DATE,''MM/DD/YYYY''),INVOICE_NBR,LOAN_NBR,TO_DATE(RECEIVED_DATE,''MM/DD/YYYY''),SOURCE_OF_DISPUTE,VENDOR_CODE,WORK_ORDER_NBR,DONE_BILLING_CODE,WRITE_OFF,FILE_ID, LOAD_ID ';
                SQL_STMT := SQL_STMT||' FROM LA_IR_ASSIGNMENT ';
                SQL_STMT := SQL_STMT||' WHERE FILE_ID = :A ';

                EXECUTE IMMEDIATE SQL_STMT USING R1.PID;
                SQLROWCNT := SQL%ROWCOUNT;
                COMMIT;


                        INSERT INTO BOA_PROCESS_LOG
                                    (
                                      PROCESS,
                                      SUB_PROCESS,
                                      ENTRYDTE,
                                      ROWCOUNTS,
                                      MESSAGE
                                    )
                        VALUES ( 'LA_FILE_PROCESS', 'CARDS',SYSDATE, SQLROWCNT, R1.FILE_NAME);
                        COMMIT;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 3, RECORDCNT = SQLROWCNT
                        WHERE PID = R1.PID;
                        COMMIT;


          exception
               when others then
                     RCODE  := sqlcode;
                     MSG    := sqlerrm;

                        UPDATE LA_FILES_LOADED_LIST SET LOADED = 9, RECORDCNT = 0
                         WHERE PID = R1.PID;

                        COMMIT;

                        SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.GATHER_NEW_REPORTS',P_SUBJECT=>R1.FILE_NAME ,P_MESSAGE=>MSG );

                        INSERT INTO BOA_PROCESS_LOG
                              (
                                PROCESS,
                                SUB_PROCESS,
                                ENTRYDTE,
                                ROWCOUNTS,
                                MESSAGE
                              )
                  VALUES ( 'LA_FILE_PROCESS', 'GATHER_NEW_REPORTS', SYSDATE, RCODE, MSG);
                  COMMIT;
          END;
      END IF;
   END IF;

   IF ( R1.PROCESS_NO IN (2) )
      THEN
      NULL;
   END IF;

  END LOOP;
CLOSE C1;

--Business rules as follows: (as done in excel)
--Sort report by Client comment and Curtail Date (oldest to newest)
--Removed duplicates based on IM/IClear column


EXECUTE IMMEDIATE 'TRUNCATE TABLE LA_ASSIGNMENT_STAGE DROP STORAGE';
        SQL_STMT :=' INSERT INTO LA_ASSIGNMENT_STAGE (ADHOC_INDC,ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,';
        SQL_STMT := SQL_STMT||'  DISPUTE_TYPE,FILE_ID, IM_ICLEAR_NBR,INVOICE_AMT,INVOICE_DATE,INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,';
        SQL_STMT := SQL_STMT||' REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,X_DISPUTED)';
        SQL_STMT := SQL_STMT||' SELECT ADHOC_INDC,ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,FILE_ID,IM_ICLEAR_NBR,';
        SQL_STMT := SQL_STMT||' INVOICE_AMT,INVOICE_DATE,INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,PICK,QUEUE_NAME,RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,';
        SQL_STMT := SQL_STMT||' WORKORDER_NBR,WORK_CODE,WRITE_OFF,X_DISPUTED';
--
        SQL_STMT := SQL_STMT||' FROM (SELECT ADHOC_INDC, ';
        SQL_STMT := SQL_STMT||' ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,FILE_ID,IM_ICLEAR_NBR,INVOICE_AMT,INVOICE_DATE,';
        SQL_STMT := SQL_STMT||' INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,';
        SQL_STMT := SQL_STMT||' X_DISPUTED, SCORE, RK AS PICK ';
        SQL_STMT := SQL_STMT||' FROM (SELECT ADHOC_INDC,ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,FILE_ID,IM_ICLEAR_NBR,INVOICE_AMT,';
        SQL_STMT := SQL_STMT||' INVOICE_DATE,INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,';
        SQL_STMT := SQL_STMT||' WRITE_OFF,X_DISPUTED,SCORE,RANK () OVER (PARTITION BY IM_ICLEAR_NBR  ORDER BY  CLIENT_COMMENTS, CURTAIL_DATE, ROWNUM) RK ';
--
        SQL_STMT := SQL_STMT||' FROM (SELECT ADHOC_INDC,TRIM (REPLACE (REPLACE (ADJUSTED_TOTAL, ''$'', ''''),'','','''')) AS ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT, ';
        SQL_STMT := SQL_STMT||' TO_NUMBER (TRIM (REPLACE (REPLACE (DISPUTE_AMT, ''$'', ''''),'','',''''))) AS DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,FILE_ID,IM_ICLEAR_NBR,TRIM (REPLACE (REPLACE (INVOICE_AMT, ''$'', ''''),  '','',  '''')) AS INVOICE_AMT,INVOICE_DATE, ';
        SQL_STMT := SQL_STMT||' INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,X_DISPUTED,';
        SQL_STMT := SQL_STMT||' CASE WHEN QUEUE_NAME IS NOT NULL THEN 1 ELSE 2 END AS SCORE';
        SQL_STMT := SQL_STMT||' FROM LA_ASSIGNED_PREV)) ';
        SQL_STMT := SQL_STMT||' )    WHERE PICK = 1';

EXECUTE IMMEDIATE SQL_STMT;

SQLROWCNT := SQL%ROWCOUNT;
COMMIT;


INSERT INTO BOA_PROCESS_LOG
            (
              PROCESS,
              SUB_PROCESS,
              ENTRYDTE,
              ROWCOUNTS,
              MESSAGE
            )
VALUES ( 'LA_FILE_PROCESS', 'GATHER_NEW_REPORTS',SYSDATE, SQLROWCNT, 'FILES LOADED');
COMMIT;



exception
     when others then
           RCODE  := sqlcode;
           MSG    := sqlerrm;

              SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.GATHER_NEW_REPORTS',P_SUBJECT=>'Process issue' ,P_MESSAGE=>MSG );

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'GATHER_NEW_REPORTS', SYSDATE, RCODE, MSG);
        COMMIT;

END;
/**************************************************************************

 **************************************************************************/
PROCEDURE ADJUST_CURTAIL_DATE
IS

CURSOR C1 (ADJ VARCHAR2)
IS
SELECT ADJUST_BY, FIELD_VALUE, ADJUST_STMT, STATUS
FROM LA_CURTAIL_DATE_ADJ
WHERE STATUS IN ('Active')
AND   ADJUST_BY = ADJ;

R1    C1%ROWTYPE;

GC   LA_FILE_PROCESS.GenRefCursor;
LAS  LA_FILE_PROCESS.LA_ASSIGNMENT_STG;
LAW  LA_FILE_PROCESS.LA_ASSIGNMENT_WRK;
LKY  LA_FILE_PROCESS.LA_keys;
CD   LA_FILE_PROCESS.CDATE;


SQL_STMT  VARCHAR2(32000 BYTE);
CC_STMT   VARCHAR2(32000 BYTE);
DA_STMT   VARCHAR2(32000 BYTE);
IA_STMT   VARCHAR2(32000 BYTE);
TA_STMT   VARCHAR2(32000 BYTE);
UP_STMT   VARCHAR2(32000 BYTE);
MSG       VARCHAR2(1000 BYTE);

tot       NUMBER;
WK        NUMBER;
WK_DATE   DATE;
WK_ID     NUMBER;
RCODE     NUMBER;

BEGIN

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'ADJUST_CURTAIL_DATE', SYSDATE, 0, 'Step Starting');
        COMMIT;

UP_STMT := 'UPDATE LA_ASSIGNMENT_STAGE SET CURTAIL_DATE = :A WHERE ROWID = :B';

EXECUTE IMMEDIATE 'TRUNCATE TABLE LA_ASSIGNMENT_STAGE DROP STORAGE';

/*
   Pull just the unique transactions new to the process
   disptues without a queue name are ranked second to ones with
   so pull the winners with rank of two
   Stage has amount fields in number format
 */
/* Formatted on 6/16/2016 9:21:29 AM (QP5 v5.185.11230.41888) */
        SQL_STMT :=' INSERT INTO LA_ASSIGNMENT_STAGE (ADHOC_INDC,ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,';
        SQL_STMT := SQL_STMT||'  DISPUTE_TYPE,FILE_ID, IM_ICLEAR_NBR,INVOICE_AMT,INVOICE_DATE,INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,';
        SQL_STMT := SQL_STMT||'  REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,X_DISPUTED)';
        SQL_STMT := SQL_STMT||'  SELECT ADHOC_INDC,ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,FILE_ID,IM_ICLEAR_NBR,';
        SQL_STMT := SQL_STMT||'  INVOICE_AMT,INVOICE_DATE,INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,';
        SQL_STMT := SQL_STMT||'  WORKORDER_NBR,WORK_CODE,WRITE_OFF,X_DISPUTED';
        SQL_STMT := SQL_STMT||'  FROM (SELECT ADHOC_INDC, ';
        SQL_STMT := SQL_STMT||'  ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,FILE_ID,IM_ICLEAR_NBR,INVOICE_AMT,INVOICE_DATE,';
        SQL_STMT := SQL_STMT||'  INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,';
        SQL_STMT := SQL_STMT||'  X_DISPUTED,SCORE,RK AS PICK ';
        SQL_STMT := SQL_STMT||'  FROM (SELECT ADHOC_INDC,ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT,DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,FILE_ID,IM_ICLEAR_NBR,INVOICE_AMT,';
        SQL_STMT := SQL_STMT||'  INVOICE_DATE,INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,';
        SQL_STMT := SQL_STMT||'  WRITE_OFF,X_DISPUTED,SCORE,RANK () OVER (PARTITION BY INVOICE_NBR,WORKORDER_NBR,LOAN_NBR,CLIENT_COMMENTS ORDER BY SCORE, CURTAIL_DATE, ROWNUM) RK ';
        SQL_STMT := SQL_STMT||'  FROM (SELECT ADHOC_INDC,TRIM (REPLACE (REPLACE (ADJUSTED_TOTAL, ''$'', ''''),'','','''')) AS ADJUSTED_TOTAL,APPEAL,APPROVAL,BUCKET,CHARGE_BACK_AMT_1,CLIENT_CODE,CLIENT_COMMENTS,CLIENT_EMPL,COMMENTS,CURTAIL_DATE,DEPARTMENT, ';
        SQL_STMT := SQL_STMT||'  TO_NUMBER (TRIM (REPLACE (REPLACE (DISPUTE_AMT, ''$'', ''''),'','',''''))) AS DISPUTE_AMT,DISPUTE_APPEAL_COMMENT,DISPUTE_TYPE,FILE_ID,IM_ICLEAR_NBR,TRIM (REPLACE (REPLACE (INVOICE_AMT, ''$'', ''''),  '','',  '''')) AS INVOICE_AMT,INVOICE_DATE, ';
        SQL_STMT := SQL_STMT||'  INVOICE_NBR,LAST_UPDATED,LOAD_DATE,LOAD_ID,LOAN_NBR,LOSS_ANALYST,MONTH_DATE,PENDING_RESEARCH,PROCESSOR_ID,QUEUE_ID,QUEUE_NAME,RECEIVED_DATE,REVIEWER_ID,REVIEW_QUEUE,SOURCE_OF_DISPUTE,VENDOR_CODE,WORKORDER_NBR,WORK_CODE,WRITE_OFF,X_DISPUTED,';
        SQL_STMT := SQL_STMT||'  CASE WHEN QUEUE_NAME IS NOT NULL THEN 1 ELSE 2 END AS SCORE';
        SQL_STMT := SQL_STMT||'  FROM LA_ASSIGNED_PREV))';
        SQL_STMT := SQL_STMT||'  WHERE RK = 1)';
        SQL_STMT := SQL_STMT||' WHERE SCORE = 2  ';

EXECUTE IMMEDIATE SQL_STMT;

COMMIT;

/*
TYPE LA_ASSIGNMENT_STAGE IS RECORD (
DISPUTE_ID     DBMS_SQL.NUMBER_TABLE,
CURTAIL_DATE   DBMS_SQL.DATE_TABLE,
CLIENT_CODE    DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_AMT    DBMS_SQL.NUMBER_TABLE,
INVOICE_AMT    DBMS_SQL.NUMBER_TABLE,
ADJUSTED_TOTAL DBMS_SQL.NUMBER_TABLE,
ROWIDS         rowidArray
);

TYPE LA_ASSIGNMENT_WORK IS RECORD (
DISPUTE_ID     DBMS_SQL.NUMBER_TABLE,
CURTAIL_DATE   DBMS_SQL.DATE_TABLE,
CLIENT_CODE    DBMS_SQL.VARCHAR2_TABLE,
DISPUTE_AMT    DBMS_SQL.NUMBER_TABLE,
INVOICE_AMT    DBMS_SQL.NUMBER_TABLE,
ADJUSTED_TOTAL DBMS_SQL.NUMBER_TABLE,
ROWIDS         rowidArray
);

load ALL THE DATE INTO LAS
LOAD BY CRITERIA INTO LAW
UPDATE LAS
UPDATE TABLE WITH LAS


*/



DA_STMT  := ' SELECT DISPUTE_ID, CURTAIL_DATE, CLIENT_CODE,  DISPUTE_AMT, INVOICE_AMT, ADJUSTED_TOTAL, ROWID FROM LA_ASSIGNMENT_STAGE WHERE DISPUTE_AMT IS NOT NULL ORDER BY DISPUTE_ID';
CC_STMT  := ' SELECT DISPUTE_ID, CURTAIL_DATE, CLIENT_CODE,  DISPUTE_AMT, INVOICE_AMT, ADJUSTED_TOTAL, ROWID FROM LA_ASSIGNMENT_STAGE WHERE CLIENT_CODE = :C ORDER BY DISPUTE_ID';
SQL_STMT := ' SELECT DISPUTE_ID, CURTAIL_DATE, CLIENT_CODE,  DISPUTE_AMT, INVOICE_AMT, ADJUSTED_TOTAL, ROWID FROM LA_ASSIGNMENT_STAGE ORDER BY DISPUTE_ID';

OPEN GC FOR SQL_STMT;
     FETCH GC BULK COLLECT INTO LAS.DISPUTE_ID, LAS.CURTAIL_DATE, LAS.CLIENT_CODE,  LAS.DISPUTE_AMT, LAS.INVOICE_AMT, LAS.ADJUSTED_TOTAL, LAS.ROWIDS;
--- Tot := LAS.DISPUTE_ID.COUNT;

CLOSE GC;

----------------CREATE A ARRAY INDEX BY DISPUTE ID  COPY OF STAGE
FOR I IN 1..LAS.DISPUTE_ID.COUNT LOOP

      LKY.dispute_id(LAS.DISPUTE_ID(i))    := LAS.DISPUTE_ID(i);
      LKY.curtail_date(LAS.DISPUTE_ID(i))  := LAS.CURTAIL_DATE(i);
      LKY.rowids(LAS.DISPUTE_ID(i))        := LAS.ROWIDS(i);

END LOOP;


/*
  pull just the client codes
 */

OPEN C1('CLIENT_CODE');
 LOOP
   FETCH C1 INTO R1;
   EXIT WHEN C1%NOTFOUND;
   OPEN GC FOR CC_STMT USING R1.FIELD_VALUE;
        FETCH GC BULK COLLECT INTO LAW.DISPUTE_ID, LAW.CURTAIL_DATE, LAW.CLIENT_CODE,  LAW.DISPUTE_AMT, LAW.INVOICE_AMT, LAW.ADJUSTED_TOTAL, LAW.ROWIDS;
        wk := LAW.DISPUTE_ID.COUNT;

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'ADJUST_CURTAIL_DATE', SYSDATE, wk, r1.field_value);
        COMMIT;


         FOR W IN 1..wk LOOP


             IF  ( R1.ADJUST_STMT IN ('CURRENT DATE'))
                  THEN
                  WK_DATE := TRUNC(SYSDATE);
             END IF;

             IF  (UPPER(R1.ADJUST_STMT) LIKE '%CURTAIL%' )
                 THEN
                     IF ( INSTR(R1.ADJUST_STMT,'-') > 0 )
                        THEN
                        WK_DATE  := LAW.CURTAIL_DATE(w) - TO_NUMBER(TRIM(TRANSLATE(UPPER(R1.ADJUST_STMT), '-ABCDEFGHIJKLMNOPQRSTUVWXYZ',' ')));
                     END IF;

                     IF ( INSTR(R1.ADJUST_STMT,'+') > 0 )
                        THEN
                        WK_DATE  := LAW.CURTAIL_DATE(w) + TO_NUMBER(TRIM(TRANSLATE(UPPER(R1.ADJUST_STMT), '+ABCDEFGHIJKLMNOPQRSTUVWXYZ',' ')));
                     END IF;

            END IF;


              LAW.CURTAIL_DATE(w) := WK_DATE;

             INSERT INTO LAW_AUDIT ( DISPUTE_ID, ADJUSTED_TOTAL, CLIENT_CODE, CURTAIL_DATE, DISPUTE_AMT,  INVOICE_AMT)
             VALUES(LAW.DISPUTE_ID(W), LAW.ADJUSTED_TOTAL(W), LAW.CLIENT_CODE(W), LAW.CURTAIL_DATE(W), LAW.DISPUTE_AMT(W),  LAW.INVOICE_AMT(w));
             COMMIT;
        END LOOP;
 END LOOP;
CLOSE C1;

  ------------------------------- UPDATE BY DISPUTE_ID
  ------------------------------save a copy in the keys table index by DISPUTE_ID
        FOR W IN 1..wk LOOP

             LKY.curtail_date(LAW.dispute_id(w))  := LAW.curtail_date(W);

        END LOOP;



OPEN C1('DISPUTE_AMT');
 LOOP
   FETCH C1 INTO R1;
   EXIT WHEN C1%NOTFOUND;
   DA_STMT  := ' SELECT DISPUTE_ID, CURTAIL_DATE, CLIENT_CODE,  DISPUTE_AMT, INVOICE_AMT, ADJUSTED_TOTAL, ROWID FROM LA_ASSIGNMENT_STAGE WHERE DISPUTE_AMT '||R1.FIELD_VALUE||' ORDER BY DISPUTE_ID';
   OPEN GC FOR DA_STMT;
        FETCH GC BULK COLLECT INTO LAW.DISPUTE_ID, LAW.CURTAIL_DATE, LAW.CLIENT_CODE,  LAW.DISPUTE_AMT, LAW.INVOICE_AMT, LAW.ADJUSTED_TOTAL, LAW.ROWIDS;
        wk := LAW.DISPUTE_ID.COUNT;

         FOR W IN 1..wk LOOP


             IF  ( R1.ADJUST_STMT IN ('CURRENT DATE'))
                  THEN
                  WK_DATE := TRUNC(SYSDATE);
             END IF;

             IF  (UPPER(R1.ADJUST_STMT) LIKE '%CURTAIL%' )
                 THEN
                     IF ( INSTR(R1.ADJUST_STMT,'-') > 0 )
                        THEN
                        WK_DATE  := LAW.CURTAIL_DATE(w) - TO_NUMBER(TRIM(TRANSLATE(UPPER(R1.ADJUST_STMT), '-ABCDEFGHIJKLMNOPQRSTUVWXYZ',' ')));
                     END IF;

                     IF ( INSTR(R1.ADJUST_STMT,'+') > 0 )
                        THEN
                        WK_DATE  := LAW.CURTAIL_DATE(w) + TO_NUMBER(TRIM(TRANSLATE(UPPER(R1.ADJUST_STMT), '+ABCDEFGHIJKLMNOPQRSTUVWXYZ',' ')));
                     END IF;

            END IF;


              LAW.CURTAIL_DATE(w) := WK_DATE;

             INSERT INTO LAW_AUDIT ( DISPUTE_ID, ADJUSTED_TOTAL, CLIENT_CODE, CURTAIL_DATE, DISPUTE_AMT,  INVOICE_AMT)
             VALUES(LAW.DISPUTE_ID(W), LAW.ADJUSTED_TOTAL(W), LAW.CLIENT_CODE(W), LAW.CURTAIL_DATE(W), LAW.DISPUTE_AMT(W),  LAW.INVOICE_AMT(w));
             COMMIT;
        END LOOP;
 END LOOP;
CLOSE C1;

  ------------------------------- UPDATE KEYS TABLE BY DISPUTE_ID
  ------------------------------ IF what was saved is newer ( greater)  then transaction  6/20/2016 vs 2/15/2016
        FOR W IN 1..wk LOOP

            IF  (LKY.curtail_date(LAW.dispute_id(w)) > LAW.curtail_date(W) )
                THEN
                   LKY.curtail_date(LAW.dispute_id(w))  := LAW.curtail_date(W);
            END IF;

        END LOOP;



OPEN C1('INVOICE_AMT');
 LOOP
   FETCH C1 INTO R1;
   EXIT WHEN C1%NOTFOUND;
               IA_STMT  := ' SELECT DISPUTE_ID, CURTAIL_DATE, CLIENT_CODE,  DISPUTE_AMT, INVOICE_AMT, ADJUSTED_TOTAL, ROWID FROM LA_ASSIGNMENT_STAGE WHERE INVOICE_AMT '||R1.FIELD_VALUE||' ORDER BY DISPUTE_ID';
   OPEN GC FOR IA_STMT;
        FETCH GC BULK COLLECT INTO LAW.DISPUTE_ID, LAW.CURTAIL_DATE, LAW.CLIENT_CODE,  LAW.DISPUTE_AMT, LAW.INVOICE_AMT, LAW.ADJUSTED_TOTAL, LAW.ROWIDS;
        wk := LAW.DISPUTE_ID.COUNT;

         FOR W IN 1..wk LOOP


             IF  ( R1.ADJUST_STMT IN ('CURRENT DATE'))
                  THEN
                  WK_DATE := TRUNC(SYSDATE);
             END IF;

             IF  (UPPER(R1.ADJUST_STMT) LIKE '%CURTAIL%' )
                 THEN
                     IF ( INSTR(R1.ADJUST_STMT,'-') > 0 )
                        THEN
                        WK_DATE  := LAW.CURTAIL_DATE(w) - TO_NUMBER(TRIM(TRANSLATE(UPPER(R1.ADJUST_STMT), '-ABCDEFGHIJKLMNOPQRSTUVWXYZ',' ')));
                     END IF;

                     IF ( INSTR(R1.ADJUST_STMT,'+') > 0 )
                        THEN
                        WK_DATE  := LAW.CURTAIL_DATE(w) + TO_NUMBER(TRIM(TRANSLATE(UPPER(R1.ADJUST_STMT), '+ABCDEFGHIJKLMNOPQRSTUVWXYZ',' ')));
                     END IF;

            END IF;


              LAW.CURTAIL_DATE(w) := WK_DATE;

             INSERT INTO LAW_AUDIT ( DISPUTE_ID, ADJUSTED_TOTAL, CLIENT_CODE, CURTAIL_DATE, DISPUTE_AMT,  INVOICE_AMT)
             VALUES(LAW.DISPUTE_ID(W), LAW.ADJUSTED_TOTAL(W), LAW.CLIENT_CODE(W), LAW.CURTAIL_DATE(W), LAW.DISPUTE_AMT(W),  LAW.INVOICE_AMT(w));
             COMMIT;
        END LOOP;
 END LOOP;
CLOSE C1;

  ------------------------------- UPDATE BY DISPUTE_ID
        FOR W IN 1..wk LOOP

            IF  (LKY.curtail_date(LAW.dispute_id(w)) > LAW.curtail_date(W) )
                THEN
                   LKY.curtail_date(LAW.dispute_id(w))  := LAW.curtail_date(W);
            END IF;

        END LOOP;


OPEN C1('ADJUSTED_TOTAL');
 LOOP
   FETCH C1 INTO R1;
   EXIT WHEN C1%NOTFOUND;
               IA_STMT  := ' SELECT DISPUTE_ID,  CURTAIL_DATE, CLIENT_CODE,  DISPUTE_AMT, INVOICE_AMT, ADJUSTED_TOTAL, ROWID FROM LA_ASSIGNMENT_STAGE WHERE ADJUSTED_TOTAL '||R1.FIELD_VALUE||' ORDER BY DISPUTE_ID';
   OPEN GC FOR IA_STMT;
        FETCH GC BULK COLLECT INTO LAW.DISPUTE_ID, LAW.CURTAIL_DATE, LAW.CLIENT_CODE,  LAW.DISPUTE_AMT, LAW.INVOICE_AMT, LAW.ADJUSTED_TOTAL, LAW.ROWIDS;
        wk := LAW.DISPUTE_ID.COUNT;

         FOR W IN 1..wk LOOP


             IF  ( R1.ADJUST_STMT IN ('CURRENT DATE'))
                  THEN
                  WK_DATE := TRUNC(SYSDATE);
             END IF;

             IF  (UPPER(R1.ADJUST_STMT) LIKE '%CURTAIL%' )
                 THEN
                     IF ( INSTR(R1.ADJUST_STMT,'-') > 0 )
                        THEN
                        WK_DATE  := LAW.CURTAIL_DATE(w) - TO_NUMBER(TRIM(TRANSLATE(UPPER(R1.ADJUST_STMT), '-ABCDEFGHIJKLMNOPQRSTUVWXYZ',' ')));
                     END IF;

                     IF ( INSTR(R1.ADJUST_STMT,'+') > 0 )
                        THEN
                        WK_DATE  := LAW.CURTAIL_DATE(w) + TO_NUMBER(TRIM(TRANSLATE(UPPER(R1.ADJUST_STMT), '+ABCDEFGHIJKLMNOPQRSTUVWXYZ',' ')));
                     END IF;

            END IF;


              LAW.CURTAIL_DATE(w) := WK_DATE;

             INSERT INTO LAW_AUDIT ( DISPUTE_ID, ADJUSTED_TOTAL, CLIENT_CODE, CURTAIL_DATE, DISPUTE_AMT,  INVOICE_AMT)
             VALUES(LAW.DISPUTE_ID(W), LAW.ADJUSTED_TOTAL(W), LAW.CLIENT_CODE(W), LAW.CURTAIL_DATE(W), LAW.DISPUTE_AMT(W),  LAW.INVOICE_AMT(w));
             COMMIT;
        END LOOP;
 END LOOP;
CLOSE C1;

  ------------------------------- UPDATE BY DISPUTE_ID
        FOR W IN 1..wk LOOP

            IF  (LKY.curtail_date(LAW.dispute_id(w)) > LAW.curtail_date(W) )
                THEN
                   LKY.curtail_date(LAW.dispute_id(w))  := LAW.curtail_date(W);
            END IF;

        END LOOP;



/*
       FOR K IN LKY.DISPUTE_ID.FIRST..LKY.DISPUTE_ID.LAST LOOP
            INSERT INTO LKY_AUDIT(DISPUTE_ID, CURTAIL_DATE)
            VALUES ( LKY.DISPUTE_ID(K), LKY.CURTAIL_DATE(K));
            COMMIT;
       END LOOP;
*/


FOR I IN 1..LAS.DISPUTE_ID.COUNT LOOP

       LAS.CURTAIL_DATE(i)  :=  LKY.CURTAIL_DATE(LAS.DISPUTE_ID(i));

END LOOP;

---------------------------------------------
------------------- update stage by rowid  --
---------------------------------------------

FORALL X IN 1..LAS.DISPUTE_ID.COUNT
    EXECUTE IMMEDIATE UP_STMT USING LAS.CURTAIL_DATE(x), LAS.ROWIDS(x);

COMMIT;

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'ADJUST_CURTAIL_DATE', SYSDATE, 0, 'Step complete');
        COMMIT;

------ RATS WE CRASHED...
EXCEPTION
     when others then
           RCODE  := sqlcode;
           MSG    := sqlerrm;

              SEND_EMAIL  (P_TEAM=>'RDM',P_FROM=>'LA_FILE_PROCESS.ADJUST_CURTAIL_DATE',P_SUBJECT=>'Process issue' ,P_MESSAGE=>MSG );

              INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'ADJUST_CURTAIL_DATE', SYSDATE, RCODE, MSG);
        COMMIT;


END;
/*************************************
    SPLIT the new transactions
    into HIGH and LOW groups
 ************************************/
PROCEDURE SET_HIGH_LOW
IS

/*
TYPE LA_SCORING IS RECORD (
     DISPUTE_ID          DBMS_SQL.NUMBER_TABLE,
     Invoice_Amt         DBMS_SQL.VARCHAR2_TABLE,
     QUEUE_NAME          DBMS_SQL.VARCHAR2_TABLE
);
*/

S   LA_FILE_PROCESS.LA_SCORING;
GC  GenRefCursor;

SQL_STMT   VARCHAR2(32000 BYTE);
UPD_STMT   VARCHAR2(32000 BYTE);
MSG        VARCHAR2(1000  BYTE);
AMT        VARCHAR2(100   BYTE);
CNT        NUMBER;
SQLROWCNT  NUMBER;

BEGIN

CNT := 0;
SQLROWCNT := 0;


    SELECT VARIABLE_VALUE
    INTO   AMT
    FROM   LA_SYS_VARIABLES
    WHERE VARIABLE_NAME = 'SET-HIGH';


       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SET_HIGH_LOW', SYSDATE, CNT, 'Starting..');
        COMMIT;

SQL_STMT := 'SELECT DISPUTE_ID, INVOICE_AMT, CASE WHEN INVOICE_AMT > :A THEN ''HIGH'' ELSE ''LOW'' END AS QUEUE_NAME, ROWID ';
SQL_STMT := SQL_STMT||' FROM( select DISPUTE_ID, to_number(invoice_amt) as invoice_amt, ROWID from LA_ASSIGNMENT_STAGE )';

UPD_STMT := 'UPDATE LA_ASSIGNMENT_STAGE SET QUEUE_NAME = :A WHERE ROWID = :B';
OPEN GC FOR SQL_STMT USING AMT;

LOOP
    FETCH GC BULK COLLECT INTO S.DISPUTE_ID, S.INVOICE_AMT, S.QUEUE_NAME, S.ROWIDS LIMIT 10000;
    EXIT WHEN S.DISPUTE_ID.COUNT = 0;
    SQLROWCNT := SQLROWCNT +  S.DISPUTE_ID.COUNT;
    FORALL I IN 1..S.DISPUTE_ID.COUNT
    EXECUTE IMMEDIATE UPD_STMT USING S.QUEUE_NAME(I), S.ROWIDS(I);

    COMMIT;

END LOOP;

       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SET_HIGH_LOW', SYSDATE, SQLROWCNT, 'Disputes updated');
        COMMIT;


EXCEPTION
    WHEN OTHERS THEN
    SQLROWCNT := SQLCODE;
    MSG       := SQLERRM;

       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SET_HIGH_LOW', SYSDATE, SQLROWCNT, MSG);
        COMMIT;

END;
/*************************************
    Assign the new transactions
    to the Analysts
 ************************************/
PROCEDURE SET_QUEUES
IS

CURSOR C1
IS
SELECT PID,
       LOGIN,
       STATUS
FROM LA_QUEUE_PROCESSORS
WHERE STATUS = 'Active'
ORDER BY PID;

R1  C1%ROWTYPE;

SQL_STMT   VARCHAR2(32000);
MSG        VARCHAR2(1000);
HI_CNT     NUMBER;
LO_CNT     NUMBER;
CNT        NUMBER;

BEGIN

CNT    := 0;
HI_CNT := 0;
LO_CNT := 0;

       INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SET_QUEUES', SYSDATE, CNT, 'Starting..');
        COMMIT;

/*******************************************************************
  Have to set / zero everything out.
 *******************************************************************/

    SQL_STMT := 'update LA_ASSIGNMENT_STAGE set queue_id = 0, processor_id = 0 ';
    EXECUTE IMMEDIATE SQL_STMT;

    COMMIT;


OPEN C1;
   LOOP
      FETCH C1 INTO R1;
      EXIT WHEN C1%NOTFOUND;

    SQL_STMT := ' UPDATE LA_ASSIGNMENT_STAGE c ';
    SQL_STMT := SQL_STMT||' SET c.QUEUE_ID = :E,  c.LOSS_ANALYST = :F, C.ADHOC_INDC = ''HIGH''';
    SQL_STMT := SQL_STMT||'     where exists ( select 1 ';
    SQL_STMT := SQL_STMT||'                   from LA_ASSIGNMENT_STAGE a, ';
    SQL_STMT := SQL_STMT||'  TABLE(SELECT LA_CLIENT_QUEUE_LISTS.HIGH_QUEUE ';
    SQL_STMT := SQL_STMT||'       FROM LA_CLIENT_QUEUE_LISTS ';
    SQL_STMT := SQL_STMT||'       WHERE LA_CLIENT_QUEUE_LISTS.pid = :G) b ';
    SQL_STMT := SQL_STMT||' where Upper(trim(a.CLIENT_CODE)) = Upper(TRIM(b.CLIENT_code )) ';
    SQL_STMT := SQL_STMT||'  and  a.dispute_id = c.dispute_id) ';
    SQL_STMT := SQL_STMT||'  and nvl(c.PROCESSOR_ID,0) = 0 ';
    SQL_STMT := SQL_STMT||'  and c.QUEUE_NAME = ''HIGH'' ';

    EXECUTE IMMEDIATE SQL_STMT using r1.pid, R1.LOGIN,  r1.pid;
    HI_CNT := SQL%ROWCOUNT;

    COMMIT;

    SQL_STMT := ' UPDATE LA_ASSIGNMENT_STAGE c ';
    SQL_STMT := SQL_STMT||' SET c.QUEUE_ID = :E,  c.LOSS_ANALYST = :F, C.ADHOC_INDC = ''LOW''';
    SQL_STMT := SQL_STMT||'     where exists ( select 1 ';
    SQL_STMT := SQL_STMT||'                   from LA_ASSIGNMENT_STAGE a, ';
    SQL_STMT := SQL_STMT||'  TABLE(SELECT LA_CLIENT_QUEUE_LISTS.LOW_QUEUE ';
    SQL_STMT := SQL_STMT||'       FROM LA_CLIENT_QUEUE_LISTS ';
    SQL_STMT := SQL_STMT||'       WHERE LA_CLIENT_QUEUE_LISTS.pid = :F) b ';
    SQL_STMT := SQL_STMT||' where Upper(trim(a.CLIENT_CODE)) = Upper(TRIM(b.CLIENT_code )) ';
    SQL_STMT := SQL_STMT||'  and  a.dispute_id = c.dispute_id) ';
    SQL_STMT := SQL_STMT||'  and nvl(c.PROCESSOR_ID,0) = 0 ';
    SQL_STMT := SQL_STMT||'  and c.QUEUE_NAME = ''LOW'' ';

    EXECUTE IMMEDIATE SQL_STMT using r1.pid, r1.login, r1.pid;
    LO_CNT := SQL%ROWCOUNT;

    COMMIT;

   CNT := CNT + HI_CNT + LO_CNT;

   END LOOP;
CLOSE C1;


                INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SET_QUEUES', SYSDATE, CNT, 'LA_ASSIGNMENT QUEUE ID(s) updated');
        COMMIT;

EXCEPTION
  WHEN OTHERS THEN
  CNT  := SQLCODE;
  MSG  := SQLERRM;

                INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SET_QUEUES', SYSDATE, CNT, MSG);
        COMMIT;


END;
/*************************************
    Reformat the new transactions
    merge them into LA_ASSIGNMENT
 ************************************/
PROCEDURE LOAD_ASSIGNMENT
IS
cnt   number;
msg   VARCHAR2(1000 BYTE);

BEGIN

     INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'LOAD_ASSIGNMENT', SYSDATE, 0, 'And we are off to the race');
        COMMIT;

        EXECUTE IMMEDIATE 'TRUNCATE TABLE LA_ASSIGNMENT DROP STORAGE';

        GATHER_NEW_REPORTS;
--      ADJUST_CURTAIL_DATE;
---     SET_HIGH_LOW;
----    SET_QUEUES;

      INSERT INTO LA_ASSIGNMENT  (INVOICE_NBR, IM_ICLEAR_NBR, WORKORDER_NBR, LOAN_NBR, CLIENT_CODE, CLIENT_COMMENTS, DISPUTE_AMT, INVOICE_AMT, WRITE_OFF, VENDOR_CODE, CHARGE_BACK_AMT_1, APPROVAL, PENDING_RESEARCH, APPEAL, DISPUTE_APPEAL_COMMENT, DEPARTMENT, CLIENT_EMPL, BUCKET, INVOICE_DATE, X_DISPUTED, DISPUTE_TYPE, SOURCE_OF_DISPUTE, CURTAIL_DATE, LAST_UPDATED, COMMENTS, RECEIVED_DATE, WORK_CODE, ADJUSTED_TOTAL, MONTH_DATE, LOSS_ANALYST, PROCESSOR_ID, QUEUE_NAME, QUEUE_ID, DISPUTE_ID, LOAD_DATE, REVIEW_QUEUE, ADHOC_INDC, REVIEWER_ID, FILE_ID, LOAD_ID)
                         SELECT INVOICE_NBR, IM_ICLEAR_NBR, WORKORDER_NBR, LOAN_NBR, CLIENT_CODE, CLIENT_COMMENTS, DISPUTE_AMT, INVOICE_AMT, WRITE_OFF, VENDOR_CODE, CHARGE_BACK_AMT_1, APPROVAL, PENDING_RESEARCH, APPEAL, DISPUTE_APPEAL_COMMENT, DEPARTMENT, CLIENT_EMPL, BUCKET, INVOICE_DATE, X_DISPUTED, DISPUTE_TYPE, SOURCE_OF_DISPUTE, CURTAIL_DATE, LAST_UPDATED, COMMENTS, RECEIVED_DATE, WORK_CODE, ADJUSTED_TOTAL, MONTH_DATE, LOSS_ANALYST, PROCESSOR_ID, QUEUE_NAME, QUEUE_ID, DISPUTE_ID, LOAD_DATE, REVIEW_QUEUE, ADHOC_INDC, REVIEWER_ID, FILE_ID, LOAD_ID
       FROM LA_ASSIGNMENT_STAGE;
       CNT  := SQL%ROWCOUNT;
       COMMIT;

     INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'LOAD_ASSIGNMENT', SYSDATE, CNT, 'Completed...');
        COMMIT;

EXCEPTION
  WHEN OTHERS THEN
  CNT  := SQLCODE;
  MSG  := SQLERRM;

                INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'LOAD_ASSIGNMENT', SYSDATE, CNT, MSG);
        COMMIT;


END;
/***********************************************

  setup ASSIGNMENT from the scratch

 **********************************************/
PROCEDURE SETUP_ASSIGNMENT
IS
S   LA_FILE_PROCESS.LA_SCORING;
GC  GenRefCursor;

SQL_STMT   VARCHAR2(32000 BYTE);
UPD_STMT   VARCHAR2(32000 BYTE);
MSG        VARCHAR2(1000  BYTE);
AMT        VARCHAR2(100   BYTE);
CNT        NUMBER;
SQLROWCNT  NUMBER;


BEGIN

     INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SETUP_ASSIGNMENT', SYSDATE, 0, 'And we are off to the race');
        COMMIT;



    SQL_STMT := 'TRUNCATE TABLE LA_ASSIGNMENT DROP STORAGE';

INSERT INTO LA_ASSIGNMENT (INVOICE_NBR,IM_ICLEAR_NBR,WORKORDER_NBR,LOAN_NBR,CLIENT_CODE,CLIENT_COMMENTS,DISPUTE_AMT,INVOICE_AMT,WRITE_OFF,VENDOR_CODE,CHARGE_BACK_AMT_1,APPROVAL,PENDING_RESEARCH,APPEAL,DISPUTE_APPEAL_COMMENT,DEPARTMENT,CLIENT_EMPL,
                            BUCKET,INVOICE_DATE,X_DISPUTED,DISPUTE_TYPE,SOURCE_OF_DISPUTE,CURTAIL_DATE,LAST_UPDATED,COMMENTS,RECEIVED_DATE,WORK_CODE,ADJUSTED_TOTAL,LOSS_ANALYST,LOAD_DATE,FILE_ID,LOAD_ID,QUEUE_ID)
select A.INVOICE_NBR,A.IM_ICLEAR_NBR,A.WORKORDER_NBR,A.LOAN_NBR,A.CLIENT_CODE,A.CLIENT_COMMENTS,A.DISPUTE_AMT,A.INVOICE_AMT,A.WRITE_OFF,A.VENDOR_CODE,A.CHARGE_BACK_AMT_1,A.APPROVAL,A.PENDING_RESEARCH,A.APPEAL,A.DISPUTE_APPEAL_COMMENT,A.DEPARTMENT,
A.CLIENT_EMPL,A.BUCKET,
LA_FILE_PROCESS.DATE_FMTS (A.INVOICE_DATE)  AS INVOICE_DATE,A.X_DISPUTED,A.DISPUTE_TYPE,A.SOURCE_OF_DISPUTE,
LA_FILE_PROCESS.DATE_FMTS (A.CURTAIL_DATE)  AS CURTAIL_DATE,
LA_FILE_PROCESS.DATE_FMTS (A.LAST_UPDATED)  AS LAST_UPDATED, A.COMMENTS,
LA_FILE_PROCESS.DATE_FMTS (A.RECEIVED_DATE) AS RECEIVED_DATE,A.WORK_CODE,A.ADJUSTED_TOTAL,REPLACE(A.LOSS_ANALYST,' ','.') AS LOSS_ANALYST, TRUNC(SYSDATE) AS LOAD_DATE,10,A.PID, B.PID
from LA_ASSIGNMENT_XLS  A
LEFT JOIN ( SELECT PID, UPPER(LOGIN) LOGIN  FROM LA_QUEUE_PROCESSORS ) B ON ( B.LOGIN = REPLACE(UPPER(A.LOSS_ANALYST),' ','.'));


CNT := SQL%ROWCOUNT;
MSG := 'Rows loaded';


commit;


     INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SETUP_ASSIGNMENT', SYSDATE, cnt, MSG);
        COMMIT;


-------  SET_HIGH_LOW;


    CNT := 0;
    SQLROWCNT := 0;


    SELECT VARIABLE_VALUE
    INTO   AMT
    FROM   LA_SYS_VARIABLES
    WHERE VARIABLE_NAME = 'SET-HIGH';


     LA_FILE_PROCESS.ASSIGN_HIGH_LOW ( P_INVOICE_AMT=>AMT);



     INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SETUP_ASSIGNMENT', SYSDATE, 0, 'Complete..');
        COMMIT;

EXCEPTION
  WHEN OTHERS THEN
  CNT  := SQLCODE;
  MSG  := SQLERRM;

                INSERT INTO BOA_PROCESS_LOG
                    (
                      PROCESS,
                      SUB_PROCESS,
                      ENTRYDTE,
                      ROWCOUNTS,
                      MESSAGE
                    )
        VALUES ( 'LA_FILE_PROCESS', 'SETUP_ASSIGNMENT', SYSDATE, CNT, MSG);
        COMMIT;


END;
-----------LA_FILE_PROCESS.DATE_REFORMAT('MM/DD/YYYY');
FUNCTION  DATE_REFORMAT ( P_DATE VARCHAR2 ) RETURN VARCHAR2
IS
RETURN_VALUE   VARCHAR2(30 BYTE);
WORK_AREA      VARCHAR2(100 BYTE);
LEN            NUMBER;
VAL_DATE       DATE;
mon_dd_yyyy    VARCHAR2(30 BYTE);

BEGIN

WORK_AREA := TRIM(P_DATE);
LEN       := LENGTH(WORK_AREA);

IF ( WORK_AREA IS NULL )
   THEN
   RETURN_VALUE := NULL;
END IF;

--Jan 25 2017 10:00AM

WORK_AREA := CASE WHEN INSTR(WORK_AREA,'0:00:00') > 0 THEN REPLACE(WORK_AREA,'0:00:00','1:00:00')
                  WHEN INSTR(WORK_AREA,'1:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'2:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'3:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'4:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'5:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'6:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'7:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'8:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'9:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'10:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'11:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'12:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'13:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'14:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'15:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'16:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'17:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'18:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'19:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'20:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'21:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'22:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'23:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'24:00:00') > 0 THEN WORK_AREA
                  WHEN INSTR(WORK_AREA,'0:00') > 0 THEN REPLACE(WORK_AREA,'0:00','')
              ELSE WORK_AREA
              END;


WORK_AREA := TRIM(WORK_AREA);
LEN       := LENGTH(WORK_AREA);


    IF (LEN IN (8,9,10) )
       THEN
       BEGIN

          VAL_DATE := TO_DATE(WORK_AREA,'MM/DD/YYYY');
          RETURN_VALUE := WORK_AREA;

       EXCEPTION
            WHEN OTHERS THEN
            BEGIN
                  VAL_DATE := TO_DATE(WORK_AREA,'MM-DD-YYYY');
                  RETURN_VALUE := WORK_AREA;
            EXCEPTION
               WHEN OTHERS THEN
               RETURN_VALUE := 'FAIL MM DD YYYY';
            END;
       END;

    END IF;

--FAIL-mon-dd-yyyy HH:MI:SS

  IF (LEN > 10 )
     THEN
     IF ( SUBSTR(WORK_AREA,1,3) IN ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec') )
        then
           BEGIN

              VAL_DATE := TO_DATE(WORK_AREA,'mon DD YYYY HH:MIPM');
              RETURN_VALUE := TO_CHAR(VAL_DATE,'MM/DD/YYYY');

           EXCEPTION
                WHEN OTHERS THEN
                  BEGIN
                       VAL_DATE := TO_DATE(WORK_AREA,'mon DD YYYY HH:MI:SS PM');
                       RETURN_VALUE := TO_CHAR(VAL_DATE,'MM/DD/YYYY');
                   EXCEPTION
                       WHEN OTHERS THEN
                        BEGIN
                             mon_dd_yyyy := Rtrim(substr(work_area,1,12));
                             VAL_DATE := TO_DATE(mon_dd_yyyy,'mon DD YYYY');
                             RETURN_VALUE := TO_CHAR(VAL_DATE,'MM/DD/YYYY');
                        EXCEPTION
                            WHEN OTHERS THEN
                            RETURN_VALUE := 'FAIL-mon-dd-yyyy HH:MI:SS AGAIN';
                        END;
                  END;

           END;

       ELSE
            BEGIN

                VAL_DATE := TO_DATE(WORK_AREA,'MM/DD/YYYY HH12:MI:SS PM');
                 RETURN_VALUE := TO_CHAR(VAL_DATE,'MM/DD/YYYY');

            EXCEPTION
              WHEN OTHERS THEN
                BEGIN
                        VAL_DATE := TO_DATE(WORK_AREA,'MM/DD/YYYY HH12:MI:SS');
                        RETURN_VALUE := TO_CHAR(VAL_DATE,'MM/DD/YYYY');

                EXCEPTION
                  WHEN OTHERS THEN
                    BEGIN
                        VAL_DATE := TO_DATE(WORK_AREA,'MM/DD/YYYY HH24:MI:SS PM');
                        RETURN_VALUE := TO_CHAR(VAL_DATE,'MM/DD/YYYY');
                    EXCEPTION
                        WHEN OTHERS THEN
                        RETURN_VALUE := 'FAIL-MM/DD/YYYY';
                    END;
                END;

            END;
      END IF;

  END IF;

RETURN RETURN_VALUE;


END;
/************************************************************
 REORDER THE ADHOC DISPUTES
 ************************************************************/

PROCEDURE RE_NUMBER_DISPUTES
IS
UPD_STMT  VARCHAR2(32000 BYTE);
SQL_STMT  VARCHAR2(32000 BYTE);
GC  GenRefCursor;
AR  ASSIGNMENT_ADHOC_REC;

BEGIN

SQL_STMT := ' SELECT ';
SQL_STMT := SQL_STMT||' INVOICE_NBR,';
SQL_STMT := SQL_STMT||' IM_ICLEAR_NBR,';
SQL_STMT := SQL_STMT||' WORKORDER_NBR,';
SQL_STMT := SQL_STMT||' LOAN_NBR,';
SQL_STMT := SQL_STMT||' CLIENT_CODE,';
SQL_STMT := SQL_STMT||' CLIENT_COMMENTS,';
SQL_STMT := SQL_STMT||' DISPUTE_AMT,';
SQL_STMT := SQL_STMT||' INVOICE_AMT,';
SQL_STMT := SQL_STMT||' WRITE_OFF,';
SQL_STMT := SQL_STMT||' VENDOR_CODE,';
SQL_STMT := SQL_STMT||' CHARGE_BACK_AMT_1,';
SQL_STMT := SQL_STMT||' APPROVAL,';
SQL_STMT := SQL_STMT||' PENDING_RESEARCH,';
SQL_STMT := SQL_STMT||' APPEAL,';
SQL_STMT := SQL_STMT||' DISPUTE_APPEAL_COMMENT,';
SQL_STMT := SQL_STMT||' DEPARTMENT,';
SQL_STMT := SQL_STMT||' CLIENT_EMPL,';
SQL_STMT := SQL_STMT||' BUCKET,';
SQL_STMT := SQL_STMT||' INVOICE_DATE,';
SQL_STMT := SQL_STMT||' X_DISPUTED,';
SQL_STMT := SQL_STMT||' DISPUTE_TYPE,';
SQL_STMT := SQL_STMT||' SOURCE_OF_DISPUTE,';
SQL_STMT := SQL_STMT||' CURTAIL_DATE,';
SQL_STMT := SQL_STMT||' LAST_UPDATED,';
SQL_STMT := SQL_STMT||' COMMENTS,';
SQL_STMT := SQL_STMT||' RECEIVED_DATE,';
SQL_STMT := SQL_STMT||' WORK_CODE,';
SQL_STMT := SQL_STMT||' ADJUSTED_TOTAL,';
SQL_STMT := SQL_STMT||' MONTH_DATE,';
SQL_STMT := SQL_STMT||' LOSS_ANALYST,';
SQL_STMT := SQL_STMT||' PROCESSOR_ID,';
SQL_STMT := SQL_STMT||' QUEUE_NAME,';
SQL_STMT := SQL_STMT||' QUEUE_ID,';
SQL_STMT := SQL_STMT||' DISPUTE_ID,';
SQL_STMT := SQL_STMT||' LOAD_DATE,';
SQL_STMT := SQL_STMT||' REVIEW_QUEUE,';
SQL_STMT := SQL_STMT||' ADHOC_INDC,';
SQL_STMT := SQL_STMT||' REVIEWER_ID,';
SQL_STMT := SQL_STMT||' REVIEWER_EMAIL_ADDRESS,';
SQL_STMT := SQL_STMT||' FILE_ID,';
SQL_STMT := SQL_STMT||' LOAD_ID, RANK() OVER ( PARTITION BY INVOICE_NBR, WORKORDER_NBR,LOAN_NBR,CLIENT_COMMENTS ORDER BY LOAD_DATE, ROWNUM) DISPUTE_NBR ';
SQL_STMT := SQL_STMT||' FROM LA_ASSIGNMENT_ADHOC ';

UPD_STMT := 'UPDATE LA_ASSIGNMENT_ADHOC SET DISPUTE_NBR = :A WHERE DISPUTE_ID = :B ';


OPEN GC FOR SQL_STMT;

FETCH GC BULK COLLECT INTO  AR.INVOICE_NBR,
                            AR.IM_ICLEAR_NBR,
                            AR.WORKORDER_NBR,
                            AR.LOAN_NBR,
                            AR.CLIENT_CODE,
                            AR.CLIENT_COMMENTS,
                            AR.DISPUTE_AMT,
                            AR.INVOICE_AMT,
                            AR.WRITE_OFF,
                            AR.VENDOR_CODE,
                            AR.CHARGE_BACK_AMT_1,
                            AR.APPROVAL,
                            AR.PENDING_RESEARCH,
                            AR.APPEAL,
                            AR.DISPUTE_APPEAL_COMMENT,
                            AR.DEPARTMENT,
                            AR.CLIENT_EMPL,
                            AR.BUCKET,
                            AR.INVOICE_DATE,
                            AR.X_DISPUTED,
                            AR.DISPUTE_TYPE,
                            AR.SOURCE_OF_DISPUTE,
                            AR.CURTAIL_DATE,
                            AR.LAST_UPDATED,
                            AR.COMMENTS,
                            AR.RECEIVED_DATE,
                            AR.WORK_CODE,
                            AR.ADJUSTED_TOTAL,
                            AR.MONTH_DATE,
                            AR.LOSS_ANALYST,
                            AR.PROCESSOR_ID,
                            AR.QUEUE_NAME,
                            AR.QUEUE_ID,
                            AR.DISPUTE_ID,
                            AR.LOAD_DATE,
                            AR.REVIEW_QUEUE,
                            AR.ADHOC_INDC,
                            AR.REVIEWER_ID,
                            AR.REVIEWER_EMAIL_ADDRESS,
                            AR.FILE_ID,
                            AR.LOAD_ID,
                            AR.DISPUTE_NBR;
FORALL k in 1..ar.dispute_id.count
   EXECUTE IMMEDIATE UPD_STMT USING  AR.DISPUTE_NBR(k), AR.DISPUTE_ID(k);

END;



begin

      LOAD_CLIENT_CODES;


---- EOF
END;

/
