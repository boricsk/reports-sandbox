report 50036 "SEI Posted Delivery Note"
{
    Caption = 'SEI Posted Delivery Note', Locked = true;

    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC; //RDLC VS megnyitása csakkor lesz jó, ha van adatforrás
    RDLCLayout = '.src/report/rdlc/Rep50036.Posted Delivery Note.rdlc';

    dataset
    {
        dataitem("Posted Whse. Shipment Header"; "Posted Whse. Shipment Header")
        {

            column(WhseShipmentHeaderWhseHeadDNNo_; "Whse. Shipment No.") { }
            column(WhseShipmentHeaderShipment_Date; "Shipment Date") { }
            column(WhseShipmentHeaderPosting_Date; "Posting Date") { }
            column(WhseShipmentHeaderNo; "No.") { }


            dataitem("Posted Whse. Shipment Line"; "Posted Whse. Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                column(WhseShipmentLineDNNo_; "No.") { }
                column(WhseShipmentLineItem_No_; "Item No.") { }
                column(WhseSgipmentLineDescription; Description) { }
                column(WhseShipmentLineOrderNo_; "Source No.") { }
                column(WhseShipmentLineCustNo; "Destination No.") { }

                column(WhseShipmentLineQuantity; Quantity) { }
                //column(WhseShipmentLineQtyToShip; "Qty. to Ship (Base)") { }
                column(WhseShipmentLineSEI_Box_Quantity; "SEI Box Quantity") { }
                column(Posted_Source_No_; "Posted Source No.") { }
                //column(WhseShipmentWeight; Weight) { }
                column(TariffNo; GetTarrifCode("Item No.")) { }
                column(OriginCode; GetOriginCode("Item No.")) { }
                column(UnitCode; GetUnitCode("Item No.")) { }
                column(CustomerItem; GetCustomerNumber("Item No.", GetUnitCode("Item No."))) { }
                column(ShipmentUnitOfMeasure; GetShippingUnitCode("Item No.")) { }
                column(BoxNumber; GetNumberOfBoxes("Item No.", GetShippingUnitCode("Item No."), Quantity)) { }
                column(WhseShipmentWeight; CalculateWeight("Item No.", GetShippingUnitCode("Item No."), Quantity)) { }


                dataitem("Sales Shipment Header"; "Sales Shipment Header")
                {

                    DataItemLink = "No." = field("Posted Source No.");
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

                    trigger OnPreDataItem()
                    begin
                        "Sales Shipment Header".SetRange("Sales Shipment Header"."No.", "Posted Whse. Shipment Line"."Posted Source No.");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    "Posted Whse. Shipment Line".SetRange("Posted Whse. Shipment Line"."No.", "Posted Whse. Shipment Header"."No.");

                end;

            }

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
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

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
        LblReportTitleDN = 'Delivery Note / Lieferschein / Bon de Livraison / Consegna / Szállítólevél', Locked = true;
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
        LblItemQty = 'Quantity', Locked = true;
        LblUnitCode = 'Unit', Locked = true;
        LblBox = 'Box num.', Locked = true;
        LblWeight = 'Weight', Locked = true;
        LblCustItemNo = 'Customer item No.';
        LblTariffNo = 'Tariff No.', Locked = true;
        LblOrigin = 'Origin', Locked = true;
        LblFooterText1 = 'Based on purchase order :', Locked = true;
        LblFooterText2 = 'All business is subject to our general terms and conditions of sales found on http://www.sumi-electric.eu', Locked = true;
        LblFooterText3 = 'Delivery confirmation', Locked = true;
        LblTotals = 'Total :', Locked = true;
    }
    var
        SEIItem, SEIITem2 : Record Item;
        SEIIItemReference: Record "Item Reference";
        SEIItemUnitOfMeasure: Record "Item Unit of Measure";
        SEICustomer: Record Customer;


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
}