report 50035 "SEI Proforma invoice"
{
    Caption = 'SEI Proforma invoice', Locked = true;

    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC; //RDLC VS megnyitása csakkor lesz jó, ha van adatforrás
    RDLCLayout = '.src/report/rdlc/Rep50035.Prof-Inv.rdlc';

    dataset
    {
        dataitem("Warehouse Shipment Header"; "Warehouse Shipment Header")
        {
            column(WhseShipmentHeaderWhseHeadDNNo_; "No.") { }
            column(WhseShipmentHeaderShipment_Date; "Shipment Date") { }
            column(WhseShipmentHeaderPosting_Date; "Posting Date") { }
            column(ProfInvNumber; ProfInvNumber) { }
            column(Shipment_Method_Code; "Shipment Method Code") { }


            dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                column(WhseShipmentLineDNNo_; "No.") { }
                column(WhseShipmentLineItem_No_; "Item No.") { }
                column(WhseSgipmentLineDescription; Description) { }
                column(WhseShipmentLineOrderNo_; "Source No.") { }
                column(WhseShipmentLineCustNo; "Destination No.") { }
                column(WhseShipmentLineQuantity; Quantity) { }
                column(WhseShipmentLineQtyToShip; "Qty. to Ship (Base)") { }
                column(WhseShipmentLineSEI_Box_Quantity; "SEI Box Quantity") { }
                column(WhseShipmentWeight; Weight) { }
                column(TariffNo; GetTarrifCode("Item No.")) { }
                column(OriginCode; GetOriginCode("Item No.")) { }
                column(UnitCode; GetUnitCode("Item No.")) { }
                column(CustomerItem; GetCustomerNumber("Item No.", GetUnitCode("Item No."))) { }
                column(ShipmentUnitOfMeasure; GetShippingUnitCode("Item No.")) { }
                column(BoxNumber; GetNumberOfBoxes("Item No.", GetShippingUnitCode("Item No."), "Qty. to Ship (Base)")) { }
                column(ShipmentWeight; CalculateWeight("Item No.", GetShippingUnitCode("Item No."), "Qty. to Ship (Base)")) { }
                column(GetProformaPrice; GetProformaPrice("Item No.", "Destination No.", Quantity)) { }

                dataitem("Sales Header"; "Sales Header")
                {

                    DataItemLink = "No." = field("Source No.");
                    column(SalesHSalesLineNo_; "No.") { }
                    column(SalesHSEI_SAP_SO_No_; "SEI SAP SO No.") { }
                    column(SalesHSEI_SAP_PO_No_; "SEI SAP PO No.") { }
                    column(SalesHSEI_Customer_Ref__No_; "SEI Customer Ref. No.") { }
                    column(SalesHSell_to_Contact; "Sell-to Contact") { }
                    column(SalesHSell_to_Phone_No_; "Sell-to Phone No.") { }
                    column(SalesHSell_to_Customer_Name; "Sell-to Customer Name") { }
                    column(SalesHSell_to_Address; "Sell-to Address") { }
                    column(SalesHSell_to_City; "Sell-to City") { }
                    column(SalesHSell_to_Post_Code; "Sell-to Post Code") { }
                    column(SalesHBill_to_Name; "Bill-to Name") { }
                    column(SalesHBill_to_Contact; "Bill-to Contact") { }
                    column(SalesHBill_to_Address; "Bill-to Address") { }
                    column(SalesHBill_to_City; "Bill-to City") { }
                    column(SalesHBill_to_Post_Code; "Bill-to Post Code") { }
                    column(SalesHShip_to_Name; "Ship-to Name") { }
                    column(SalesHShip_to_Address; "Ship-to Address") { }
                    column(SalesHShip_to_Address_2; "Ship-to Address 2") { }
                    column(SalesHShip_to_City; "Ship-to City") { }
                    column(SalesHShip_to_Post_Code; "Ship-to Post Code") { }
                    column(SalesHSell_to_Customer_No_; "Sell-to Customer No.") { }
                    column(IsProforma; GetProformaMode("Sell-to Customer No.")) { }
                    column(DeliveryNoteComment; GetDeliveryNoteComment("Sell-to Customer No.")) { }
                    column(CurrencyCode; GetCurrencyCode("Sales Header"."Currency Code")) { }

                    trigger OnPreDataItem()
                    begin
                        "Sales Header".SetRange("Sales Header"."No.", "Warehouse Shipment Line"."Source No.");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    "Warehouse Shipment Line".SetRange("Warehouse Shipment Line"."No.", "Warehouse Shipment Header"."No.");

                end;

            }
            trigger OnPreDataItem()
            begin
                "Warehouse Shipment Header".SetRange("Warehouse Shipment Header"."No.", WhseShipment);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Select Warehouse Shipment"; "WhseShipment")
                    {
                        ApplicationArea = All;
                        TableRelation = "Warehouse Shipment Header";

                    }
                    field("Enter proforma invoice number"; ProfInvNumber)
                    {
                        ApplicationArea = All;
                    }
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

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    labels
    {
        LblReportTitleDN = 'Proforma invoice / Proforma számla', Locked = true;
        LblReportTitle_1 = 'Proforma invoice / Proforma számla', Locked = true;
        LblReportTitle_2 = '', Locked = true;
        LblDocNo = 'Document No.', Locked = true;
        LblDeliveryDate = 'Delivery date', Locked = true;
        LblPage = 'Page', Locked = true;
        LblCustNo = 'Customer No.', Locked = true;
        LblSAPSONo = 'SAP SO No.', Locked = true;
        LblCustRefNo = 'Customer ref. No.', Locked = true;
        LblContact = 'Contact', Locked = true;
        LblPhone = 'Phone No.', Locked = true;
        LblSalesPerson = 'Sales person', Locked = true;
        LblBillDetail = 'Billing details', Locked = true;
        LblShipDetail = 'Shipping details', Locked = true;
        LblItemNo = 'Item No.', Locked = true;
        LblItemDesc = 'Description', Locked = true;
        LblItemQty = 'Qty', Locked = true;
        LblUnitCode = 'Unit', Locked = true;
        LblBox = 'Box num.', Locked = true;
        LblWeight = 'Weight', Locked = true;
        LblCustItemNo = 'Customer item No.', Locked = true;
        LblTariffNo = 'Tariff No.', Locked = true;
        LblOrigin = 'Origin', Locked = true;
        LblFooterText1 = 'Based on purchase order', Locked = true;
        LblFooterText2 = 'All business is subject to our general terms and conditions of sales found on http://www.sumi-electric.eu', Locked = true;
        LblFooterText3 = 'Delivery confirmation', Locked = true;
        LblFooterText4 = 'Values for customs purposes only. This invoice is for customs purposes in Hungary and in the destination country!', Locked = true;
        LblPreparedby = 'Prepared by', Locked = true;
        LblTotals = 'Total :', Locked = true;
        LblProfUnitPrice = 'Prof. unit price', Locked = true;
        LblTTLPrice = 'TTL prof. price', Locked = true;
        LblShipmentMethod = 'Shipment method', Locked = true;
        LblCurrCode = 'Currency code', Locked = true;
    }
    var
        SEIItem, SEIITem2 : Record Item;
        SEIIItemReference: Record "Item Reference";
        SEIItemUnitOfMeasure: Record "Item Unit of Measure";
        SEICustomer: Record Customer;
        WhseShipment: Code[20];
        ProfInvNumber: Code[50];
        SalesPrices: Record "Price List Line";
        CurrencyCode_50035: Text;

    local procedure GetProformaPrice(Item: Code[20]; CustNumber: Code[20]; ShipQty: Decimal): Decimal
    var
        isCustomerCode: Boolean;
        Result: Decimal;
        isValid: Boolean;
    begin
        isCustomerCode := false;
        isValid := false;
        Result := 0;
        SalesPrices.SetFilter("Product No.", Item);

        // if SalesPrices."Source Type" = SalesPrices."Source Type"::"All Customers" then begin
        //     //SalesPrices.SetRange(SalesPrices."Source Type", SalesPrices."Source Type"::"All Customers");
        // end else begin
        //     SalesPrices.SetRange(SalesPrices."Source No.", CustNumber);
        // end;

        if SalesPrices.Find('-') then begin //megkeresi az első rekordot
            repeat // a ciklus hozzáadja az actual work time-hoz az értéket, addig megy amíg nem lesz másik rekord
                   // if SalesPrices."Ending Date" = 0D then begin // ha az ending date üres
                   //     isValid := true;

                // end;
                // if NOT(isValid) and (DATE2DMY(SalesPrices."Ending Date", 3) = DATE2DMY(Today, 3)) then begin

                if (SalesPrices."Source No." = CustNumber) and (SalesPrices."Starting Date" <= Today) and (SalesPrices."Ending Date" >= Today) then begin
                    isCustomerCode := true;
                    Result := SalesPrices."SEI Proform Invoice Price";
                end;

                if (isCustomerCode = false) and (SalesPrices."Source No." = '') and (SalesPrices."Starting Date" <= Today) and (SalesPrices."Ending Date" >= Today) then begin
                    Result := SalesPrices."SEI Proform Invoice Price";
                    isCustomerCode := false;
                end;

            until (SalesPrices.Next = 0);
            exit(Result); // ha a cikluson belül van kiugrik a ciklusból, ha a feltétel teljesül és nem megy végig a ciklus!!!
        end;
    end;

    local procedure GetTarrifCode(Item: Code[20]): Code[20]
    var
        TariffNo: Code[20];
    begin
        SEIItem.Get(Item);
        TariffNo := SEIItem."Tariff No.";
        exit(TariffNo);
    end;

    local procedure GetOriginCode(Item: Code[20]): Code[10]
    var
        OriginCode: Code[10];
    begin
        SEIItem.Get(Item);
        OriginCode := SEIItem."Country/Region of Origin Code";
        exit(OriginCode);
    end;

    local procedure GetUnitCode(Item: Code[20]): Code[10]
    var
        UnitCode: Code[10];
    begin
        SEIItem.Get(Item);
        UnitCode := SEIItem."Base Unit of Measure";
        exit(UnitCode);
    end;

    local procedure GetShippingUnitCode(Item: Code[20]): Code[10]
    var
        ShippingUnitCode: Code[10];
    begin
        SEIItem.Get(Item);
        ShippingUnitCode := SEIItem."SEI Shipment Unit of Measure";
        exit(ShippingUnitCode);
    end;
    //A .get esetében minden kulcs mezőt át kell adni. Ha nincs meg minden akkor a .setfilter és a find kombinációja a barátunk.
    local procedure GetCustomerNumber(Item: Code[20]; UnitCode: Code[10]): Code[50]
    var
        CustomerCode: Code[50];
    begin
        SEIIItemReference.SetFilter("Item No.", Item);
        //SEIIItemReference.Get(Item, '', UnitCode);
        if SEIIItemReference.Find('+') then
            CustomerCode := SEIIItemReference."Reference No.";
        exit(CustomerCode);
    end;

    local procedure GetNumberOfBoxes(Item: Code[20]; UnitOfShipment: Code[10]; ShippedQty: Decimal): Decimal
    var
        BoxNumber: Decimal;
        BoxQty: Decimal;
        RoundedQty: Decimal;

    begin
        SEIItemUnitOfMeasure.Get(Item, UnitOfShipment);
        BoxQty := SEIItemUnitOfMeasure."Qty. per Unit of Measure";
        RoundedQty := Round((ShippedQty / BoxQty), 1, '>'); // fölfele kerekítés
        exit(RoundedQty);
    end;

    local procedure GetProformaMode(CustomerCode: Code[20]): Boolean
    var
    //IsProforma: Boolean;
    begin
        SEICustomer.Get(CustomerCode);
        exit(SEICustomer."SEI Proforma");
    end;

    local procedure GetDeliveryNoteComment(customerCode: Code[20]) returnStr: Text
    var
        comment: InStream;
        retunrStr: Text;
    begin
        retunrStr := '';
        SEICustomer.Get(customerCode);
        SEICustomer.CalcFields("SEI Shipment Comment");
        SEICustomer."SEI Shipment Comment".CreateinStream(comment);
        comment.Read(retunrStr);
        exit(retunrStr);

    end;

    local procedure CalculateWeight(Item: Code[20]; UnitOfShipment: Code[10]; ShippedQty: Decimal): Decimal
    var
        BoxUnitWeight: Decimal;
        PackWeight: Decimal;
        UnitWeight: Decimal;
        BoxQty: Decimal;
    begin
        // BoxUnitWeight := 0;
        // PackWeight := 0;
        // UnitWeight := 0;
        SEIItemUnitOfMeasure.Get(Item, UnitOfShipment);
        SEIITem2.Get(Item);
        PackWeight := SEIItemUnitOfMeasure."SEI Wrapping Weight"; /// SEIItemUnitOfMeasure."Qty. per Unit of Measure"; 3,07
        UnitWeight := SEIItem2."Net Weight"; //1000-darabra vonatkozó súly kg-ben
        BoxQty := Round(ShippedQty / SEIItemUnitOfMeasure."Qty. per Unit of Measure", 1, '>');
        exit((UnitWeight * ShippedQty) + (PackWeight * BoxQty));
    end;

    procedure GetCurrencyCode(CurCode: Code[10]): Text;
    begin
        if "Sales Header"."Currency Code" = ''
        then begin
            CurrencyCode_50035 := 'EUR';
            exit(CurrencyCode_50035);
        end
        else begin
            CurrencyCode_50035 := "Sales Header"."Currency Code";
            exit(CurrencyCode_50035);
        end;

    end;
}