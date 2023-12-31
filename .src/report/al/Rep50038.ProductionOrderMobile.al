report 50038 "SEI Production Order Mobile"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50038.ProductionOrderMobile.rdlc';
    ApplicationArea = Manufacturing;
    Caption = 'SEI Production Order Mobile';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.");
            RequestFilterFields = Status, "No.";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(Status_ProductionOrder; Status)
            {
                //IncludeCaption = true;
            }
            column(No_ProductionOrder; "No.")
            {
                //IncludeCaption = true;
            }
            column(WO_HEAD_Quantity; Quantity) { }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            column(PrdOdrCmptsandRtngLinsCpt; PrdOdrCmptsandRtngLinsCptLbl)
            {
            }
            column(ProductionOrderDescCapt; ProductionOrderDescCaptLbl)
            {
            }
            column(BarCodeWONumber; C128WONumber.Picture)
            {
            }
            column(BarCodeWOItemNr; C128WOItemNumber.Picture)
            {
            }
            column(Location_Code; "Location Code") { }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                RequestFilterFields = "Item No.", "Line No.";
                column(No1_ProductionOrder; "Production Order"."No.")
                {
                }
                column(Desc_ProductionOrder; "Production Order".Description)
                {
                }
                column(Desc_ProdOrderLine; Description)
                {
                }
                column(Quantity_ProdOrderLine; Quantity)
                {
                    //IncludeCaption = true;
                }
                column(ItemNo_ProdOrderLine; "Item No.")
                {
                }
                column(StartgDate_ProdOrderLine; Format("Starting Date"))
                {
                }
                column(StartgTime_ProdOrderLine; "Starting Time")
                {
                    //IncludeCaption = true;
                }
                column(EndingDate_ProdOrderLine; Format("Ending Date"))
                {
                }
                column(EndingTime_ProdOrderLine; "Ending Time")
                {
                    //IncludeCaption = true;
                }
                column(DueDate_ProdOrderLine; Format("Due Date"))
                {
                }
                column(LineNo_ProdOrderLine; "Line No.")
                {
                }
                column(ProdOdrLineStrtngDteCapt; ProdOdrLineStrtngDteCaptLbl)
                {
                }
                column(ProdOrderLineEndgDteCapt; ProdOrderLineEndgDteCaptLbl)
                {
                }
                column(ProdOrderLineDueDateCapt; ProdOrderLineDueDateCaptLbl)
                {
                }
                column(SEI_Order_Promising_Cust__Name; "SEI Order Promising Cust. Name") { }
                column(SEI_Customer_Ref__No_; "SEI Customer Ref. No.") { }
                column(SEI_Order_Promising_ID; "SEI Order Promising ID") { }
                column(SEI_Order_Promising_SAP_No_; "SEI Order Promising SAP No.") { }
                column(SEI_Tmp__Order_Prom__SAP_No_; "SEI Tmp. Order Prom. SAP No.") { }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(ItemNo_PrdOrdrComp; "Item No.")
                    {
                    }
                    column(ProdOrderComp_Status_PK1; Status) { }
                    column(ProdOrderComp_Prod__Order_No_PK2; "Prod. Order No.") { }
                    column(ProdOrderComp_Prod__Order_Line_No_PK3; "Prod. Order Line No.") { }
                    column(ProdOrderComp_Line_No_PK4; "Line No.") { }
                    column(ItemNo_PrdOrdrCompCaption; FieldCaption("Item No."))
                    {
                    }
                    column(Description_ProdOrderComp; Description)
                    {
                        //IncludeCaption = true;
                    }
                    column(Quantityper_ProdOrderComp; "Quantity per")
                    {
                        //IncludeCaption = true;
                    }
                    column(UntofMesrCode_PrdOrdrComp; "Unit of Measure Code")
                    {
                        //IncludeCaption = true;
                    }
                    column(RemainingQty_PrdOrdrComp; "Remaining Quantity")
                    {
                        //IncludeCaption = true;
                    }
                    column(DueDate_PrdOrdrComp; Format("Due Date"))
                    {
                    }
                    column(ProdOrdrLinNo_PrdOrdrComp; "Prod. Order Line No.")
                    {
                    }
                    column(LineNo_PrdOrdrComp; "Line No.")
                    {
                    }
                    column(BarCodeRMItemNr; C128RMItemNumber.Picture)
                    {

                    }

                    trigger OnAfterGetRecord()
                    begin
                        C128RMItemNumber.Init();
                        C128MakeBarcode(Format("Item No."), C128RMItemNumber, 3000, 1000, 96, false);
                        //ha ez az ellenőrzés benne van akkor nem hozza az összes BOM anyagot, csak ami nincs linkelve a MT-ben.
                        //if ProductionJrnlMgt.RoutingLinkValid("Prod. Order Component", "Prod. Order Line") then
                        //CurrReport.Skip();
                    end;

                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = "Routing No." = FIELD("Routing No."), "Routing Reference No." = FIELD("Routing Reference No."), "Prod. Order No." = FIELD("Prod. Order No."), Status = FIELD(Status);
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                    column(OprNo_ProdOrderRtngLine; "Operation No.")
                    {
                    }
                    column(OprNo_ProdOrderRtngLineCaption; FieldCaption("Operation No."))
                    {
                    }
                    column(Type_PrdOrdRtngLin; Type)
                    {
                        //IncludeCaption = true;
                    }
                    column(No_ProdOrderRoutingLine; "No.")
                    {
                        //IncludeCaption = true;
                    }
                    column(LinDesc_ProdOrderRtngLine; Description)
                    {
                        //IncludeCaption = true;
                    }
                    column(StrgDt_ProdOrderRtngLine; Format("Starting Date"))
                    {
                    }
                    column(LinStrgTime_PrdOrdRtngLin; "Starting Time")
                    {
                        //IncludeCaption = true;
                    }
                    column(EndgDte_ProdOrdrRtngLine; Format("Ending Date"))
                    {
                    }
                    column(EndgTime_ProdOrdrRtngLin; "Ending Time")
                    {
                        //IncludeCaption = true;
                    }
                    column(RoutgNo_ProdOrdrRtngLine; "Routing No.")
                    {
                    }
                    column(BarCodeRoutingNo; C128RoutingNumber.Picture)
                    {

                    }
                    column(C128StartCode; C128StartCode.Picture) { }
                    column(C128StopCode; C128StopCode.Picture) { }

                    column(Run_Time; "Run Time") { }
                    dataitem(CompLink; "Prod. Order Component")
                    {
                        DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Routing Reference No.");
                        DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Link Code", "Flushing Method") WHERE("Routing Link Code" = FILTER(<> ''));
                        column(ItemNo_CompLink; "Item No.")
                        {
                        }
                        column(Description_CompLink; Description)
                        {
                        }
                        column(Quantityper_CompLink; "Quantity per")
                        {
                        }
                        column(UntofMeasureCode_CompLink; "Unit of Measure Code")
                        {
                        }
                        column(DueDate_CompLink; Format("Due Date"))
                        {
                        }
                        column(RemainingQty_CompLink; "Remaining Quantity")
                        {
                        }
                        column(LineNo_CompLink; "Line No.")
                        {
                        }
                        column(RoutingLinkCode_CompLink; "Routing Link Code")
                        {
                        }

                    }
                    trigger OnAfterGetRecord()
                    begin

                        C128RoutingNumber.Init();
                        C128MakeBarcode(Format("Prod. Order Routing Line"."Operation No."), C128RoutingNumber, 3000, 1000, 96, false);
                    end;
                }
            }

            trigger OnAfterGetRecord() //Production order
            begin
                C128WONumber.Init();
                C128WOItemNumber.Init();
                C128MakeBarcode(Format("No."), C128WONumber, 3000, 1000, 96, false);
                C128MakeBarcode(Format("Source No."), C128WOItemNumber, 3000, 1000, 96, false);
            end;

        }// end of production order
    }



    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        LblRMItemNo = 'Raw material item no.';
        LblRMDesc = 'Raw material desctription';
        LblRMBOMQty = 'Raw mat. BOM qty.';
        LblRMRemainingQty = 'Remaining qty.';
        LblRMLotNum = 'LOT number';
        LblProdOrderQty = 'Prod. order qty.:';
        LblUnit = 'Unit';
        lblTitle = 'Production order';
        LblOperationNumber = 'Operation num.';
        LblOperationDesc = 'Operation description';
        LblOperationTimeUnit = 'Operation time (Unit)';
        LblOperationTimeTTL = 'Operation time (TTL)';
        LblStopWork = 'STOP WORK';
        LblStartWork = 'START WORK';

    }

    trigger OnInitReport()
    begin
        C128StartCode.Init();
        C128StopCode.Init();
        C128MakeBarcode(Format('START'), C128StartCode, 3000, 1000, 96, false);
        C128MakeBarcode(Format('STOP'), C128StopCode, 3000, 1000, 96, false);
    end;

    var
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        CurrReportPageNoCaptLbl: Label 'Page';
        PrdOdrCmptsandRtngLinsCptLbl: Label 'Prod. Order - Components and Routing Lines';
        ProductionOrderDescCaptLbl: Label 'Description';
        ProdOdrLineStrtngDteCaptLbl: Label 'Starting Date';
        ProdOrderLineEndgDteCaptLbl: Label 'Ending Date';
        ProdOrderLineDueDateCaptLbl: Label 'Due Date';
        C128Bars: array[107] of Text[13];
        C128RMItemNumber: Record "Company Information";
        C128RoutingNumber: Record "Company Information";
        C128WONumber: Record "Company Information";
        C128WOItemNumber: Record "Company Information";
        C128StartCode: Record "Company Information";
        C128StopCode: Record "Company Information";

    procedure C128WriteBarcode(Strm: OutStream; C128ID: Integer)
    var
        ch: Byte;
        j: Integer;
        BarcodeString: Text[20];
    begin
        // Generate the bars for a given charater-number
        BarcodeString := C128Bars[C128ID]; // in BarcodeString is now the coding in bars of the given value
        FOR j := 1 TO STRLEN(BarcodeString) DO BEGIN // STRLEN(BC) is not fixed, it is 11 or 13 (13 for stopchar)
            IF BarcodeString[j] = 'b' THEN
                ch := 0     // black
            ELSE
                ch := 255;  // white
            Strm.WRITE(ch, 1);
            Strm.WRITE(ch, 1);
            Strm.WRITE(ch, 1); // write module; 3 byte = 1 pixel (24bpp)
        END;
    end;

    local procedure C128BcodeTab()
    begin
        // Table with the bars for a character
        // Code128 has 11 modules for each charater (except STOP)
        //                12345678901, b = black, w = white.
        // Code128C (numeric)
        //    Code128B (alphaumeric)
        //      Code128A (only if different form Code128B)
        C128Bars[1] := 'bbwbbwwbbww'; // 00 (blank)
        C128Bars[2] := 'bbwwbbwbbww'; // 01 !
        C128Bars[3] := 'bbwwbbwwbbw'; // 02 "
        C128Bars[4] := 'bwwbwwbbwww'; // 03 #
        C128Bars[5] := 'bwwbwwwbbww'; // 04 $
        C128Bars[6] := 'bwwwbwwbbww'; // 05 %
        C128Bars[7] := 'bwwbbwwbwww'; // 06 &
        C128Bars[8] := 'bwwbbwwwbww'; // 07 '
        C128Bars[9] := 'bwwwbbwwbww'; // 08 (
        C128Bars[10] := 'bbwwbwwbwww'; // 09 )
        C128Bars[11] := 'bbwwbwwwbww'; // 10 *
        C128Bars[12] := 'bbwwwbwwbww'; // 11 +
        C128Bars[13] := 'bwbbwwbbbww'; // 12 ,
        C128Bars[14] := 'bwwbbwbbbww'; // 13 -
        C128Bars[15] := 'bwwbbwwbbbw'; // 14 .
        C128Bars[16] := 'bwbbbwwbbww'; // 15 /
        C128Bars[17] := 'bwwbbbwbbww'; // 16 0
        C128Bars[18] := 'bwwbbbwwbbw'; // 17 1
        C128Bars[19] := 'bbwwbbbwwbw'; // 18 2
        C128Bars[20] := 'bbwwbwbbbww'; // 19 3
        C128Bars[21] := 'bbwwbwwbbbw'; // 20 4
        C128Bars[22] := 'bbwbbbwwbww'; // 21 5
        C128Bars[23] := 'bbwwbbbwbww'; // 22 6
        C128Bars[24] := 'bbbwbbwbbbw'; // 23 7
        C128Bars[25] := 'bbbwbwwbbww'; // 24 8
        C128Bars[26] := 'bbbwwbwbbww'; // 25 9
        C128Bars[27] := 'bbbwwbwwbbw'; // 26 :
        C128Bars[28] := 'bbbwbbwwbww'; // 27 ;
        C128Bars[29] := 'bbbwwbbwbww'; // 28 <
        C128Bars[30] := 'bbbwwbbwwbw'; // 29 =
        C128Bars[31] := 'bbwbbwbbwww'; // 30 >
        C128Bars[32] := 'bbwbbwwwbbw'; // 31 ?
        C128Bars[33] := 'bbwwwbbwbbw'; // 32 @
        C128Bars[34] := 'bwbwwwbbwww'; // 33 A
        C128Bars[35] := 'bwwwbwbbwww'; // 34 B
        C128Bars[36] := 'bwwwbwwwbbw'; // 35 C
        C128Bars[37] := 'bwbbwwwbwww'; // 36 D
        C128Bars[38] := 'bwwwbbwbwww'; // 37 E
        C128Bars[39] := 'bwwwbbwwwbw'; // 38 F
        C128Bars[40] := 'bbwbwwwbwww'; // 39 G
        C128Bars[41] := 'bbwwwbwbwww'; // 40 H
        C128Bars[42] := 'bbwwwbwwwbw'; // 41 I
        C128Bars[43] := 'bwbbwbbbwww'; // 42 J
        C128Bars[44] := 'bwbbwwwbbbw'; // 43 K
        C128Bars[45] := 'bwwwbbwbbbw'; // 44 L
        C128Bars[46] := 'bwbbbwbbwww'; // 45 M
        C128Bars[47] := 'bwbbbwwwbbw'; // 46 N
        C128Bars[48] := 'bwwwbbbwbbw'; // 47 O
        C128Bars[49] := 'bbbwbbbwbbw'; // 48 P
        C128Bars[50] := 'bbwbwwwbbbw'; // 49 Q
        C128Bars[51] := 'bbwwwbwbbbw'; // 50 R
        C128Bars[52] := 'bbwbbbwbwww'; // 51 S
        C128Bars[53] := 'bbwbbbwwwbw'; // 52 T
        C128Bars[54] := 'bbwbbbwbbbw'; // 53 U
        C128Bars[55] := 'bbbwbwbbwww'; // 54 V
        C128Bars[56] := 'bbbwbwwwbbw'; // 55 W
        C128Bars[57] := 'bbbwwwbwbbw'; // 56 X
        C128Bars[58] := 'bbbwbbwbwww'; // 57 Y
        C128Bars[59] := 'bbbwbbwwwbw'; // 58 Z
        C128Bars[60] := 'bbbwwwbbwbw'; // 59 [
        C128Bars[61] := 'bbbwbbbbwbw'; // 60 \
        C128Bars[62] := 'bbwwbwwwwbw'; // 61 ]
        C128Bars[63] := 'bbbbwwwbwbw'; // 62 ^
        C128Bars[64] := 'bwbwwbbwwww'; // 63 _
        C128Bars[65] := 'bwbwwwwbbww'; // 64 ` NUL
        C128Bars[66] := 'bwwbwbbwwww'; // 65 a SOH
        C128Bars[67] := 'bwwbwwwwbbw'; // 66 b STX
        C128Bars[68] := 'bwwwwbwbbww'; // 67 c ETX
        C128Bars[69] := 'bwwwwbwwbbw'; // 68 d EOT
        C128Bars[70] := 'bwbbwwbwwww'; // 69 e ENQ
        C128Bars[71] := 'bwbbwwwwbww'; // 70 f ACK
        C128Bars[72] := 'bwwbbwbwwww'; // 71 g BEL
        C128Bars[73] := 'bwwbbwwwwbw'; // 72 h BS
        C128Bars[74] := 'bwwwwbbwbww'; // 73 i HT
        C128Bars[75] := 'bwwwwbbwwbw'; // 74 j LF
        C128Bars[76] := 'bbwwwwbwwbw'; // 75 k VT
        C128Bars[77] := 'bbwwbwbwwww'; // 76 l FF
        C128Bars[78] := 'bbbbwbbbwbw'; // 77 m CR
        C128Bars[79] := 'bbwwwwbwbww'; // 78 n SO
        C128Bars[80] := 'bwwwbbbbwbw'; // 79 o SI
        C128Bars[81] := 'bwbwwbbbbww'; // 80 p DLE
        C128Bars[82] := 'bwwbwbbbbww'; // 81 q DC1
        C128Bars[83] := 'bwwbwwbbbbw'; // 82 r DC2
        C128Bars[84] := 'bwbbbbwwbww'; // 83 s DC3
        C128Bars[85] := 'bwwbbbbwbww'; // 84 t DC4
        C128Bars[86] := 'bwwbbbbwwbw'; // 85 u NAK
        C128Bars[87] := 'bbbbwbwwbww'; // 86 v SYN
        C128Bars[88] := 'bbbbwwbwbww'; // 87 w ETB
        C128Bars[89] := 'bbbbwwbwwbw'; // 88 x CAN
        C128Bars[90] := 'bbwbbwbbbbw'; // 89 y EM
        C128Bars[91] := 'bbwbbbbwbbw'; // 90 z SUB
        C128Bars[92] := 'bbbbwbbwbbw'; // 91 { ESC
        C128Bars[93] := 'bwbwbbbbwww'; // 92 | FS
        C128Bars[94] := 'bwbwwwbbbbw'; // 93 } GS
        C128Bars[95] := 'bwwwbwbbbbw'; // 94 ~ RS
        C128Bars[96] := 'bwbbbbwbwww'; // 95 del US
        C128Bars[97] := 'bwbbbbwwwbw'; // 96 func3
        C128Bars[98] := 'bbbbwbwbwww'; // 97 func2
        C128Bars[99] := 'bbbbwbwwwbw'; // 98 shift
        C128Bars[100] := 'bwbbbwbbbbw'; // 99 CodeC
        C128Bars[101] := 'bwbbbbwbbbw'; // CodeB func4 CodeB
        C128Bars[102] := 'bbbwbwbbbbw'; // CodeA CodeA
        C128Bars[103] := 'bbbbwbwbbbw'; // func1 func1
        C128Bars[104] := 'bbwbwwwwbww'; // StartA StartA
        C128Bars[105] := 'bbwbwwbwwww'; // StartB StartB
        C128Bars[106] := 'bbwbwwbbbww'; // StartC StartC
        C128Bars[107] := 'bbwwwbbbwbwbb'; // Stop Stop
    end;

    local procedure C128MakeBarcode(BarcodeText: Text[250]; var Pic: Record "Company Information"; C128PicWidth: Integer; C128PicHeight: Integer; C128PicDPI: Integer; C128PlacePicRight: Boolean)
    var
        cBlack: Byte;
        cWhite: Byte;
        BarcodeTextLen: Integer;
        BMPLines: Integer;
        C128Checksum: Integer;
        CharCode: Integer;
        i: Integer;
        j: Integer;
        Line: Integer;
        Modules: Integer;
        WhiteSpaces: Integer;
        Standard128BEN: Label ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~', Locked = true;
        Standard128B: Label ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ^_`abcdefghijklmnopqrstuvwxyzäöüß', Locked = true;
        Standard128BDE: Label ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ^_`abcdefghijklmnopqrstuvwxyzäöüß', Locked = true;
        OStrm: OutStream;
    begin
        // Generate Barcode as Code128B as a BMP in a temporary BLOB
        // (C) 2009 by Wolfram Ansin (w.ansin at dsm.ag)
        // Version 1.0
        // based on a idea and program code of Robert de Bath (http://www.tvisiontech.co.uk/)
        // You can use and modify this code for free if you show Robert's and my name.
        // Code is provided without any warranty, use at your own risk.
        // programed with Navision 2.6 german

        // usage: C128MakeBarcode(Barcodetext, Pic, PicWidth, PicHeight, PicDPI, PlacePicRight)
        // Barcodetext: the readable text to make a barcode without checksumcharacter
        // Pic: the Record which has a BLOB called Bild; in Bild ist the resulting BMP stored
        // (Bild is german; the english translation is picture; maybe you have to change this in Navision 3.x and up)
        // C128PicWidth: the maximum width of the generated picture
        // C128PicHeight: the maximum height of the generated picture
        // C128PicDPI: the maximum size of the bars depend on the DPI; higher DPI = smaler bars;
        //             normally use 48dpi or 96dpi
        // C128PlacePicRight: place a small barcode on the left (false) or right (true) side

        // If Barcodetable is not filled, initialize Barcodetable
        IF C128Bars[1] = '' THEN
            C128BcodeTab();

        cWhite := 255;
        cBlack := 0;

        BarcodeTextLen := STRLEN(BarcodeText);

        // 1 module is the smalest object of a barcode, a small white or black bar;
        // a thick bar consists of more than 1 module (e.g. 2 or 3 or 4 ...)
        // Modules = how much modules are needed for the complete barcode
        // Code128: BarcodeTextLen + 3 = complete barcode incl. start-, check- und stop-character
        //          11 modules per character (eexcept for stop: stop has 2 modules more = 13)
        //          no gaps between the bars of 2 characters
        Modules := (BarcodeTextLen + 3) * 11 + 2; // Code128

        // BMPLines = number of lines in barcode-picture, because ResX and ResY in DPI are the same in the picture
        BMPLines := ROUND(Modules * 0.15, 1, '>');

        // check if resulting bars are too wide with the given DPI and PicWidth
        // if yes, calculate the white space at the right (or left)
        IF (C128PicWidth <> 0) AND (C128PicDPI <> 0) THEN BEGIN
            WhiteSpaces := ROUND(C128PicWidth / 2540 * C128PicDPI, 1, '>') - Modules;
            // Whitespaces = (minimum number of modules) - nedded modules
            IF WhiteSpaces < 0 THEN
                WhiteSpaces := 0;
        END ELSE // no information about the BMP
            WhiteSpaces := 0;

        // Allocate the needed memory, otherwise the generating of large barcode may take a very long time
        Pic.Picture.CREATEOUTSTREAM(OStrm);
        // Allocate memory in kbyte:
        // (Modules + Whitespaces) * Lines * 3 (3 byte per pixel, 24bpp) / 1024 (for kByte)
        FOR i := 1 TO ROUND((WhiteSpaces + Modules) * BMPLines * 3 / 1024, 1, '>') DO
            OStrm.WRITETEXT(PADSTR('', 1023, ' ')); // 1023 plus a NUL = 1024

        // open the Stream again to start from the beginning
        Pic.Picture.CREATEOUTSTREAM(OStrm);

        C128WriteBMPHeader(OStrm, (Modules + WhiteSpaces), BMPLines, C128PicWidth, C128PicHeight, C128PicDPI);
        // (Stream, Cols, Rows, Width, Height, DPI)

        FOR Line := 1 TO BMPLines DO BEGIN
            // if barcode-picture should placed on the right, fill with white space now (if needed)
            IF (C128PlacePicRight = TRUE) AND (WhiteSpaces > 0) THEN
                FOR i := 1 TO (WhiteSpaces * 3) DO
                    OStrm.WRITE(cWhite, 1);

            C128WriteBarcode(OStrm, 105); // 105 = StartB = Start barcode with Code128B
            C128Checksum := (105 - 1); // Startcodevalue is 105-1 = 104
            FOR i := 1 TO BarcodeTextLen DO BEGIN // analyze barcodetext and generate bars
                CharCode := STRPOS(Standard128B, FORMAT(BarcodeText[i])); // which number has the actual charater
                                                                          // in Standard128xx are all valid characters as a constant string at the correct position
                IF CharCode = 0 THEN // invalid character
                    CharCode := 1;     // replace invalid with space
                C128Checksum += i * (CharCode - 1); // Value for checksum is 1 less than position at the constant string
                C128WriteBarcode(OStrm, CharCode);
            END; // all characters of the barcodetext convertet to bars

            // checksum-character
            C128Checksum := C128Checksum MOD 103;
            C128WriteBarcode(OStrm, C128Checksum + 1); // +1 because of 1-based-array

            // Stop-Character
            C128WriteBarcode(OStrm, 106 + 1); // 106 is code for stopcharacter; has 13 modules

            // if barcode is to small for PicWidth, fill with white space on the right (if not filled on the left)
            IF (C128PlacePicRight = FALSE) AND (WhiteSpaces > 0) THEN
                FOR i := 1 TO (WhiteSpaces * 3) DO
                    OStrm.WRITE(cWhite, 1);

            // check if number of bytes is a multiple of 4 (because of BMP);
            // * 3 because each pixel needs 3 colorbytes (24bpp)
            j := (Modules + WhiteSpaces) * 3;
            IF j <> ROUND(j, 4, '>') THEN
                FOR i := j + 1 TO ROUND(j, 4, '>') DO
                    OStrm.WRITE(cWhite, 1); // fill with white

        END; // next BMP-Line
    end;

    local procedure C128WriteBMPHeader(Strm: OutStream; Cols: Integer; Rows: Integer; Width: Integer; Height: Integer; DPI: Integer)
    var
        ch: Byte;
        BMPSize: Integer;
        ResX: Integer;
        ResY: Integer;
    begin
        // Write BMP-Header
        // Don't touch this code - it only works with this code (I don't know why)
        IF DPI > 0 THEN BEGIN
            ResX := ROUND(39.37 * DPI, 1);
            ResY := ResX;
            IF Width > 0 THEN
                ResX := ROUND(Cols / Width * 100000, 1);
            IF Height > 0 THEN
                ResY := ROUND(Rows / Height * 100000, 1);
        END ELSE
            IF (Width > 0) AND (Height > 0) THEN BEGIN
                ResX := ROUND(Cols / Width * 100000, 1);
                ResY := ROUND(Rows / Height * 100000, 1);
            END;

        // BMP File Header (14 byte)
        // Magic signs 'BM' (2 byte)
        ch := 'B';
        Strm.WRITE(ch, 1);
        ch := 'M';
        Strm.WRITE(ch, 1);
        // BMP file size (4 byte)
        BMPSize := 54 +           // Header
        ROUND((Rows * 3), 4, '>') // Pixel per Line, per pixel 3 byte, a multiple of 4
         * Cols;                  // Lines
        Strm.WRITE(BMPSize, 4);
        // Reserved (4 byte, must be zero)
        Strm.WRITE(0, 4);
        // Offset of bitmap from begining of file
        Strm.WRITE(54, 4);
        // End BMP Fileheader

        // Start of Bitmap-Infoheader (40 byte)
        Strm.WRITE(40, 4);          // Bytes in Header (40) (4 byte)
        Strm.WRITE(Cols, 4);        // Weight in pixel (4 byte); If not divisible by four padding is required.
        Strm.WRITE(Rows, 4);        // Height in pixel (4 byte); positive = bottom-up, negative = top-down (in theory; doesn't work).
        //Strm.WRITE(01, 2);          // must be 1 (2 byte); does not work
        //Strm.WRITE(24, 2);          // bpp (2 byte); does not work
        Strm.WRITE(65536 * 24 + 1); // only this way works (24bpp, +1)
        Strm.WRITE(0, 4);           // Compression: no (4 byte)
        Strm.WRITE(0, 4);           // Raw bitmap size (4 byte) (0=default for uncompressed)
        Strm.WRITE(ResX, 4);        // Pixels/metre Horizontal, dpm = 39.370 * dpi, screen = 96dpi (3780)
        Strm.WRITE(ResY, 4);        // Pixels/metre Vertical
        Strm.WRITE(0, 4);           // Colours in palette (0=no palette)
        Strm.WRITE(0, 4);           // Important colours, ignored.
        // End of Bitmap-Infoheader

        // Bytes BGR (Yes, BGR and not RGB!)
        // Line per Line
        // every line must be filled with NUL to a multiple of 4
    end;
}

