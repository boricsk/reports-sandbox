table 50018 "SEI POC Master data"
{
    Caption = 'SEI POC Master data';
    DataClassification = ToBeClassified;

    fields
    {
        field(010; "PO Number"; Code[20]) { }
        field(020; "PO Line number"; Integer) { }
        field(030; "Date of order"; Date) { }
        field(040; "Date of confirmation"; Date) { }
        field(045; "Area"; Code[20]) { }
        field(050; "Item number"; Code[20]) { }
        field(060; "Item description"; Text[100]) { }
        field(065; "Unit of measure"; Text[50]) { }
        field(070; "Shipping unit"; Text[15]) { }
        field(080; "Quantity"; Decimal) { DecimalPlaces = 3 :; }
        field(090; "Requesterd ETA"; Date) { }
        field(100; "Confirmed ETD"; Date) { }
        field(110; "Confirmed ETA"; Date) { }
        field(120; "Confirmed ETA (Modified)"; Date) { }
        field(130; "Comment"; Text[50]) { }
        field(133; "Comment 2"; Decimal) { DecimalPlaces = 3 :; }
        field(135; "SO number"; Code[50]) { }
        field(140; "Completely arrived"; Boolean) { }
        field(145; "Completely arrive date"; Date) { }
        field(150; "Shipment on way"; Boolean) { }
        field(160; "Remaining qty"; Decimal) { DecimalPlaces = 3 :; } // három tizedesjegy beállítása
        field(170; "Arrival date 1"; Date) { }
        field(180; "Arrival qty 1"; Decimal) { DecimalPlaces = 3 :; }
        field(190; "Arrival date 2"; Date) { }
        field(200; "Arrival qty 2"; Decimal) { DecimalPlaces = 3 :; }
        field(210; "Arrival date 3"; Date) { }
        field(220; "Arrival qty 3"; Decimal) { DecimalPlaces = 3 :; }
        field(230; "Arrival date 4"; Date) { }
        field(240; "Arrival qty 4"; Decimal) { DecimalPlaces = 3 :; }
        field(250; "Arrival date 5"; Date) { }
        field(260; "Arrival qty 5"; Decimal) { DecimalPlaces = 3 :; }
        field(270; "Arrival date 6"; Date) { }
        field(280; "Arrival qty 6"; Decimal) { DecimalPlaces = 3 :; }
        field(290; "Arrival date 7"; Date) { }
        field(300; "Arrival qty 7"; Decimal) { DecimalPlaces = 3 :; }
        field(310; "Line amount"; Decimal) { }
        field(311; "Unit price"; Decimal) { DecimalPlaces = 5 :; }
        field(312; "Currency code"; Code[10]) { }
        field(320; "Supplier"; Code[20]) { }
        field(325; "Supplier name"; Text[100]) { }
        field(330; "Fist shipment LT"; Decimal) { }
        field(340; "Last shipment LT"; Decimal) { }
        field(350; "Requested LT"; Decimal) { }
        field(360; "On time status"; Option) { OptionMembers = "Not complete",Delay,"On time"; }
        field(370; "Delay in days"; Integer) { }
        field(380; "Business year"; Integer) { }
        field(385; "Month"; Integer) { }
        field(390; "On time quantity"; Decimal) { }
        field(400; "Delayed quantity"; Decimal) { }
        field(410; "Coil LT"; Integer) { }
        field(420; "Cut LT"; Integer) { }
        field(430; "Finish LT"; Integer) { }
        field(440; "Spec LT"; Integer) { }
        field(450; "Test"; code[2]) { }






    }

    keys
    {
        key(PK; "PO Number", "PO Line number")
        {
            Clustered = true;
        }


    }

    var
        test: Record "Purchase Line";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}