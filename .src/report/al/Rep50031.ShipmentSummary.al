report 50031 "SEI Shipment Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50031.ShipmentSummary.rdlc';
    ApplicationArea = All;
    Caption = 'SEI Shipment Summary', Locked = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
        {
            column(WhseShipLineRSZLNo_; "No.") { }
            column(Line_No_; "Line No.") { }
            column(WhseShipLineItem_No_; "Item No.") { }
            column(WhseShipLineNAVOrderNo; "Source No.") { }
            column(WhseShipLineDescription; Description) { }
            column(WhseShipLineDescription_2; "Description 2") { }
            column(WhseShipLineQty__to_Ship; "Qty. to Ship") { }
            column(WhseShipLineUMC; "Unit of Measure Code") { }
            column(WhseShipLineDestNo; "Destination No.") { }
            column(WhseShipLineWeight; Weight) { }
            column(WhseShipLineBoxQty; "SEI Box Quantity") { }
            column(WhseShipLineIsShowPrice; IsShowPrice) { }
            column(WhseShipLinecommentToDocuments; commentToDocuments) { }
            column(Shipment_Date; "Shipment Date") { }
            column(SAPOrderNumbar; GetExtDocNum("Warehouse Shipment Line"."No.")) { }
            column(OriginCode; GetOriginCode("Warehouse Shipment Line"."Item No.")) { }
            column(GetPostingDate; GetPostingDate("No.")) { }


            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "No." = field("Source No.");
                column(Posting_Date; "Posting Date") { }
                column(Bill_to_Name; "Bill-to Name") { }
                column(Bill_to_Address; "Bill-to Address") { }
                column(Bill_to_Address_2; "Bill-to Address 2") { }
                column(Bill_to_City; "Bill-to City") { }
                column(Bill_to_Post_Code; "Bill-to Post Code") { }
                column(Bill_to_Contact; "Bill-to Contact") { }
                column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
                column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
                column(Ship_to_Name; "Ship-to Name") { }
                column(Ship_to_Address; "Ship-to Address") { }
                column(Ship_to_Address_2; "Ship-to Address 2") { }
                column(Ship_to_City; "Ship-to City") { }
                column(Ship_to_Post_Code; "Ship-to Post Code") { }
                column(Ship_to_Contact; "Ship-to Contact") { }
                column(SEI_Customer_Ref__No_; "SEI Customer Ref. No.") { }
                //column(SEI_SAP_SO_No_; "SEI SAP SO No.") { }
                column(Document_Type; "Document Type") { }
                column(SalesLineUnitPrice; GetUnitPrice("Warehouse Shipment Line"."Item No.", "Sales Header"."No.")) { }
                column(ShipmentValue; "Warehouse Shipment Line"."Qty. to Ship" * GetUnitPrice("Warehouse Shipment Line"."Item No.", "Sales Header"."No.")) { }
                column(CustomerItemNumber; GetCustomerItemNumber("Warehouse Shipment Line"."Item No.", "Sell-to Customer No.")) { }
                column(GetDeliveryNoteComment; GetDeliveryNoteComment("Sell-to Customer No.")) { }


                trigger OnAfterGetRecord()
                begin
                    "Sales Header".SetRange("Document Type", "Document Type"::Order);
                end;

            }

            trigger OnPreDataItem()
            begin
                if RPShipmentDate <> 0D then begin
                    "Warehouse Shipment Line".SetRange("Warehouse Shipment Line"."Shipment Date", RPShipmentDate, RPShipmentDate);
                end;
                "Warehouse Shipment Line".SetFilter("Destination No.", DestNumber);
            end;

        }


    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Details)
                {
                    field(Description; commentToDocuments)
                    {
                        ApplicationArea = All;

                    }
                    field("Show Price"; IsShowPrice)
                    {
                        ApplicationArea = All;
                    }
                    field("Date of shipment"; RPShipmentDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Destination number"; DestNumber)
                    {
                        ApplicationArea = All;
                        TableRelation = Customer."No.";
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

    labels
    {
        LblReportTitle = 'Shipment summary / Lieferungszusammenfassung / Totaliser de expédition / Totalizzatore di trasporto / Szállítási összesítő', Locked = true;
        LblSalesEmployee = 'Sales employee', Locked = true;
        LblTelephone = 'Telephone', Locked = true;
        LblContact = 'Contact', Locked = true;
        LblShippingDetalil = 'Shipping detail', Locked = true;
        LblBillingDetail = 'Billing detail', Locked = true;
        LblCustNo = 'Cust. ord.', Locked = true;
        LblDelDate = 'Delivery date', Locked = true;
        LblDocNo = 'Doc. No.', Locked = true;
        LblSAPSONo = 'SAP SO No.', Locked = true;
        LblCustRefNo = 'Customer item no.', Locked = true;
        LblItemNo = 'Item No.', Locked = true;
        LblDesc = 'Description', Locked = true;
        LblQty = 'Qty.', Locked = true;
        LblUnit = 'Unit', Locked = true;
        LblBox = 'Box', Locked = true;
        LblWeight = 'Weig.', Locked = true;
        LblTotal = 'Total', Locked = true;
        LblPrice = 'Ship pr.', Locked = true;
        LblPage = 'Page', Locked = true;
        LblOrigin = 'Country of origin', Locked = true;

    }

    var
        myInt: Integer;
        commentToDocuments: Code[50];
        IsShowPrice: Boolean;
        RPShipmentDate: Date;
        DestNumber: Code[20];
        SalesLine: Record "Sales Line";
        WhseShipHeader: Record "Warehouse Shipment Header";
        ItemRec: Record Item;
        ItemReferenceRec: Record "Item Reference";

    local procedure GetUnitPrice(Item: Code[20]; OrderNum: Code[20]): Decimal
    begin
        SalesLine.SetFilter("Document Type", '1');
        SalesLine.SetFilter("Document No.", OrderNum);
        SalesLine.SetFilter("No.", Item);
        if SalesLine.Find('+') then
            exit(SalesLine."Unit Price");

    end;

    local procedure GetExtDocNum(No: Code[20]): Text
    begin
        WhseShipHeader.Get(No);
        exit(WhseShipHeader."External Document No.");
    end;

    local procedure GetOriginCode(Item: code[20]): Text
    begin
        ItemRec.Get(Item);
        exit(ItemRec."Country/Region of Origin Code");
    end;

    local procedure GetCustomerItemNumber(Item: Code[20]; CustNo: Code[20]): Text
    begin
        ItemReferenceRec.SetFilter("Reference Type", '1');
        ItemReferenceRec.SetFilter("Reference Type No.", CustNo);
        ItemReferenceRec.SetFilter("Item No.", Item);
        if ItemReferenceRec.Find('+') then
            exit(ItemReferenceRec."Reference No.");
    end;

    local procedure GetPostingDate(DocNo: Code[20]): Date
    var
        WhseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        WhseShipmentHeader.Get(DocNo);
        exit(WhseShipmentHeader."Posting Date");
    end;

    local procedure GetDeliveryNoteComment(customerCode: Code[20]) returnStr: Text
    var
        comment: InStream;
        retunrStr: Text;
        SEICustomer: Record Customer;
    begin
        retunrStr := '';
        SEICustomer.Get(customerCode);
        SEICustomer.CalcFields("SEI Shipment Comment");
        SEICustomer."SEI Shipment Comment".CreateinStream(comment);
        comment.Read(retunrStr);
        exit(retunrStr);

    end;
}