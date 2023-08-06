report 50095 "Daily Dispatch"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50095.DailyDispatch.rdlc';
    ApplicationArea = All;
    Caption = 'SEI Daily Dispatch', Locked = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            column(No_; "No.") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Shipment_Date; "Shipment Date") { }
            column(Shipment_Method_Code; "Shipment Method Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(SEI_Whse_Shipment_Doc__No_; "SEI Whse Shipment Doc. No.") { }
            column(Shipping_Agent_Service_Code; "Shipping Agent Service Code") { }
            column(Shipping_Agent_Code; "Shipping Agent Code") { }
            column(SEI_SAP_SO_No_; "SEI SAP SO No.") { }
            column(SEI_Customer_Ref__No_; "SEI Customer Ref. No.") { }
            column(Package_Tracking_No_; "Package Tracking No.") { }

            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.") { }
                column(ItemNumber; "No.") { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_No_; "Line No.") { }
                column(Order_No_; "Order No.") { }
                column(GetCurrencyCode; GetCurrCode("Sales Shipment Header"."Currency Code")) { }
                column(GetNumberOfBoxes; GetNumberOfBoxes("No.", Quantity)) { }
                column(USDTTL; SummUSD(Quantity, "Unit Price", GetCurrCode("Sales Shipment Header"."Currency Code"))) { }
                column(EURTTL; SummEUR(Quantity, "Unit Price", GetCurrCode("Sales Shipment Header"."Currency Code"))) { }
                column(EURQTY; SummEurQty(Quantity, "Unit of Measure Code", GetCurrCode("Sales Shipment Header"."Currency Code"))) { }
                column(USDQTY; SummUsdQty(Quantity, "Unit of Measure Code", GetCurrCode("Sales Shipment Header"."Currency Code"))) { }
                column(Net_Weight; "Net Weight") { }
                column(Gross_Weight; "Gross Weight") { }

            }

            trigger OnPreDataItem()
            begin
                if RPShipmentDate <> 0D then begin
                    "Sales Shipment Header".SetRange("Shipment Date", RPShipmentDate, RPShipmentDate);
                end;
            end;

        }




    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Details)
                {
                    // field(Description; commentToDocuments)
                    // {
                    //     ApplicationArea = All;

                    // }
                    // field("Show Price"; IsShowPrice)
                    // {
                    //     ApplicationArea = All;
                    // }
                    field("Date of shipment"; RPShipmentDate)
                    {
                        ApplicationArea = All;
                    }
                    // field("Destination number"; DestNumber)
                    // {
                    //     ApplicationArea = All;
                    //     TableRelation = Customer."No.";
                    // }
                }
            }
        }

        // actions
        // {
        //     area(processing)
        //     {
        //         action(ActionName)
        //         {
        //             ApplicationArea = All;

        //         }
        //     }
        // }
    }


    labels
    {
        LblReportTitle = 'Daily Dispatch List', Locked = true;

    }
    trigger OnInitReport()
    begin
        EURTTL := 0;
        USDTTL := 0;
        EURQTY := 0;
        USDQTY := 0;
    end;

    var
        RPShipmentDate: Date;
        WhseShipLine: Record "Sales Shipment Line";
        SEIItemUnitOfMeasure: Record "Item Unit of Measure";
        EURTTL, USDTTL, EURQTY, USDQTY : Decimal;

    local procedure GetCurrCode(CurCode: Code[10]): Text
    begin
        if CurCode = '' then begin
            exit('EUR');
        end else begin
            exit(CurCode);
        end;
    end;

    local procedure GetNumberOfBoxes(Item: Code[20]; ShippedQty: Decimal): Decimal
    var
        BoxNumber: Decimal;
        BoxQty: Decimal;
        RoundedQty: Decimal;
        ShipItem: Record Item;

    begin
        ShipItem.Init();
        ShipItem.Init();
        if ShipItem.Get(Item) then begin
            SEIItemUnitOfMeasure.Get(Item, ShipItem."SEI Shipment Unit of Measure");
            BoxQty := SEIItemUnitOfMeasure."Qty. per Unit of Measure";
            if BoxQty > 0 then begin
                RoundedQty := Round((ShippedQty / BoxQty), 1, '>'); // fölfele kerekítés
                exit(RoundedQty);
            end else begin
                exit(0);
            end;
        end;
    end;

    local procedure SummUSD(Qty: Decimal; UnitPrice: Decimal; CurrCode: Code[10]): Decimal
    begin
        if (CurrCode = 'USD') and (Qty <> 0) and (UnitPrice <> 0) then begin
            USDTTL := USDTTL + (Qty * UnitPrice);

        end;
        exit(USDTTL);
    end;

    local procedure SummEUR(Qty: Decimal; UnitPrice: Decimal; CurrCode: Code[10]): Decimal
    begin
        if (CurrCode = 'EUR') and (Qty <> 0) and (UnitPrice <> 0) then begin
            EURTTL := EURTTL + (Qty * UnitPrice);

        end;
        exit(EURTTL);
    end;

    local procedure SummEURQty(Qty: Decimal; UnitCode: Code[10]; CurrCode: Code[10]): Decimal
    begin
        if (CurrCode = 'EUR') and (Qty <> 0) then begin
            if UnitCode = 'PC' then begin
                EURQTY := EURQTY + Qty;
            end else begin
                EURQTY := EURQTY + (Qty * 1000);
            end;

        end;
        exit(EURQTY);
    end;

    local procedure SummUSDQty(Qty: Decimal; UnitCode: Code[10]; CurrCode: Code[10]): Decimal
    begin
        if (CurrCode = 'USD') and (Qty <> 0) then begin
            if UnitCode = 'PC' then begin
                USDQTY := USDQTY + Qty;
            end else begin
                USDQTY := USDQTY + (Qty * 1000);
            end;

        end;
        exit(USDQTY);
    end;
}